using CorporatePortal.Models;

namespace CorporatePortal.Services;

public interface IUserService
{
    Task<User?> AuthenticateAsync(string email, string password);
    Task<IEnumerable<User>> GetAllUsersAsync();
    Task<User?> GetUserByIdAsync(int id);
    Task<User> CreateUserAsync(User user);
    Task<User?> UpdateUserAsync(User user);
    Task<bool> DeleteUserAsync(int id);
} 