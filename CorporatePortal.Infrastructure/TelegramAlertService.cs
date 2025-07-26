using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System.Text.Json;

namespace CorporatePortal.Infrastructure;

public interface ITelegramAlertService
{
    Task SendAlertAsync(string message);
    Task SendPerformanceAlertAsync(double p99ResponseTime, string endpoint, int rps);
    Task SendDatabaseLoadAlertAsync(double rps, string endpoint);
}

public class TelegramAlertService : ITelegramAlertService
{
    private readonly HttpClient _httpClient;
    private readonly IConfiguration _configuration;
    private readonly ILogger<TelegramAlertService> _logger;
    private readonly string _botToken;
    private readonly string _channelId;

    public TelegramAlertService(HttpClient httpClient, IConfiguration configuration, ILogger<TelegramAlertService> logger)
    {
        _httpClient = httpClient;
        _configuration = configuration;
        _logger = logger;
        _botToken = _configuration["Telegram:BotToken"] ?? string.Empty;
        _channelId = _configuration["Telegram:ChannelId"] ?? string.Empty;
    }

    public async Task SendAlertAsync(string message)
    {
        if (string.IsNullOrEmpty(_botToken) || string.IsNullOrEmpty(_channelId))
        {
            _logger.LogWarning("Telegram bot token or channel ID not configured");
            return;
        }

        try
        {
            var url = $"https://api.telegram.org/bot{_botToken}/sendMessage";
            var data = new
            {
                chat_id = _channelId,
                text = message,
                parse_mode = "HTML"
            };

            var json = JsonSerializer.Serialize(data);
            var content = new StringContent(json, System.Text.Encoding.UTF8, "application/json");

            var response = await _httpClient.PostAsync(url, content);
            
            if (response.IsSuccessStatusCode)
            {
                _logger.LogInformation("Telegram alert sent successfully");
            }
            else
            {
                _logger.LogError("Failed to send Telegram alert. Status: {StatusCode}", response.StatusCode);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error sending Telegram alert");
        }
    }

    public async Task SendPerformanceAlertAsync(double p99ResponseTime, string endpoint, int rps)
    {
        var message = $"🚨 <b>Performance Alert</b>\n\n" +
                     $"p99 response time exceeded 500ms!\n" +
                     $"Current p99: {p99ResponseTime:F2}ms\n" +
                     $"Endpoint: {endpoint}\n" +
                     $"RPS: {rps}\n" +
                     $"Time: {DateTime.Now:yyyy-MM-dd HH:mm:ss}";

        await SendAlertAsync(message);
    }

    public async Task SendDatabaseLoadAlertAsync(double rps, string endpoint)
    {
        var message = $"🚨 <b>Database Load Alert</b>\n\n" +
                     $"Database RPS exceeded 100!\n" +
                     $"Current RPS: {rps:F2}\n" +
                     $"Endpoint: {endpoint}\n" +
                     $"Time: {DateTime.Now:yyyy-MM-dd HH:mm:ss}";

        await SendAlertAsync(message);
    }
} 