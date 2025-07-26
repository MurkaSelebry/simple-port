using System.ComponentModel.DataAnnotations;

namespace CorporatePortal.API.DTOs.Chat
{
    public class ChatRequest
    {
        [Required]
        [StringLength(4000)]
        public string Query { get; set; } = string.Empty;
    }

    public class ChatResponse
    {
        public string Answer { get; set; } = string.Empty;
        public List<ChatSource> Sources { get; set; } = new();
    }

    public class ChatSource
    {
        public string Filename { get; set; } = string.Empty;
        public string Source { get; set; } = string.Empty;
    }
} 