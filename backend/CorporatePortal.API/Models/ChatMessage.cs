using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CorporatePortal.API.Models
{
    public class ChatMessage
    {
        [Key]
        public int Id { get; set; }

        // Foreign key
        public int UserId { get; set; }

        [Required]
        [StringLength(4000)]
        public string Message { get; set; } = string.Empty;

        [StringLength(4000)]
        public string Response { get; set; } = string.Empty;

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        [StringLength(2000)]
        public string Sources { get; set; } = string.Empty; // JSON array of sources

        // Navigation property
        [ForeignKey("UserId")]
        public virtual User User { get; set; } = null!;
    }
} 