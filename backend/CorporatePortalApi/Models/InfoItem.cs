using System.ComponentModel.DataAnnotations;

namespace CorporatePortalApi.Models
{
    public class InfoItem
    {
        public int Id { get; set; }
        
        [Required]
        [StringLength(200)]
        public string Title { get; set; } = string.Empty;
        
        [Required]
        [StringLength(1000)]
        public string Description { get; set; } = string.Empty;
        
        [Required]
        [StringLength(50)]
        public string Category { get; set; } = string.Empty; // "GeneralDocuments", "AdvertisingMaterials", "Prices"
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        
        public DateTime? UpdatedAt { get; set; }
        
        public bool IsActive { get; set; } = true;
        
        [StringLength(500)]
        public string? FilePath { get; set; }
        
        [StringLength(100)]
        public string? FileType { get; set; }
    }
} 