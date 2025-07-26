using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using CorporatePortal.API.Data;
using CorporatePortal.API.DTOs.Orders;
using CorporatePortal.API.Models;
using CorporatePortal.API.Services;
using System.Text;

namespace CorporatePortal.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class OrdersController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly IAuthService _authService;
        private readonly ILogger<OrdersController> _logger;

        public OrdersController(ApplicationDbContext context, IAuthService authService, ILogger<OrdersController> logger)
        {
            _context = context;
            _authService = authService;
            _logger = logger;
        }

        /// <summary>
        /// Получить список заказов
        /// </summary>
        /// <param name="page">Номер страницы</param>
        /// <param name="pageSize">Размер страницы</param>
        /// <param name="search">Поисковый запрос</param>
        /// <returns>Список заказов</returns>
        [HttpGet]
        [ProducesResponseType(typeof(List<OrderDto>), 200)]
        public async Task<ActionResult<List<OrderDto>>> GetOrders(
            [FromQuery] int page = 1,
            [FromQuery] int pageSize = 20,
            [FromQuery] string? search = null)
        {
            try
            {
                var query = _context.Orders.AsQueryable();

                if (!string.IsNullOrEmpty(search))
                {
                    query = query.Where(o => 
                        o.OpCode.Contains(search) ||
                        o.Number.Contains(search) ||
                        o.Description.Contains(search) ||
                        o.Status.Contains(search));
                }

                var totalCount = await query.CountAsync();
                var orders = await query
                    .OrderByDescending(o => o.CreatedAt)
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .ToListAsync();

                var orderDtos = orders.Select(o => new OrderDto
                {
                    Id = o.Id,
                    OpCode = o.OpCode,
                    Number = o.Number,
                    Type = o.Type,
                    Description = o.Description,
                    ShipmentNumber = o.ShipmentNumber,
                    ShipmentDate = o.ShipmentDate,
                    DesiredDate = o.DesiredDate,
                    PlannedDate = o.PlannedDate,
                    Creator = o.Creator,
                    CreatedAt = o.CreatedAt,
                    Status = o.Status,
                    Salon = o.Salon,
                    Designer = o.Designer,
                    Warehouse = o.Warehouse,
                    Production = o.Production,
                    Logistics = o.Logistics,
                    Payment = o.Payment,
                    FilePath = o.FilePath
                }).ToList();

                Response.Headers.Add("X-Total-Count", totalCount.ToString());
                Response.Headers.Add("X-Page", page.ToString());
                Response.Headers.Add("X-PageSize", pageSize.ToString());

                return Ok(orderDtos);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting orders");
                return StatusCode(500, new { message = "Internal server error" });
            }
        }

        /// <summary>
        /// Получить заказ по ID
        /// </summary>
        /// <param name="id">ID заказа</param>
        /// <returns>Заказ</returns>
        [HttpGet("{id}")]
        [ProducesResponseType(typeof(OrderDto), 200)]
        [ProducesResponseType(404)]
        public async Task<ActionResult<OrderDto>> GetOrder(int id)
        {
            try
            {
                var order = await _context.Orders.FindAsync(id);
                if (order == null)
                {
                    return NotFound(new { message = "Order not found" });
                }

                var orderDto = new OrderDto
                {
                    Id = order.Id,
                    OpCode = order.OpCode,
                    Number = order.Number,
                    Type = order.Type,
                    Description = order.Description,
                    ShipmentNumber = order.ShipmentNumber,
                    ShipmentDate = order.ShipmentDate,
                    DesiredDate = order.DesiredDate,
                    PlannedDate = order.PlannedDate,
                    Creator = order.Creator,
                    CreatedAt = order.CreatedAt,
                    Status = order.Status,
                    Salon = order.Salon,
                    Designer = order.Designer,
                    Warehouse = order.Warehouse,
                    Production = order.Production,
                    Logistics = order.Logistics,
                    Payment = order.Payment,
                    FilePath = order.FilePath
                };

                return Ok(orderDto);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting order with ID: {Id}", id);
                return StatusCode(500, new { message = "Internal server error" });
            }
        }

        /// <summary>
        /// Создать новый заказ
        /// </summary>
        /// <param name="request">Данные заказа</param>
        /// <returns>Созданный заказ</returns>
        [HttpPost]
        [ProducesResponseType(typeof(OrderDto), 201)]
        [ProducesResponseType(400)]
        public async Task<ActionResult<OrderDto>> CreateOrder([FromBody] CreateOrderRequest request)
        {
            try
            {
                var userId = await GetCurrentUserId();

                var order = new Order
                {
                    OpCode = request.OpCode,
                    Number = request.Number,
                    Type = request.Type,
                    Description = request.Description,
                    Creator = "Пользователь", // В реальном приложении брали бы из токена
                    CreatedAt = DateTime.UtcNow,
                    Status = "Новый",
                    UserId = userId
                };

                _context.Orders.Add(order);
                await _context.SaveChangesAsync();

                var orderDto = new OrderDto
                {
                    Id = order.Id,
                    OpCode = order.OpCode,
                    Number = order.Number,
                    Type = order.Type,
                    Description = order.Description,
                    ShipmentNumber = order.ShipmentNumber,
                    ShipmentDate = order.ShipmentDate,
                    DesiredDate = order.DesiredDate,
                    PlannedDate = order.PlannedDate,
                    Creator = order.Creator,
                    CreatedAt = order.CreatedAt,
                    Status = order.Status,
                    Salon = order.Salon,
                    Designer = order.Designer,
                    Warehouse = order.Warehouse,
                    Production = order.Production,
                    Logistics = order.Logistics,
                    Payment = order.Payment,
                    FilePath = order.FilePath
                };

                _logger.LogInformation("Order created with ID: {Id}", order.Id);
                return CreatedAtAction(nameof(GetOrder), new { id = order.Id }, orderDto);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating order");
                return StatusCode(500, new { message = "Internal server error" });
            }
        }

        /// <summary>
        /// Обновить заказ
        /// </summary>
        /// <param name="id">ID заказа</param>
        /// <param name="request">Данные для обновления</param>
        /// <returns>Обновленный заказ</returns>
        [HttpPut("{id}")]
        [ProducesResponseType(typeof(OrderDto), 200)]
        [ProducesResponseType(404)]
        public async Task<ActionResult<OrderDto>> UpdateOrder(int id, [FromBody] UpdateOrderRequest request)
        {
            try
            {
                var order = await _context.Orders.FindAsync(id);
                if (order == null)
                {
                    return NotFound(new { message = "Order not found" });
                }

                // Обновляем только переданные поля
                if (request.OpCode != null) order.OpCode = request.OpCode;
                if (request.Number != null) order.Number = request.Number;
                if (request.Type != null) order.Type = request.Type;
                if (request.Description != null) order.Description = request.Description;
                if (request.ShipmentNumber != null) order.ShipmentNumber = request.ShipmentNumber;
                if (request.ShipmentDate != null) order.ShipmentDate = request.ShipmentDate;
                if (request.DesiredDate != null) order.DesiredDate = request.DesiredDate;
                if (request.PlannedDate != null) order.PlannedDate = request.PlannedDate;
                if (request.Status != null) order.Status = request.Status;
                if (request.Salon != null) order.Salon = request.Salon;
                if (request.Designer != null) order.Designer = request.Designer;
                if (request.Warehouse != null) order.Warehouse = request.Warehouse;
                if (request.Production != null) order.Production = request.Production;
                if (request.Logistics != null) order.Logistics = request.Logistics;
                if (request.Payment != null) order.Payment = request.Payment;

                await _context.SaveChangesAsync();

                var orderDto = new OrderDto
                {
                    Id = order.Id,
                    OpCode = order.OpCode,
                    Number = order.Number,
                    Type = order.Type,
                    Description = order.Description,
                    ShipmentNumber = order.ShipmentNumber,
                    ShipmentDate = order.ShipmentDate,
                    DesiredDate = order.DesiredDate,
                    PlannedDate = order.PlannedDate,
                    Creator = order.Creator,
                    CreatedAt = order.CreatedAt,
                    Status = order.Status,
                    Salon = order.Salon,
                    Designer = order.Designer,
                    Warehouse = order.Warehouse,
                    Production = order.Production,
                    Logistics = order.Logistics,
                    Payment = order.Payment,
                    FilePath = order.FilePath
                };

                _logger.LogInformation("Order updated with ID: {Id}", order.Id);
                return Ok(orderDto);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating order with ID: {Id}", id);
                return StatusCode(500, new { message = "Internal server error" });
            }
        }

        /// <summary>
        /// Удалить заказ
        /// </summary>
        /// <param name="id">ID заказа</param>
        /// <returns>Результат удаления</returns>
        [HttpDelete("{id}")]
        [ProducesResponseType(204)]
        [ProducesResponseType(404)]
        public async Task<ActionResult> DeleteOrder(int id)
        {
            try
            {
                var order = await _context.Orders.FindAsync(id);
                if (order == null)
                {
                    return NotFound(new { message = "Order not found" });
                }

                _context.Orders.Remove(order);
                await _context.SaveChangesAsync();

                _logger.LogInformation("Order deleted with ID: {Id}", id);
                return NoContent();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting order with ID: {Id}", id);
                return StatusCode(500, new { message = "Internal server error" });
            }
        }

        /// <summary>
        /// Экспорт заказов в CSV
        /// </summary>
        /// <returns>CSV файл</returns>
        [HttpGet("export/csv")]
        [ProducesResponseType(200)]
        public async Task<IActionResult> ExportToCsv()
        {
            try
            {
                var orders = await _context.Orders.ToListAsync();

                var csv = new StringBuilder();
                csv.AppendLine("Код ОП;Номер;Тип;Описание;№ отгрузки;Отгрузка;Желаемая дата;Планируемая дата;Создал;Создано;Статус;Салон;Конструктор;Склад комплектации;Производство;Логистика;Оплата");

                foreach (var order in orders)
                {
                    csv.AppendLine($"{order.OpCode};{order.Number};{order.Type};{order.Description};{order.ShipmentNumber};{order.ShipmentDate};{order.DesiredDate};{order.PlannedDate};{order.Creator};{order.CreatedAt:dd.MM.yyyy, HH:mm};{order.Status};{order.Salon};{order.Designer};{order.Warehouse};{order.Production};{order.Logistics};{order.Payment}");
                }

                var fileName = $"export_orders_{DateTime.Now:yyyyMMdd_HHmmss}.csv";
                var bytes = Encoding.UTF8.GetBytes(csv.ToString());

                _logger.LogInformation("Orders exported to CSV: {FileName}", fileName);
                return File(bytes, "text/csv", fileName);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error exporting orders to CSV");
                return StatusCode(500, new { message = "Internal server error" });
            }
        }

        /// <summary>
        /// Медленный запрос для тестирования производительности
        /// </summary>
        /// <returns>Результат</returns>
        [HttpGet("slow-query")]
        [ProducesResponseType(200)]
        public async Task<ActionResult> SlowQuery()
        {
            // Искусственная задержка для тестирования
            await Task.Delay(600); // 600ms для p99 > 500ms
            
            return Ok(new { message = "Slow query completed", timestamp = DateTime.UtcNow });
        }

        /// <summary>
        /// Создание множества заказов для нагрузочного тестирования
        /// </summary>
        /// <param name="count">Количество заказов</param>
        /// <returns>Результат</returns>
        [HttpPost("bulk-create")]
        [ProducesResponseType(200)]
        public async Task<ActionResult> BulkCreate([FromBody] int count)
        {
            try
            {
                var userId = await GetCurrentUserId();
                var orders = new List<Order>();

                for (int i = 0; i < count; i++)
                {
                    orders.Add(new Order
                    {
                        OpCode = $"TEST{i}",
                        Number = $"BULK{i}",
                        Type = "Тестовый",
                        Description = $"Тестовый заказ {i}",
                        Creator = "LoadTest",
                        CreatedAt = DateTime.UtcNow,
                        Status = "Новый",
                        UserId = userId
                    });
                }

                _context.Orders.AddRange(orders);
                await _context.SaveChangesAsync();

                _logger.LogInformation("Bulk created {Count} orders", count);
                return Ok(new { message = $"Created {count} orders", count });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error bulk creating orders");
                return StatusCode(500, new { message = "Internal server error" });
            }
        }

        private async Task<int> GetCurrentUserId()
        {
            var authHeader = Request.Headers["Authorization"].FirstOrDefault();
            if (string.IsNullOrEmpty(authHeader) || !authHeader.StartsWith("Bearer "))
            {
                throw new UnauthorizedAccessException("No valid token provided");
            }

            var token = authHeader.Substring("Bearer ".Length);
            return await _authService.GetUserIdFromTokenAsync(token);
        }
    }
} 