using Microsoft.AspNetCore.Mvc;
using CorporatePortalApi.Services;
using System.Diagnostics;

namespace CorporatePortalApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SqlMetricsController : ControllerBase
    {
        private readonly SqlMetricsService _sqlMetricsService;
        private readonly ILogger<SqlMetricsController> _logger;
        private static readonly ActivitySource ActivitySource = new("CorporatePortalApi.SqlServer");

        public SqlMetricsController(SqlMetricsService sqlMetricsService, ILogger<SqlMetricsController> logger)
        {
            _sqlMetricsService = sqlMetricsService;
            _logger = logger;
        }

        [HttpGet("rps")]
        public async Task<IActionResult> GetCurrentRps()
        {
            using var activity = ActivitySource.StartActivity("GetSqlRps");
            activity?.SetTag("sql.metrics.operation", "get_rps");
            
            var stopwatch = Stopwatch.StartNew();
            
            try
            {
                var rps = await _sqlMetricsService.GetCurrentRps();
                
                stopwatch.Stop();
                activity?.SetTag("sql.server.rps", rps);
                activity?.SetTag("sql.server.service", "CorporatePortalApi.SqlServer");
                activity?.SetTag("sql.metrics.duration_ms", stopwatch.ElapsedMilliseconds);
                
                _logger.LogInformation("SQL RPS: {Rps}, Duration: {DurationMs}ms", rps, stopwatch.ElapsedMilliseconds);
                
                return Ok(new
                {
                    rps = rps,
                    timestamp = DateTime.UtcNow,
                    duration_ms = stopwatch.ElapsedMilliseconds
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Ошибка при получении SQL RPS");
                activity?.SetTag("error", true);
                activity?.SetTag("error.message", ex.Message);
                return StatusCode(500, new { message = "Ошибка при получении SQL метрик" });
            }
        }

        [HttpGet("health")]
        public async Task<IActionResult> GetSqlHealth()
        {
            using var activity = ActivitySource.StartActivity("GetSqlHealth");
            activity?.SetTag("sql.metrics.operation", "health_check");
            
            try
            {
                var rps = await _sqlMetricsService.GetCurrentRps();
                var isHealthy = rps >= 0; // Если можем получить RPS, значит соединение работает
                
                activity?.SetTag("sql.server.healthy", isHealthy);
                activity?.SetTag("sql.server.rps", rps);
                activity?.SetTag("sql.server.service", "CorporatePortalApi.SqlServer");
                
                return Ok(new
                {
                    healthy = isHealthy,
                    rps = rps,
                    timestamp = DateTime.UtcNow,
                    service = "CorporatePortalApi.SqlServer"
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Ошибка при проверке здоровья SQL сервера");
                activity?.SetTag("error", true);
                activity?.SetTag("error.message", ex.Message);
                return StatusCode(500, new { 
                    healthy = false,
                    error = ex.Message,
                    timestamp = DateTime.UtcNow
                });
            }
        }
    }
} 