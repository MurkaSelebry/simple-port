using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using CorporatePortalApi.Data;
using CorporatePortalApi.Models;
using System.Diagnostics;

namespace CorporatePortalApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<AuthController> _logger;

        public AuthController(ApplicationDbContext context, ILogger<AuthController> logger)
        {
            _context = context;
            _logger = logger;
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest request)
        {
            var stopwatch = Stopwatch.StartNew();
            
            try
            {
                _logger.LogInformation("Попытка входа пользователя: {Email}", request.Email);

                // Имитация задержки для тестирования производительности
                if (request.Email.Contains("slow"))
                {
                    await Task.Delay(600); // Искусственная задержка для тестирования p99 > 500ms
                }

                var user = await _context.Users
                    .FirstOrDefaultAsync(u => u.Email == request.Email && u.Password == request.Password && u.IsActive);

                if (user == null)
                {
                    _logger.LogWarning("Неудачная попытка входа для email: {Email}", request.Email);
                    return Unauthorized(new { message = "Неверные учетные данные" });
                }

                stopwatch.Stop();
                _logger.LogInformation("Успешный вход пользователя {Email} за {ElapsedMs}ms", 
                    request.Email, stopwatch.ElapsedMilliseconds);

                return Ok(new
                {
                    id = user.Id,
                    nick = user.Nick,
                    email = user.Email,
                    message = "Успешный вход"
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Ошибка при входе пользователя {Email}", request.Email);
                return StatusCode(500, new { message = "Внутренняя ошибка сервера" });
            }
        }

        [HttpGet("health")]
        public IActionResult Health()
        {
            return Ok(new { status = "OK", timestamp = DateTime.UtcNow });
        }
    }

    public class LoginRequest
    {
        public string Email { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
    }
} 