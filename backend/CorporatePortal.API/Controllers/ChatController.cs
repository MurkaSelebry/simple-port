using Microsoft.AspNetCore.Mvc;
using CorporatePortal.API.Data;
using CorporatePortal.API.DTOs.Chat;
using CorporatePortal.API.Models;
using CorporatePortal.API.Services;
using System.Text.Json;

namespace CorporatePortal.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ChatController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly IAuthService _authService;
        private readonly ILogger<ChatController> _logger;

        public ChatController(ApplicationDbContext context, IAuthService authService, ILogger<ChatController> logger)
        {
            _context = context;
            _authService = authService;
            _logger = logger;
        }

        /// <summary>
        /// Отправить сообщение в чат
        /// </summary>
        /// <param name="request">Сообщение</param>
        /// <returns>Ответ AI-ассистента</returns>
        [HttpPost("send")]
        [ProducesResponseType(typeof(ChatResponse), 200)]
        [ProducesResponseType(400)]
        public async Task<ActionResult<ChatResponse>> SendMessage([FromBody] ChatRequest request)
        {
            try
            {
                var userId = await GetCurrentUserId();

                // Простая заглушка для AI-ассистента
                var response = await GenerateAIResponse(request.Query);

                // Сохраняем сообщение в БД
                var chatMessage = new ChatMessage
                {
                    UserId = userId,
                    Message = request.Query,
                    Response = response.Answer,
                    Sources = JsonSerializer.Serialize(response.Sources),
                    CreatedAt = DateTime.UtcNow
                };

                _context.ChatMessages.Add(chatMessage);
                await _context.SaveChangesAsync();

                _logger.LogInformation("Chat message processed for user: {UserId}", userId);
                return Ok(response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error processing chat message");
                return StatusCode(500, new { message = "Internal server error" });
            }
        }

        /// <summary>
        /// Получить историю сообщений
        /// </summary>
        /// <param name="page">Номер страницы</param>
        /// <param name="pageSize">Размер страницы</param>
        /// <returns>История сообщений</returns>
        [HttpGet("history")]
        [ProducesResponseType(typeof(List<ChatMessageDto>), 200)]
        public async Task<ActionResult<List<ChatMessageDto>>> GetHistory(
            [FromQuery] int page = 1,
            [FromQuery] int pageSize = 20)
        {
            try
            {
                var userId = await GetCurrentUserId();

                var messages = await _context.ChatMessages
                    .Where(m => m.UserId == userId)
                    .OrderByDescending(m => m.CreatedAt)
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .ToList();

                var messageDtos = messages.Select(m => new ChatMessageDto
                {
                    Id = m.Id,
                    Message = m.Message,
                    Response = m.Response,
                    CreatedAt = m.CreatedAt,
                    Sources = !string.IsNullOrEmpty(m.Sources) 
                        ? JsonSerializer.Deserialize<List<ChatSource>>(m.Sources) ?? new List<ChatSource>()
                        : new List<ChatSource>()
                }).ToList();

                return Ok(messageDtos);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting chat history");
                return StatusCode(500, new { message = "Internal server error" });
            }
        }

        private async Task<ChatResponse> GenerateAIResponse(string query)
        {
            // Простая заглушка для AI-ассистента
            // В реальном приложении здесь был бы вызов к AI сервису
            
            var responses = new Dictionary<string, string>
            {
                { "привет", "Здравствуйте! Я ваш цифровой помощник. Чем могу помочь?" },
                { "помощь", "Я могу помочь вам с:\n- Поиском документов\n- Информацией о заказах\n- Общими вопросами\nПросто задайте ваш вопрос!" },
                { "заказы", "Для работы с заказами перейдите в раздел 'Заказы'. Там вы можете:\n- Просматривать список заказов\n- Создавать новые заказы\n- Экспортировать данные в CSV" },
                { "документы", "Документы находятся в разделе 'Информация'. Там вы найдете:\n- Общие документы\n- Рекламные материалы\n- Прайс-листы" }
            };

            var lowerQuery = query.ToLower();
            var response = "Извините, я не понимаю ваш вопрос. Попробуйте переформулировать или обратитесь к разделу 'Помощь'.";

            foreach (var kvp in responses)
            {
                if (lowerQuery.Contains(kvp.Key))
                {
                    response = kvp.Value;
                    break;
                }
            }

            // Генерируем фиктивные источники
            var sources = new List<ChatSource>
            {
                new ChatSource { Filename = "help_document.pdf", Source = "/documents/help/help_document.pdf" },
                new ChatSource { Filename = "user_manual.docx", Source = "/documents/manuals/user_manual.docx" }
            };

            return new ChatResponse
            {
                Answer = response,
                Sources = sources
            };
        }

        private async Task<int> GetCurrentUserId()
        {
            var authHeader = Request.Headers["Authorization"].FirstOrDefault();
            if (string.IsNullOrEmpty(authHeader) || !authHeader.StartsWith("Bearer "))
            {
                throw new UnauthorizedAccessException("No valid token provided");
            }

            var token = authHeader.Substring("Bearer ".Length);
            return await _authService.GetUserIdFromTokenAsync(token);
        }
    }

    public class ChatMessageDto
    {
        public int Id { get; set; }
        public string Message { get; set; } = string.Empty;
        public string Response { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
        public List<ChatSource> Sources { get; set; } = new();
    }
} 