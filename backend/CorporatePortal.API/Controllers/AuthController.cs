using Microsoft.AspNetCore.Mvc;
using CorporatePortal.API.DTOs.Auth;
using CorporatePortal.API.Services;

namespace CorporatePortal.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly IAuthService _authService;
        private readonly ILogger<AuthController> _logger;

        public AuthController(IAuthService authService, ILogger<AuthController> logger)
        {
            _authService = authService;
            _logger = logger;
        }

        /// <summary>
        /// Вход в систему
        /// </summary>
        /// <param name="request">Данные для входа</param>
        /// <returns>JWT токен и информация о пользователе</returns>
        [HttpPost("login")]
        [ProducesResponseType(typeof(LoginResponse), 200)]
        [ProducesResponseType(401)]
        public async Task<ActionResult<LoginResponse>> Login([FromBody] LoginRequest request)
        {
            try
            {
                _logger.LogInformation("Login attempt for user: {Email}", request.Email);
                
                var response = await _authService.LoginAsync(request);
                
                _logger.LogInformation("Successful login for user: {Email}", request.Email);
                return Ok(response);
            }
            catch (UnauthorizedAccessException)
            {
                _logger.LogWarning("Failed login attempt for user: {Email}", request.Email);
                return Unauthorized(new { message = "Invalid credentials" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error during login for user: {Email}", request.Email);
                return StatusCode(500, new { message = "Internal server error" });
            }
        }

        /// <summary>
        /// Обновление токена
        /// </summary>
        /// <param name="refreshToken">Refresh токен</param>
        /// <returns>Новый JWT токен</returns>
        [HttpPost("refresh")]
        [ProducesResponseType(typeof(string), 200)]
        [ProducesResponseType(401)]
        public async Task<ActionResult<string>> RefreshToken([FromBody] string refreshToken)
        {
            try
            {
                var newToken = await _authService.RefreshTokenAsync(refreshToken);
                return Ok(new { token = newToken });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error refreshing token");
                return Unauthorized(new { message = "Invalid refresh token" });
            }
        }
    }
} 