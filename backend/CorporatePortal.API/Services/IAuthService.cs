using CorporatePortal.API.DTOs.Auth;

namespace CorporatePortal.API.Services
{
    public interface IAuthService
    {
        Task<LoginResponse> LoginAsync(LoginRequest request);
        Task<string> RefreshTokenAsync(string refreshToken);
        Task<bool> ValidateTokenAsync(string token);
        Task<int> GetUserIdFromTokenAsync(string token);
    }
} 