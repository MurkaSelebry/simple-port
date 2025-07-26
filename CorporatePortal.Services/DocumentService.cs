using CorporatePortal.Data;
using CorporatePortal.Models;
using Microsoft.EntityFrameworkCore;

namespace CorporatePortal.Services;

public class DocumentService : IDocumentService
{
    private readonly CorporatePortalContext _context;
    private readonly ILogger<DocumentService> _logger;

    public DocumentService(CorporatePortalContext context, ILogger<DocumentService> logger)
    {
        _context = context;
        _logger = logger;
    }

    public async Task<IEnumerable<Document>> GetAllDocumentsAsync()
    {
        try
        {
            return await _context.Documents
                .Include(d => d.CreatedBy)
                .Include(d => d.UpdatedBy)
                .OrderByDescending(d => d.CreatedAt)
                .ToListAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting all documents");
            throw;
        }
    }

    public async Task<Document?> GetDocumentByIdAsync(int id)
    {
        try
        {
            return await _context.Documents
                .Include(d => d.CreatedBy)
                .Include(d => d.UpdatedBy)
                .FirstOrDefaultAsync(d => d.Id == id);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting document by id: {DocumentId}", id);
            throw;
        }
    }

    public async Task<Document> CreateDocumentAsync(Document document)
    {
        try
        {
            document.CreatedAt = DateTime.UtcNow;
            document.Version = 1;
            _context.Documents.Add(document);
            await _context.SaveChangesAsync();

            _logger.LogInformation("Document created successfully: {DocumentId}", document.Id);
            return document;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating document");
            throw;
        }
    }

    public async Task<Document?> UpdateDocumentAsync(Document document)
    {
        try
        {
            var existingDocument = await _context.Documents.FindAsync(document.Id);
            if (existingDocument == null)
            {
                return null;
            }

            existingDocument.Title = document.Title;
            existingDocument.Description = document.Description;
            existingDocument.Category = document.Category;
            existingDocument.FileType = document.FileType;
            existingDocument.FilePath = document.FilePath;
            existingDocument.FileSize = document.FileSize;
            existingDocument.Status = document.Status;
            existingDocument.ExpiresAt = document.ExpiresAt;
            existingDocument.IsPublic = document.IsPublic;
            existingDocument.UpdatedById = document.UpdatedById;
            existingDocument.UpdatedAt = DateTime.UtcNow;
            existingDocument.Version++;

            if (document.Status == DocumentStatus.Published)
            {
                existingDocument.PublishedAt = DateTime.UtcNow;
            }

            await _context.SaveChangesAsync();

            _logger.LogInformation("Document updated successfully: {DocumentId}", document.Id);
            return existingDocument;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error updating document: {DocumentId}", document.Id);
            throw;
        }
    }

    public async Task<bool> DeleteDocumentAsync(int id)
    {
        try
        {
            var document = await _context.Documents.FindAsync(id);
            if (document == null)
            {
                return false;
            }

            _context.Documents.Remove(document);
            await _context.SaveChangesAsync();

            _logger.LogInformation("Document deleted successfully: {DocumentId}", id);
            return true;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error deleting document: {DocumentId}", id);
            throw;
        }
    }

    public async Task<IEnumerable<Document>> GetDocumentsByCategoryAsync(string category)
    {
        try
        {
            return await _context.Documents
                .Include(d => d.CreatedBy)
                .Include(d => d.UpdatedBy)
                .Where(d => d.Category.ToLower() == category.ToLower())
                .OrderByDescending(d => d.CreatedAt)
                .ToListAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting documents by category: {Category}", category);
            throw;
        }
    }
} 