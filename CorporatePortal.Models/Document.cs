using System.ComponentModel.DataAnnotations;

namespace CorporatePortal.Models;

public class Document
{
    public int Id { get; set; }
    
    [Required]
    [StringLength(200)]
    public string Title { get; set; } = string.Empty;
    
    [StringLength(1000)]
    public string Description { get; set; } = string.Empty;
    
    [Required]
    [StringLength(100)]
    public string Category { get; set; } = string.Empty;
    
    [StringLength(50)]
    public string FileType { get; set; } = string.Empty;
    
    [StringLength(500)]
    public string FilePath { get; set; } = string.Empty;
    
    public long FileSize { get; set; }
    
    public DocumentStatus Status { get; set; } = DocumentStatus.Draft;
    
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    
    public DateTime? UpdatedAt { get; set; }
    
    public DateTime? PublishedAt { get; set; }
    
    public DateTime? ExpiresAt { get; set; }
    
    public bool IsPublic { get; set; } = false;
    
    public int Version { get; set; } = 1;
    
    // Foreign keys
    public int CreatedById { get; set; }
    public int? UpdatedById { get; set; }
    
    // Navigation properties
    public virtual User CreatedBy { get; set; } = null!;
    public virtual User? UpdatedBy { get; set; }
}

public enum DocumentStatus
{
    Draft,
    Review,
    Published,
    Archived,
    Expired
} 