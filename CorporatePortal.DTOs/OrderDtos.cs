using System.ComponentModel.DataAnnotations;

namespace CorporatePortal.DTOs;

public class OrderDto
{
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public string Priority { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public DateTime? CompletedAt { get; set; }
    public DateTime? DueDate { get; set; }
    public decimal? Budget { get; set; }
    public int CreatedById { get; set; }
    public int? AssignedToId { get; set; }
    public string CreatedByName { get; set; } = string.Empty;
    public string? AssignedToName { get; set; }
    public List<OrderItemDto> OrderItems { get; set; } = new();
}

public class CreateOrderDto
{
    [Required]
    [StringLength(200)]
    public string Title { get; set; } = string.Empty;
    
    [StringLength(1000)]
    public string Description { get; set; } = string.Empty;
    
    public string Priority { get; set; } = "Normal";
    
    public DateTime? DueDate { get; set; }
    
    [Range(0, double.MaxValue)]
    public decimal? Budget { get; set; }
    
    public int? AssignedToId { get; set; }
    
    public List<CreateOrderItemDto> OrderItems { get; set; } = new();
}

public class UpdateOrderDto
{
    [StringLength(200)]
    public string? Title { get; set; }
    
    [StringLength(1000)]
    public string? Description { get; set; }
    
    public string? Status { get; set; }
    public string? Priority { get; set; }
    public DateTime? DueDate { get; set; }
    public decimal? Budget { get; set; }
    public int? AssignedToId { get; set; }
}

public class OrderItemDto
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public int Quantity { get; set; }
    public decimal UnitPrice { get; set; }
    public decimal TotalPrice => Quantity * UnitPrice;
}

public class CreateOrderItemDto
{
    [Required]
    [StringLength(200)]
    public string Name { get; set; } = string.Empty;
    
    [StringLength(500)]
    public string Description { get; set; } = string.Empty;
    
    [Range(1, int.MaxValue)]
    public int Quantity { get; set; } = 1;
    
    [Range(0, double.MaxValue)]
    public decimal UnitPrice { get; set; }
}

public class OrderStatisticsDto
{
    public int TotalOrders { get; set; }
    public int NewOrders { get; set; }
    public int InProgressOrders { get; set; }
    public int CompletedOrders { get; set; }
    public int CancelledOrders { get; set; }
    public decimal TotalBudget { get; set; }
    public decimal AverageOrderValue { get; set; }
    public List<OrderStatusCountDto> StatusCounts { get; set; } = new();
    public List<OrderPriorityCountDto> PriorityCounts { get; set; } = new();
}

public class OrderStatusCountDto
{
    public string Status { get; set; } = string.Empty;
    public int Count { get; set; }
}

public class OrderPriorityCountDto
{
    public string Priority { get; set; } = string.Empty;
    public int Count { get; set; }
} 