using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CorporatePortal.API.Models
{
    public class Order
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(50)]
        public string OpCode { get; set; } = string.Empty;

        [Required]
        [StringLength(50)]
        public string Number { get; set; } = string.Empty;

        [Required]
        [StringLength(100)]
        public string Type { get; set; } = string.Empty;

        [Required]
        [StringLength(1000)]
        public string Description { get; set; } = string.Empty;

        [StringLength(50)]
        public string ShipmentNumber { get; set; } = string.Empty;

        [StringLength(50)]
        public string ShipmentDate { get; set; } = string.Empty;

        [StringLength(50)]
        public string DesiredDate { get; set; } = string.Empty;

        [StringLength(50)]
        public string PlannedDate { get; set; } = string.Empty;

        [Required]
        [StringLength(100)]
        public string Creator { get; set; } = string.Empty;

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        [Required]
        [StringLength(50)]
        public string Status { get; set; } = "Новый";

        [StringLength(100)]
        public string Salon { get; set; } = string.Empty;

        [StringLength(100)]
        public string Designer { get; set; } = string.Empty;

        [StringLength(100)]
        public string Warehouse { get; set; } = string.Empty;

        [StringLength(100)]
        public string Production { get; set; } = string.Empty;

        [StringLength(100)]
        public string Logistics { get; set; } = string.Empty;

        [StringLength(100)]
        public string Payment { get; set; } = string.Empty;

        [StringLength(500)]
        public string FilePath { get; set; } = string.Empty;

        // Foreign key
        public int UserId { get; set; }

        // Navigation property
        [ForeignKey("UserId")]
        public virtual User User { get; set; } = null!;
    }
} 