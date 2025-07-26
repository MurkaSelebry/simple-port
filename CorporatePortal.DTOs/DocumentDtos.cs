using System.ComponentModel.DataAnnotations;

namespace CorporatePortal.DTOs;

public class DocumentDto
{
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string Category { get; set; } = string.Empty;
    public string FileType { get; set; } = string.Empty;
    public string FilePath { get; set; } = string.Empty;
    public long FileSize { get; set; }
    public string Status { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public DateTime? PublishedAt { get; set; }
    public DateTime? ExpiresAt { get; set; }
    public bool IsPublic { get; set; }
    public int Version { get; set; }
    public int CreatedById { get; set; }
    public int? UpdatedById { get; set; }
    public string CreatedByName { get; set; } = string.Empty;
    public string? UpdatedByName { get; set; }
}

public class CreateDocumentDto
{
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
    
    [Range(0, long.MaxValue)]
    public long FileSize { get; set; }
    
    public DateTime? ExpiresAt { get; set; }
    public bool IsPublic { get; set; } = false;
}

public class UpdateDocumentDto
{
    [StringLength(200)]
    public string? Title { get; set; }
    
    [StringLength(1000)]
    public string? Description { get; set; }
    
    [StringLength(100)]
    public string? Category { get; set; }
    
    [StringLength(50)]
    public string? FileType { get; set; }
    
    [StringLength(500)]
    public string? FilePath { get; set; }
    
    [Range(0, long.MaxValue)]
    public long? FileSize { get; set; }
    
    public string? Status { get; set; }
    public DateTime? ExpiresAt { get; set; }
    public bool? IsPublic { get; set; }
} 