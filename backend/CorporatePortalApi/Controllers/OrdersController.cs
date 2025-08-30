using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using CorporatePortalApi.Data;
using CorporatePortalApi.Models;
using CorporatePortalApi.Services;
using System.Diagnostics;

namespace CorporatePortalApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class OrdersController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<OrdersController> _logger;
        private readonly SqlMetricsService _sqlMetricsService;
        private static readonly ActivitySource ActivitySource = new("CorporatePortalApi.Orders");

        public OrdersController(ApplicationDbContext context, ILogger<OrdersController> logger, SqlMetricsService sqlMetricsService)
        {
            _context = context;
            _logger = logger;
            _sqlMetricsService = sqlMetricsService;
        }

        [HttpGet]
        public async Task<IActionResult> GetOrders([FromQuery] string? status = null, [FromQuery] string? priority = null)
        {
            using var activity = ActivitySource.StartActivity("GetOrders");
            activity?.SetTag("orders.filter.status", status);
            activity?.SetTag("orders.filter.priority", priority);
            
            var stopwatch = Stopwatch.StartNew();
            
            try
            {
                _logger.LogInformation("Запрос заказов. Статус: {Status}, Приоритет: {Priority}", status, priority);

                // Имитация задержки для тестирования производительности
                if (status?.Contains("slow") == true || priority?.Contains("slow") == true)
                {
                    using var delayActivity = ActivitySource.StartActivity("SimulateSlowOperation");
                    delayActivity?.SetTag("delay.reason", "artificial_slowness");
                    delayActivity?.SetTag("delay.duration_ms", 700);
                    await Task.Delay(700); // Искусственная задержка для тестирования p99 > 500ms
                }

                using var dbActivity = ActivitySource.StartActivity("DatabaseQuery");
                dbActivity?.SetTag("db.operation", "select_orders");

                var query = _context.Orders
                    .Include(o => o.AssignedUser)
                    .AsQueryable();

                if (!string.IsNullOrEmpty(status))
                {
                    if (Enum.TryParse<OrderStatus>(status, true, out var orderStatus))
                    {
                        query = query.Where(o => o.Status == orderStatus);
                        dbActivity?.SetTag("db.filter.status", status);
                    }
                }

                if (!string.IsNullOrEmpty(priority))
                {
                    query = query.Where(o => o.Priority == priority);
                    dbActivity?.SetTag("db.filter.priority", priority);
                }

                var orders = await query
                    .OrderByDescending(o => o.CreatedAt)
                    .ToListAsync();
                
                dbActivity?.SetTag("db.result.count", orders.Count);

                // ИСПРАВЛЕНО: Убрали N+1 Query проблему
                // Теперь пользователи загружаются эффективно через .Include()

                stopwatch.Stop();
                
                // SQL Metrics Integration
                var sqlRps = await _sqlMetricsService.GetCurrentRps();
                dbActivity?.SetTag("sql.server.rps", sqlRps);
                dbActivity?.SetTag("sql.server.service", "CorporatePortalApi.SqlServer");
                
                // Проверяем флаг SQL метрик из load tester
                if (Request.Headers.ContainsKey("x-sql-metrics"))
                {
                    dbActivity?.SetTag("load.test.sql.metrics", true);
                    dbActivity?.SetTag("load.test.trace.id", Request.Headers["x-trace-id"].ToString());
                }
                
                _sqlMetricsService.RecordQueryDuration(stopwatch.Elapsed.TotalSeconds);
                
                _logger.LogInformation("Получено {Count} заказов за {ElapsedMs}ms, SQL RPS: {SqlRps}", 
                    orders.Count, stopwatch.ElapsedMilliseconds, sqlRps);

                return Ok(new
                {
                    orders = orders.Select(o => new
                    {
                        id = o.Id,
                        title = o.Title,
                        description = o.Description,
                        status = o.Status.ToString(),
                        priority = o.Priority,
                        createdAt = o.CreatedAt,
                        updatedAt = o.UpdatedAt,
                        completedAt = o.CompletedAt,
                        assignedUser = o.AssignedUser != null ? new
                        {
                            id = o.AssignedUser.Id,
                            nick = o.AssignedUser.Nick,
                            email = o.AssignedUser.Email
                        } : null,
                        notes = o.Notes,
                        totalAmount = o.TotalAmount
                    }),
                    total = orders.Count,
                    statistics = new
                    {
                        @new = orders.Count(o => o.Status == OrderStatus.New),
                        inProgress = orders.Count(o => o.Status == OrderStatus.InProgress),
                        completed = orders.Count(o => o.Status == OrderStatus.Completed),
                        cancelled = orders.Count(o => o.Status == OrderStatus.Cancelled)
                    }
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Ошибка при получении заказов");
                return StatusCode(500, new { message = "Внутренняя ошибка сервера" });
            }
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetOrder(int id)
        {
            try
            {
                var stopwatch = Stopwatch.StartNew();
                var order = await _context.Orders
                    .Include(o => o.AssignedUser)
                    .FirstOrDefaultAsync(o => o.Id == id);
                stopwatch.Stop();

                if (order == null)
                {
                    return NotFound(new { message = "Заказ не найден" });
                }

                return Ok(new
                {
                    id = order.Id,
                    title = order.Title,
                    description = order.Description,
                    status = order.Status.ToString(),
                    priority = order.Priority,
                    createdAt = order.CreatedAt,
                    updatedAt = order.UpdatedAt,
                    completedAt = order.CompletedAt,
                    assignedUser = order.AssignedUser != null ? new
                    {
                        id = order.AssignedUser.Id,
                        nick = order.AssignedUser.Nick,
                        email = order.AssignedUser.Email
                    } : null,
                    notes = order.Notes,
                    totalAmount = order.TotalAmount
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Ошибка при получении заказа {Id}", id);
                return StatusCode(500, new { message = "Внутренняя ошибка сервера" });
            }
        }

        [HttpGet("statistics")]
        public async Task<IActionResult> GetStatistics()
        {
            using var activity = ActivitySource.StartActivity("GetStatistics");
            var stopwatch = Stopwatch.StartNew();
            try
            {
                using var dbActivity = ActivitySource.StartActivity("DatabaseStatisticsQueries");
                
                var totalOrders = await _context.Orders.CountAsync();
                dbActivity?.AddEvent(new("total_orders_counted", DateTimeOffset.UtcNow));
                
                var newOrders = await _context.Orders.CountAsync(o => o.Status == OrderStatus.New);
                dbActivity?.AddEvent(new("new_orders_counted", DateTimeOffset.UtcNow));
                
                var inProgressOrders = await _context.Orders.CountAsync(o => o.Status == OrderStatus.InProgress);
                dbActivity?.AddEvent(new("inprogress_orders_counted", DateTimeOffset.UtcNow));
                
                var completedOrders = await _context.Orders.CountAsync(o => o.Status == OrderStatus.Completed);
                dbActivity?.AddEvent(new("completed_orders_counted", DateTimeOffset.UtcNow));
                
                var cancelledOrders = await _context.Orders.CountAsync(o => o.Status == OrderStatus.Cancelled);
                dbActivity?.AddEvent(new("cancelled_orders_counted", DateTimeOffset.UtcNow));

                var totalAmount = await _context.Orders
                    .Where(o => o.TotalAmount.HasValue)
                    .SumAsync(o => o.TotalAmount ?? 0);
                dbActivity?.AddEvent(new("total_amount_calculated", DateTimeOffset.UtcNow));
                
                activity?.SetTag("statistics.total_orders", totalOrders);
                activity?.SetTag("statistics.total_amount", totalAmount);

                stopwatch.Stop();

                return Ok(new
                {
                    total = totalOrders,
                    @new = newOrders,
                    inProgress = inProgressOrders,
                    completed = completedOrders,
                    cancelled = cancelledOrders,
                    totalAmount = totalAmount
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Ошибка при получении статистики заказов");
                return StatusCode(500, new { message = "Внутренняя ошибка сервера" });
            }
        }
    }
} 