namespace CorporatePortal.API.Services
{
    public interface IAlertService
    {
        Task SendAlertAsync(string message, string level = "info");
        Task SendPerformanceAlertAsync(string endpoint, double latency, double threshold);
        Task SendDatabaseAlertAsync(int rps, double threshold);
    }
} 