using CorporatePortal.Data;
using CorporatePortal.Models;
using Microsoft.EntityFrameworkCore;

namespace CorporatePortal.Services;

public class OrderService : IOrderService
{
    private readonly CorporatePortalContext _context;
    private readonly ILogger<OrderService> _logger;

    public OrderService(CorporatePortalContext context, ILogger<OrderService> logger)
    {
        _context = context;
        _logger = logger;
    }

    public async Task<IEnumerable<Order>> GetAllOrdersAsync()
    {
        try
        {
            return await _context.Orders
                .Include(o => o.CreatedBy)
                .Include(o => o.AssignedTo)
                .Include(o => o.OrderItems)
                .OrderByDescending(o => o.CreatedAt)
                .ToListAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting all orders");
            throw;
        }
    }

    public async Task<Order?> GetOrderByIdAsync(int id)
    {
        try
        {
            return await _context.Orders
                .Include(o => o.CreatedBy)
                .Include(o => o.AssignedTo)
                .Include(o => o.OrderItems)
                .FirstOrDefaultAsync(o => o.Id == id);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting order by id: {OrderId}", id);
            throw;
        }
    }

    public async Task<Order> CreateOrderAsync(Order order)
    {
        try
        {
            order.CreatedAt = DateTime.UtcNow;
            _context.Orders.Add(order);
            await _context.SaveChangesAsync();

            _logger.LogInformation("Order created successfully: {OrderId}", order.Id);
            return order;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating order");
            throw;
        }
    }

    public async Task<Order?> UpdateOrderAsync(Order order)
    {
        try
        {
            var existingOrder = await _context.Orders.FindAsync(order.Id);
            if (existingOrder == null)
            {
                return null;
            }

            existingOrder.Title = order.Title;
            existingOrder.Description = order.Description;
            existingOrder.Status = order.Status;
            existingOrder.Priority = order.Priority;
            existingOrder.DueDate = order.DueDate;
            existingOrder.Budget = order.Budget;
            existingOrder.AssignedToId = order.AssignedToId;
            existingOrder.UpdatedAt = DateTime.UtcNow;

            if (order.Status == OrderStatus.Completed)
            {
                existingOrder.CompletedAt = DateTime.UtcNow;
            }

            await _context.SaveChangesAsync();

            _logger.LogInformation("Order updated successfully: {OrderId}", order.Id);
            return existingOrder;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error updating order: {OrderId}", order.Id);
            throw;
        }
    }

    public async Task<bool> DeleteOrderAsync(int id)
    {
        try
        {
            var order = await _context.Orders.FindAsync(id);
            if (order == null)
            {
                return false;
            }

            _context.Orders.Remove(order);
            await _context.SaveChangesAsync();

            _logger.LogInformation("Order deleted successfully: {OrderId}", id);
            return true;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error deleting order: {OrderId}", id);
            throw;
        }
    }

    public async Task<OrderStatistics> GetOrderStatisticsAsync()
    {
        try
        {
            var orders = await _context.Orders.ToListAsync();

            var statistics = new OrderStatistics
            {
                TotalOrders = orders.Count,
                NewOrders = orders.Count(o => o.Status == OrderStatus.New),
                InProgressOrders = orders.Count(o => o.Status == OrderStatus.InProgress),
                CompletedOrders = orders.Count(o => o.Status == OrderStatus.Completed),
                CancelledOrders = orders.Count(o => o.Status == OrderStatus.Cancelled),
                TotalBudget = orders.Where(o => o.Budget.HasValue).Sum(o => o.Budget.Value),
                AverageOrderValue = orders.Where(o => o.Budget.HasValue).Average(o => o.Budget.Value)
            };

            // Status counts
            statistics.StatusCounts = orders
                .GroupBy(o => o.Status)
                .Select(g => new OrderStatusCount
                {
                    Status = g.Key.ToString(),
                    Count = g.Count()
                })
                .ToList();

            // Priority counts
            statistics.PriorityCounts = orders
                .GroupBy(o => o.Priority)
                .Select(g => new OrderPriorityCount
                {
                    Priority = g.Key.ToString(),
                    Count = g.Count()
                })
                .ToList();

            return statistics;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting order statistics");
            throw;
        }
    }
} 