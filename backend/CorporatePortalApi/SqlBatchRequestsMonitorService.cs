using System.Net.Http;
using System.Text;

using Microsoft.Data.SqlClient;

namespace CorporatePortalApi.Services
{
    public class SqlBatchRequestsMonitorService : IHostedService
    {
        private readonly ILogger<SqlBatchRequestsMonitorService> _logger;
        private readonly string _connectionString;
        private Timer? _queryTimer;
        private Timer? _rpsTimer;
        private long _totalRequestsPrev = 0;
        private readonly object _lockObject = new object();
        private CancellationTokenSource? _cancellationTokenSource;

        public SqlBatchRequestsMonitorService(ILogger<SqlBatchRequestsMonitorService> logger, IConfiguration configuration)
        {
            _logger = logger;
            _connectionString = configuration.GetConnectionString("DefaultConnection") ?? "";
        }

        public Task StartAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation("SqlBatchRequestsMonitorService запущен");

            if (string.IsNullOrEmpty(_connectionString))
            {
                _logger.LogWarning("SQL connection string не настроен, сервис не может запуститься");
                return Task.CompletedTask;
            }

            _cancellationTokenSource = new CancellationTokenSource();

            // Таймер для запроса каждую секунду
            _queryTimer = new Timer(QueryBatchRequests, null, TimeSpan.Zero, TimeSpan.FromSeconds(1));

            // Таймер для вычисления RPS каждые 10 секунд
            _rpsTimer = new Timer(CalculateAndLogRps, null, TimeSpan.FromSeconds(10), TimeSpan.FromSeconds(10));

            return Task.CompletedTask;
        }

        public Task StopAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation("SqlBatchRequestsMonitorService остановлен");

            _queryTimer?.Dispose();
            _rpsTimer?.Dispose();
            _cancellationTokenSource?.Cancel();
            _cancellationTokenSource?.Dispose();

            return Task.CompletedTask;
        }

        private async void QueryBatchRequests(object? state)
        {
            if (_cancellationTokenSource?.Token.IsCancellationRequested == true)
                return;

            try
            {
                using var connection = new SqlConnection(_connectionString);
                await connection.OpenAsync(_cancellationTokenSource?.Token ?? CancellationToken.None);

                var query = @"
                    SELECT cntr_value AS total_requests
                    FROM sys.dm_os_performance_counters
                    WHERE counter_name = 'Batch Requests/sec'
                      AND object_name LIKE '%SQL Statistics%'";

                using var command = new SqlCommand(query, connection);
                var result = await command.ExecuteScalarAsync(_cancellationTokenSource?.Token ?? CancellationToken.None);
                
                if (result != null)
                {
                    var totalRequests = Convert.ToInt64(result);
                    _logger.LogInformation("SQL Batch Requests - total_requests: {TotalRequests}", totalRequests);

                    lock (_lockObject)
                    {
                        if (_totalRequestsPrev == 0)
                        {
                            _totalRequestsPrev = totalRequests;
                        }
                    }
                }
                else
                {
                    _logger.LogWarning("Не удалось получить значение Batch Requests из SQL Server");
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Ошибка при выполнении запроса Batch Requests");
            }
        }

        private async void CalculateAndLogRps(object? state)
        {
            if (_cancellationTokenSource?.Token.IsCancellationRequested == true)
                return;

            try
            {
                using var connection = new SqlConnection(_connectionString);
                await connection.OpenAsync(_cancellationTokenSource?.Token ?? CancellationToken.None);

                var query = @"
                    SELECT cntr_value AS total_requests
                    FROM sys.dm_os_performance_counters
                    WHERE counter_name = 'Batch Requests/sec'
                      AND object_name LIKE '%SQL Statistics%'";

                using var command = new SqlCommand(query, connection);
                var result = await command.ExecuteScalarAsync(_cancellationTokenSource?.Token ?? CancellationToken.None);

                if (result != null)
                {
                    double rps = 0;
long totalNow = totalRequestsNow;
long totalPrev = 0;

lock (_lockObject)
{
    if (_totalRequestsPrev > 0)
    {
        totalPrev = _totalRequestsPrev;
        rps = (totalNow - totalPrev) / 10.0;
    }

    _totalRequestsPrev = totalNow;
}

_logger.LogInformation("SQL RPS = ({TotalRequestsNow} - {TotalRequestsPrev}) / 10 = {Rps}", 
    totalNow, totalPrev, rps);

if (rps > 100)
{
    using var httpClient = new HttpClient();

    var json = @"{
        ""alerts"": [
            {
                ""status"": ""firing"",
                ""labels"": {
                    ""severity"": ""critical"",
                    ""alert_type"": ""SQL RPS"",
                    ""service"": ""sql-server"",
                    ""instance"": ""CorporatePortalApi""
                },
                ""annotations"": {
                    ""summary"": ""High SQL RPS"",
                    ""description"": ""SQL Batch Requests RPS exceeded threshold: " + rps + @"""
                },
                ""value"": """ + rps + @"""
            }
        ]
    }";

    var content = new StringContent(json, Encoding.UTF8, "application/json");

    try
    {
        var response = httpClient.Post("http://51.250.42.128:8081/alert", content);
        if (!response.IsSuccessStatusCode)
        {
            _logger.LogWarning("Не удалось отправить алерт: {StatusCode} - {Reason}", response.StatusCode, response.ReasonPhrase);
        }
    }
    catch (Exception ex)
    {
        _logger.LogError(ex, "Ошибка при отправке HTTP-алерта");
    }
}

                }
                else
                {
                    _logger.LogWarning("Не удалось получить значение Batch Requests для расчета RPS");
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Ошибка при расчете RPS");
            }
        }
    }
}
