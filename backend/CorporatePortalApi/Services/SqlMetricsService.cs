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
        private long _previousBatchRequests = 0;
        private DateTime _lastCheck = DateTime.UtcNow;

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
            _logger.LogInformation("SqlMetricsService started");
            _ = Task.Run(async () =>
            {
                while (!cancellationToken.IsCancellationRequested)
                {
                    try
                    {
                        await CollectSqlMetrics();
                        await Task.Delay(TimeSpan.FromSeconds(10), cancellationToken);
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError(ex, "Error collecting SQL metrics");
                        await Task.Delay(TimeSpan.FromSeconds(30), cancellationToken);
                    }
                }
            }, cancellationToken);
        }

        public Task StopAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation("SqlMetricsService stopped");
            return Task.CompletedTask;
        }

        private async Task CollectSqlMetrics()
        {
            if (string.IsNullOrEmpty(_connectionString))
            {
                _logger.LogWarning("SQL connection string is not configured");
                return;
            }

            try
            {
                using var connection = new SqlConnection(_connectionString);
                await connection.OpenAsync();

                var currentBatchRequests = await GetBatchRequests(connection);
                var now = DateTime.UtcNow;
                var timeDiff = (now - _lastCheck).TotalSeconds;

                if (_previousBatchRequests > 0 && timeDiff > 0)
                {
                    var rps = (currentBatchRequests - _previousBatchRequests) / timeDiff;
                    _sqlRpsCounter.Add((long)rps);
                    _logger.LogInformation("SQL RPS: {Rps}", rps);
                }

                _previousBatchRequests = currentBatchRequests;
                _lastCheck = now;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error collecting SQL metrics");
            }
        }

        private async Task<long> GetBatchRequests(SqlConnection connection)
        {
            var query = @"
                SELECT cntr_value AS total_requests
                FROM sys.dm_os_performance_counters
                WHERE counter_name = 'Batch Requests/sec'
                  AND object_name LIKE '%SQL Statistics%'";

            using var command = new SqlCommand(query, connection);
            var result = await command.ExecuteScalarAsync();
            return result != null ? Convert.ToInt64(result) : 0;
        }

        public async Task<double> GetCurrentRps()
        {
            if (string.IsNullOrEmpty(_connectionString))
                return 0;

            try
            {
                using var connection = new SqlConnection(_connectionString);
                await connection.OpenAsync();
                var currentBatchRequests = await GetBatchRequests(connection);
                var now = DateTime.UtcNow;
                var timeDiff = (now - _lastCheck).TotalSeconds;

                if (_previousBatchRequests > 0 && timeDiff > 0)
                {
                    return (currentBatchRequests - _previousBatchRequests) / timeDiff;
                }

                return 0;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting current RPS");
                return 0;
            }
        }

        public void RecordQueryDuration(double durationSeconds)
        {
            _sqlQueryDuration.Record(durationSeconds);
        }
    }
} 
