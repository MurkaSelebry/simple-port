using Microsoft.AspNetCore.Mvc;
using CorporatePortal.Services;
using CorporatePortal.DTOs;
using AutoMapper;

namespace CorporatePortal.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class DocumentsController : ControllerBase
{
    private readonly IDocumentService _documentService;
    private readonly IMapper _mapper;
    private readonly ILogger<DocumentsController> _logger;

    public DocumentsController(IDocumentService documentService, IMapper mapper, ILogger<DocumentsController> logger)
    {
        _documentService = documentService;
        _mapper = mapper;
        _logger = logger;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<DocumentDto>>> GetDocuments()
    {
        try
        {
            var documents = await _documentService.GetAllDocumentsAsync();
            var documentDtos = _mapper.Map<IEnumerable<DocumentDto>>(documents);
            return Ok(documentDtos);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting documents");
            return StatusCode(500, new { message = "Internal server error" });
        }
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<DocumentDto>> GetDocument(int id)
    {
        try
        {
            var document = await _documentService.GetDocumentByIdAsync(id);
            if (document == null)
            {
                return NotFound();
            }

            var documentDto = _mapper.Map<DocumentDto>(document);
            return Ok(documentDto);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting document {DocumentId}", id);
            return StatusCode(500, new { message = "Internal server error" });
        }
    }

    [HttpPost]
    public async Task<ActionResult<DocumentDto>> CreateDocument([FromBody] CreateDocumentDto request)
    {
        try
        {
            var document = _mapper.Map<Models.Document>(request);
            var createdDocument = await _documentService.CreateDocumentAsync(document);
            var documentDto = _mapper.Map<DocumentDto>(createdDocument);
            return CreatedAtAction(nameof(GetDocument), new { id = documentDto.Id }, documentDto);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating document");
            return StatusCode(500, new { message = "Internal server error" });
        }
    }

    [HttpPut("{id}")]
    public async Task<ActionResult<DocumentDto>> UpdateDocument(int id, [FromBody] UpdateDocumentDto request)
    {
        try
        {
            var document = _mapper.Map<Models.Document>(request);
            document.Id = id;
            var updatedDocument = await _documentService.UpdateDocumentAsync(document);
            if (updatedDocument == null)
            {
                return NotFound();
            }

            var documentDto = _mapper.Map<DocumentDto>(updatedDocument);
            return Ok(documentDto);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error updating document {DocumentId}", id);
            return StatusCode(500, new { message = "Internal server error" });
        }
    }

    [HttpDelete("{id}")]
    public async Task<ActionResult> DeleteDocument(int id)
    {
        try
        {
            var result = await _documentService.DeleteDocumentAsync(id);
            if (!result)
            {
                return NotFound();
            }

            return NoContent();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error deleting document {DocumentId}", id);
            return StatusCode(500, new { message = "Internal server error" });
        }
    }

    [HttpGet("category/{category}")]
    public async Task<ActionResult<IEnumerable<DocumentDto>>> GetDocumentsByCategory(string category)
    {
        try
        {
            var documents = await _documentService.GetDocumentsByCategoryAsync(category);
            var documentDtos = _mapper.Map<IEnumerable<DocumentDto>>(documents);
            return Ok(documentDtos);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting documents by category {Category}", category);
            return StatusCode(500, new { message = "Internal server error" });
        }
    }
} 