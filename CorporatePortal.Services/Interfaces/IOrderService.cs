using CorporatePortal.Models;

namespace CorporatePortal.Services;

public interface IOrderService
{
    Task<IEnumerable<Order>> GetAllOrdersAsync();
    Task<Order?> GetOrderByIdAsync(int id);
    Task<Order> CreateOrderAsync(Order order);
    Task<Order?> UpdateOrderAsync(Order order);
    Task<bool> DeleteOrderAsync(int id);
    Task<OrderStatistics> GetOrderStatisticsAsync();
}

public class OrderStatistics
{
    public int TotalOrders { get; set; }
    public int NewOrders { get; set; }
    public int InProgressOrders { get; set; }
    public int CompletedOrders { get; set; }
    public int CancelledOrders { get; set; }
    public decimal TotalBudget { get; set; }
    public decimal AverageOrderValue { get; set; }
    public List<OrderStatusCount> StatusCounts { get; set; } = new();
    public List<OrderPriorityCount> PriorityCounts { get; set; } = new();
}

public class OrderStatusCount
{
    public string Status { get; set; } = string.Empty;
    public int Count { get; set; }
}

public class OrderPriorityCount
{
    public string Priority { get; set; } = string.Empty;
    public int Count { get; set; }
} 