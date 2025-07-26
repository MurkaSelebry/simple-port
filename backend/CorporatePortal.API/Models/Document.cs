using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CorporatePortal.API.Models
{
    public class Document
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(500)]
        public string Description { get; set; } = string.Empty;

        [Required]
        [StringLength(255)]
        public string FileName { get; set; } = string.Empty;

        [StringLength(500)]
        public string FilePath { get; set; } = string.Empty;

        [Required]
        [StringLength(100)]
        public string AddedBy { get; set; } = string.Empty;

        public DateTime AddedDate { get; set; } = DateTime.UtcNow;

        public bool ReadStatus { get; set; } = false;

        public DateTime? ReadDate { get; set; }

        [StringLength(100)]
        public string Category { get; set; } = string.Empty;

        // Foreign key
        public int UserId { get; set; }

        // Navigation property
        [ForeignKey("UserId")]
        public virtual User User { get; set; } = null!;

        public virtual DocumentCategory? DocumentCategory { get; set; }
    }
} 