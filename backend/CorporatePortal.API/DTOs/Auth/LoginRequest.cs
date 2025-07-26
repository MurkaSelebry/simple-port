using System.ComponentModel.DataAnnotations;

namespace CorporatePortal.API.DTOs.Auth
{
    public class LoginRequest
    {
        [Required]
        [StringLength(50)]
        public string Nickname { get; set; } = string.Empty;

        [Required]
        [EmailAddress]
        public string Email { get; set; } = string.Empty;

        [Required]
        [StringLength(100, MinimumLength = 6)]
        public string Password { get; set; } = string.Empty;
    }
} 