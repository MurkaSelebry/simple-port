using System.ComponentModel.DataAnnotations;

namespace CorporatePortal.API.Models
{
    public class DocumentCategory
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(100)]
        public string Name { get; set; } = string.Empty;

        [StringLength(500)]
        public string Description { get; set; } = string.Empty;

        // Navigation property
        public virtual ICollection<Document> Documents { get; set; } = new List<Document>();
    }
} 