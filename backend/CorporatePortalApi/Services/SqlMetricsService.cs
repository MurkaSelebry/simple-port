using Microsoft.Data.SqlClient;
using System.Diagnostics.Metrics;
using Microsoft.Extensions.Hosting;

namespace CorporatePortalApi.Services
{
    public class SqlMetricsService : IHostedService
    {
        private readonly ILogger<SqlMetricsService> _logger;
        private readonly string _connectionString;
        private readonly Meter _meter;
        private readonly Counter<long> _sqlRpsCounter;
        private readonly Histogram<double> _sqlQueryDuration;
        private long _previousTotalRequests = 0;
        private DateTime _lastRpsCheck = DateTime.UtcNow;
        private Timer? _secondTimer;
        private Timer? _rpsTimer;

        public SqlMetricsService(ILogger<SqlMetricsService> logger, IConfiguration configuration)
        {
            _logger = logger;
            _connectionString = configuration.GetConnectionString("DefaultConnection") ?? "";
            
            _meter = new Meter("CorporatePortalApi.SqlServer", "1.0.0");
            _sqlRpsCounter = _meter.CreateCounter<long>("sql_server_rps", "requests_per_second", "SQL Server Requests Per Second");
            _sqlQueryDuration = _meter.CreateHistogram<double>("sql_query_duration_seconds", "seconds", "SQL Query Duration");
        }

        public async Task StartAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation("SqlMetricsService started - collecting metrics every second, calculating RPS every 10 seconds");
            
            if (string.IsNullOrEmpty(_connectionString))
            {
                _logger.LogWarning("SQL connection string is not configured, metrics collection disabled");
                return;
            }

            // Инициализируем начальное значение
            try
            {
                _previousTotalRequests = await GetTotalRequests();
                _lastRpsCheck = DateTime.UtcNow;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error initializing SQL metrics");
            }

            // Таймер для сбора метрик каждую секунду
            _secondTimer = new Timer(async _ => await CollectMetricsEverySecond(), null, TimeSpan.Zero, TimeSpan.FromSeconds(1));
            
            // Таймер для расчета RPS каждые 10 секунд
            _rpsTimer = new Timer(async _ => await CalculateAndLogRps(), null, TimeSpan.FromSeconds(10), TimeSpan.FromSeconds(10));
        }

        public Task StopAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation("SqlMetricsService stopped");
            
            _secondTimer?.Dispose();
            _rpsTimer?.Dispose();
            
            return Task.CompletedTask;
        }

        private async Task CollectMetricsEverySecond()
        {
            try
            {
                var totalRequests = await GetTotalRequests();
                _logger.LogInformation("SQL Total Requests: {TotalRequests}", totalRequests);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error collecting SQL metrics");
            }
        }

        private async Task CalculateAndLogRps()
        {
            try
            {
                var currentTotalRequests = await GetTotalRequests();
                var now = DateTime.UtcNow;
                var timeDiffSeconds = (now - _lastRpsCheck).TotalSeconds;

                if (_previousTotalRequests > 0 && timeDiffSeconds > 0)
                {
                    var rps = (currentTotalRequests - _previousTotalRequests) / timeDiffSeconds;
                    _logger.LogInformation("SQL RPS: {Rps:F2} (requests: {CurrentRequests} - {PreviousRequests} = {Diff} over {TimeDiff:F1}s)", 
                        rps, currentTotalRequests, _previousTotalRequests, currentTotalRequests - _previousTotalRequests, timeDiffSeconds);
                    
                    _sqlRpsCounter.Add((long)Math.Round(rps));
                }

                _previousTotalRequests = currentTotalRequests;
                _lastRpsCheck = now;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error calculating RPS");
            }
        }

        private async Task<long> GetTotalRequests()
        {
            if (string.IsNullOrEmpty(_connectionString))
                return 0;

            using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();

            var query = @"
                SELECT cntr_value AS total_requests
                FROM sys.dm_os_performance_counters
                WHERE counter_name = 'Batch Requests/sec'
                  AND object_name LIKE '%SQL Statistics%'";

            using var command = new SqlCommand(query, connection);
            var result = await command.ExecuteScalarAsync();
            return result != null ? Convert.ToInt64(result) : 0;
        }

        public void RecordQueryDuration(double durationSeconds)
        {
            _sqlQueryDuration.Record(durationSeconds);
        }

        // Метод для получения текущего RPS (если нужен для других сервисов)
        public async Task<double> GetCurrentRps()
        {
            try
            {
                var currentTotalRequests = await GetTotalRequests();
                var timeDiffSeconds = (DateTime.UtcNow - _lastRpsCheck).TotalSeconds;

                if (_previousTotalRequests > 0 && timeDiffSeconds > 0)
                {
                    return (currentTotalRequests - _previousTotalRequests) / timeDiffSeconds;
                }

                return 0;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting current RPS");
                return 0;
            }
        }
    }
}
