using CorporatePortal.API.Services;
using Prometheus;

namespace CorporatePortal.API.Infrastructure.Middleware
{
    public class PerformanceMonitoringMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<PerformanceMonitoringMiddleware> _logger;
        private readonly IAlertService _alertService;

        // Prometheus метрики
        private static readonly Counter RequestCounter = Metrics.CreateCounter("http_requests_total", "Total HTTP requests", new CounterConfiguration
        {
            LabelNames = new[] { "method", "endpoint", "status" }
        });

        private static readonly Histogram RequestDuration = Metrics.CreateHistogram("http_request_duration_seconds", "HTTP request duration", new HistogramConfiguration
        {
            LabelNames = new[] { "method", "endpoint" },
            Buckets = new[] { 0.1, 0.25, 0.5, 1, 2.5, 5, 10 }
        });

        public PerformanceMonitoringMiddleware(RequestDelegate next, ILogger<PerformanceMonitoringMiddleware> logger, IAlertService alertService)
        {
            _next = next;
            _logger = logger;
            _alertService = alertService;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            var startTime = DateTime.UtcNow;
            var stopwatch = System.Diagnostics.Stopwatch.StartNew();

            try
            {
                await _next(context);
            }
            finally
            {
                stopwatch.Stop();
                var duration = stopwatch.Elapsed.TotalSeconds;
                var statusCode = context.Response.StatusCode;
                var method = context.Request.Method;
                var endpoint = GetEndpoint(context);

                // Записываем метрики
                RequestCounter.WithLabels(method, endpoint, statusCode.ToString()).Inc();
                RequestDuration.WithLabels(method, endpoint).Observe(duration);

                // Проверяем p99 latency (500ms = 0.5s)
                if (duration > 0.5)
                {
                    _logger.LogWarning("Slow request detected: {Method} {Endpoint} took {Duration:F2}s", 
                        method, endpoint, duration);
                    
                    // Отправляем алерт если превышен порог
                    await _alertService.SendPerformanceAlertAsync(endpoint, duration * 1000, 500);
                }

                _logger.LogDebug("Request {Method} {Endpoint} completed in {Duration:F3}s with status {StatusCode}", 
                    method, endpoint, duration, statusCode);
            }
        }

        private static string GetEndpoint(HttpContext context)
        {
            var path = context.Request.Path.Value ?? "";
            var method = context.Request.Method;

            // Упрощаем endpoint для группировки
            if (path.StartsWith("/api/orders"))
                return "/api/orders";
            if (path.StartsWith("/api/auth"))
                return "/api/auth";
            if (path.StartsWith("/api/chat"))
                return "/api/chat";
            if (path.StartsWith("/api/documents"))
                return "/api/documents";

            return path;
        }
    }

    public static class PerformanceMonitoringMiddlewareExtensions
    {
        public static IApplicationBuilder UsePerformanceMonitoring(this IApplicationBuilder builder)
        {
            return builder.UseMiddleware<PerformanceMonitoringMiddleware>();
        }
    }
} 