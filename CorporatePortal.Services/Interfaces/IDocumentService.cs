using CorporatePortal.Models;

namespace CorporatePortal.Services;

public interface IDocumentService
{
    Task<IEnumerable<Document>> GetAllDocumentsAsync();
    Task<Document?> GetDocumentByIdAsync(int id);
    Task<Document> CreateDocumentAsync(Document document);
    Task<Document?> UpdateDocumentAsync(Document document);
    Task<bool> DeleteDocumentAsync(int id);
    Task<IEnumerable<Document>> GetDocumentsByCategoryAsync(string category);
} 