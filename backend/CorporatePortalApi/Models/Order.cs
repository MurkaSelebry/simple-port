using System.ComponentModel.DataAnnotations;

namespace CorporatePortalApi.Models
{
    public enum OrderStatus
    {
        New = 0,
        InProgress = 1,
        Completed = 2,
        Cancelled = 3
    }

    public class Order
    {
        public int Id { get; set; }
        
        [Required]
        [StringLength(200)]
        public string Title { get; set; } = string.Empty;
        
        [Required]
        [StringLength(1000)]
        public string Description { get; set; } = string.Empty;
        
        public OrderStatus Status { get; set; } = OrderStatus.New;
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        
        public DateTime? UpdatedAt { get; set; }
        
        public DateTime? CompletedAt { get; set; }
        
        public int? AssignedUserId { get; set; }
        
        public virtual User? AssignedUser { get; set; }
        
        [StringLength(500)]
        public string? Notes { get; set; }
        
        public decimal? TotalAmount { get; set; }
        
        [StringLength(100)]
        public string? Priority { get; set; } = "Medium";
    }
} 