using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using CorporatePortalApi.Data;
using CorporatePortalApi.Models;
using System.Diagnostics;

namespace CorporatePortalApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class OrdersController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<OrdersController> _logger;

        public OrdersController(ApplicationDbContext context, ILogger<OrdersController> logger)
        {
            _context = context;
            _logger = logger;
        }

        [HttpGet]
        public async Task<IActionResult> GetOrders([FromQuery] string? status = null, [FromQuery] string? priority = null)
        {
            var stopwatch = Stopwatch.StartNew();
            
            try
            {
                _logger.LogInformation("Запрос заказов. Статус: {Status}, Приоритет: {Priority}", status, priority);

                // Имитация задержки для тестирования производительности
                if (status?.Contains("slow") == true || priority?.Contains("slow") == true)
                {
                    await Task.Delay(700); // Искусственная задержка для тестирования p99 > 500ms
                }

                var query = _context.Orders
                    .Include(o => o.AssignedUser)
                    .AsQueryable();

                if (!string.IsNullOrEmpty(status))
                {
                    if (Enum.TryParse<OrderStatus>(status, true, out var orderStatus))
                    {
                        query = query.Where(o => o.Status == orderStatus);
                    }
                }

                if (!string.IsNullOrEmpty(priority))
                {
                    query = query.Where(o => o.Priority == priority);
                }

                var orders = await query
                    .OrderByDescending(o => o.CreatedAt)
                    .ToListAsync();

                stopwatch.Stop();
                _logger.LogInformation("Получено {Count} заказов за {ElapsedMs}ms", 
                    orders.Count, stopwatch.ElapsedMilliseconds);

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
                var order = await _context.Orders
                    .Include(o => o.AssignedUser)
                    .FirstOrDefaultAsync(o => o.Id == id);

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
            try
            {
                var totalOrders = await _context.Orders.CountAsync();
                var newOrders = await _context.Orders.CountAsync(o => o.Status == OrderStatus.New);
                var inProgressOrders = await _context.Orders.CountAsync(o => o.Status == OrderStatus.InProgress);
                var completedOrders = await _context.Orders.CountAsync(o => o.Status == OrderStatus.Completed);
                var cancelledOrders = await _context.Orders.CountAsync(o => o.Status == OrderStatus.Cancelled);

                var totalAmount = await _context.Orders
                    .Where(o => o.TotalAmount.HasValue)
                    .SumAsync(o => o.TotalAmount ?? 0);

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