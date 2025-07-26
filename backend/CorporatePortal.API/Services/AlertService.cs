using System.Text;
using System.Text.Json;

namespace CorporatePortal.API.Services
{
    public class AlertService : IAlertService
    {
        private readonly IConfiguration _configuration;
        private readonly ILogger<AlertService> _logger;
        private readonly HttpClient _httpClient;

        public AlertService(IConfiguration configuration, ILogger<AlertService> logger, HttpClient httpClient)
        {
            _configuration = configuration;
            _logger = logger;
            _httpClient = httpClient;
        }

        public async Task SendAlertAsync(string message, string level = "info")
        {
            try
            {
                var botToken = _configuration["TELEGRAM_BOT_TOKEN"];
                var chatId = _configuration["TELEGRAM_CHAT_ID"];

                if (string.IsNullOrEmpty(botToken) || string.IsNullOrEmpty(chatId))
                {
                    _logger.LogWarning("Telegram bot token or chat ID not configured");
                    return;
                }

                var emoji = level switch
                {
                    "error" => "🚨",
                    "warning" => "⚠️",
                    "info" => "ℹ️",
                    _ => "ℹ️"
                };

                var formattedMessage = $"{emoji} **{level.ToUpper()}**\n\n{message}\n\n⏰ {DateTime.UtcNow:yyyy-MM-dd HH:mm:ss} UTC";

                var payload = new
                {
                    chat_id = chatId,
                    text = formattedMessage,
                    parse_mode = "Markdown"
                };

                var json = JsonSerializer.Serialize(payload);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var url = $"https://api.telegram.org/bot{botToken}/sendMessage";
                var response = await _httpClient.PostAsync(url, content);

                if (response.IsSuccessStatusCode)
                {
                    _logger.LogInformation("Alert sent successfully: {Message}", message);
                }
                else
                {
                    _logger.LogError("Failed to send alert. Status: {Status}, Response: {Response}", 
                        response.StatusCode, await response.Content.ReadAsStringAsync());
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending alert: {Message}", message);
            }
        }

        public async Task SendPerformanceAlertAsync(string endpoint, double latency, double threshold)
        {
            var message = $"**Performance Alert**\n\n" +
                         $"Endpoint: `{endpoint}`\n" +
                         $"Latency: **{latency:F2}ms**\n" +
                         $"Threshold: {threshold:F2}ms\n\n" +
                         $"⚠️ Response time exceeds p99 threshold!";

            await SendAlertAsync(message, "warning");
        }

        public async Task SendDatabaseAlertAsync(int rps, double threshold)
        {
            var message = $"**Database Alert**\n\n" +
                         $"Database RPS: **{rps}**\n" +
                         $"Threshold: {threshold}\n\n" +
                         $"⚠️ Database load exceeds threshold!";

            await SendAlertAsync(message, "warning");
        }
    }
} 