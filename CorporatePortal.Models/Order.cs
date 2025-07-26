using System.ComponentModel.DataAnnotations;

namespace CorporatePortal.Models;

public class Order
{
    public int Id { get; set; }
    
    [Required]
    [StringLength(200)]
    public string Title { get; set; } = string.Empty;
    
    [StringLength(1000)]
    public string Description { get; set; } = string.Empty;
    
    public OrderStatus Status { get; set; } = OrderStatus.New;
    
    public OrderPriority Priority { get; set; } = OrderPriority.Normal;
    
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    
    public DateTime? UpdatedAt { get; set; }
    
    public DateTime? CompletedAt { get; set; }
    
    public DateTime? DueDate { get; set; }
    
    [Range(0, double.MaxValue)]
    public decimal? Budget { get; set; }
    
    // Foreign keys
    public int CreatedById { get; set; }
    public int? AssignedToId { get; set; }
    
    // Navigation properties
    public virtual User CreatedBy { get; set; } = null!;
    public virtual User? AssignedTo { get; set; }
    public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();
}

public enum OrderStatus
{
    New,
    InProgress,
    OnHold,
    Completed,
    Cancelled
}

public enum OrderPriority
{
    Low,
    Normal,
    High,
    Critical
}

public class OrderItem
{
    public int Id { get; set; }
    
    [Required]
    [StringLength(200)]
    public string Name { get; set; } = string.Empty;
    
    [StringLength(500)]
    public string Description { get; set; } = string.Empty;
    
    public int Quantity { get; set; } = 1;
    
    [Range(0, double.MaxValue)]
    public decimal UnitPrice { get; set; }
    
    // Foreign key
    public int OrderId { get; set; }
    
    // Navigation property
    public virtual Order Order { get; set; } = null!;
} 