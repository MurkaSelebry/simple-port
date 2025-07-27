using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using CorporatePortalApi.Data;
using CorporatePortalApi.Models;
using System.Diagnostics;

namespace CorporatePortalApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class InfoController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<InfoController> _logger;

        public InfoController(ApplicationDbContext context, ILogger<InfoController> logger)
        {
            _context = context;
            _logger = logger;
        }

        [HttpGet]
        public async Task<IActionResult> GetInfoItems([FromQuery] string? category = null)
        {
            var stopwatch = Stopwatch.StartNew();
            
            try
            {
                _logger.LogInformation("Запрос информационных элементов. Категория: {Category}", category);

                // Имитация задержки для тестирования производительности
                if (category?.Contains("slow") == true)
                {
                    await Task.Delay(800); // Искусственная задержка для тестирования p99 > 500ms
                }

                var query = _context.InfoItems.AsQueryable();

                if (!string.IsNullOrEmpty(category))
                {
                    query = query.Where(i => i.Category == category);
                }

                var items = await query
                    .Where(i => i.IsActive)
                    .OrderBy(i => i.Title)
                    .ToListAsync();

                stopwatch.Stop();
                _logger.LogInformation("Получено {Count} информационных элементов за {ElapsedMs}ms", 
                    items.Count, stopwatch.ElapsedMilliseconds);

                return Ok(new
                {
                    items = items.Select(i => new
                    {
                        id = i.Id,
                        title = i.Title,
                        description = i.Description,
                        category = i.Category,
                        createdAt = i.CreatedAt,
                        filePath = i.FilePath,
                        fileType = i.FileType
                    }),
                    total = items.Count
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Ошибка при получении информационных элементов");
                return StatusCode(500, new { message = "Внутренняя ошибка сервера" });
            }
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetInfoItem(int id)
        {
            try
            {
                var item = await _context.InfoItems
                    .FirstOrDefaultAsync(i => i.Id == id && i.IsActive);

                if (item == null)
                {
                    return NotFound(new { message = "Элемент не найден" });
                }

                return Ok(new
                {
                    id = item.Id,
                    title = item.Title,
                    description = item.Description,
                    category = item.Category,
                    createdAt = item.CreatedAt,
                    updatedAt = item.UpdatedAt,
                    filePath = item.FilePath,
                    fileType = item.FileType
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Ошибка при получении информационного элемента {Id}", id);
                return StatusCode(500, new { message = "Внутренняя ошибка сервера" });
            }
        }

        [HttpGet("categories")]
        public async Task<IActionResult> GetCategories()
        {
            try
            {
                var categories = await _context.InfoItems
                    .Where(i => i.IsActive)
                    .Select(i => i.Category)
                    .Distinct()
                    .ToListAsync();

                return Ok(new { categories });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Ошибка при получении категорий");
                return StatusCode(500, new { message = "Внутренняя ошибка сервера" });
            }
        }
    }
} 