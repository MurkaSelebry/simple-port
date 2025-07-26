using System.CommandLine;
using System.Diagnostics;

var rpsOption = new Option<int>("--rps", () => 10, "Requests per second");
var durationOption = new Option<int>("--duration", () => 30, "Test duration in seconds");
var urlOption = new Option<string>("--url", () => "http://localhost:5000", "Target URL");
var endpointOption = new Option<string>("--endpoint", () => "/api/orders", "Target endpoint");

var rootCommand = new RootCommand("Load testing tool for Corporate Portal API")
{
    rpsOption,
    durationOption,
    urlOption,
    endpointOption
};

rootCommand.SetHandler(async (rps, duration, url, endpoint) =>
{
    await RunLoadTest(rps, duration, url, endpoint);
}, rpsOption, durationOption, urlOption, endpointOption);

await rootCommand.InvokeAsync(args);

static async Task RunLoadTest(int rps, int duration, string baseUrl, string endpoint)
{
    Console.WriteLine($"Starting load test:");
    Console.WriteLine($"  Target: {baseUrl}{endpoint}");
    Console.WriteLine($"  RPS: {rps}");
    Console.WriteLine($"  Duration: {duration} seconds");
    Console.WriteLine();

    var httpClient = new HttpClient();
    var stopwatch = Stopwatch.StartNew();
    var totalRequests = 0;
    var successfulRequests = 0;
    var failedRequests = 0;
    var responseTimes = new List<long>();

    var delayBetweenRequests = TimeSpan.FromSeconds(1.0 / rps);
    var endTime = DateTime.UtcNow.AddSeconds(duration);

    Console.WriteLine("Starting requests...");

    while (DateTime.UtcNow < endTime)
    {
        var requestStopwatch = Stopwatch.StartNew();
        
        try
        {
            var response = await httpClient.GetAsync($"{baseUrl}{endpoint}");
            requestStopwatch.Stop();
            
            totalRequests++;
            responseTimes.Add(requestStopwatch.ElapsedMilliseconds);

            if (response.IsSuccessStatusCode)
            {
                successfulRequests++;
            }
            else
            {
                failedRequests++;
            }

            if (totalRequests % 10 == 0)
            {
                Console.WriteLine($"Processed {totalRequests} requests...");
            }
        }
        catch (Exception ex)
        {
            failedRequests++;
            Console.WriteLine($"Request failed: {ex.Message}");
        }

        await Task.Delay(delayBetweenRequests);
    }

    stopwatch.Stop();

    // Вычисляем статистику
    var avgResponseTime = responseTimes.Any() ? responseTimes.Average() : 0;
    var minResponseTime = responseTimes.Any() ? responseTimes.Min() : 0;
    var maxResponseTime = responseTimes.Any() ? responseTimes.Max() : 0;
    var p95ResponseTime = responseTimes.Any() ? responseTimes.OrderBy(x => x).Skip((int)(responseTimes.Count * 0.95)).FirstOrDefault() : 0;
    var p99ResponseTime = responseTimes.Any() ? responseTimes.OrderBy(x => x).Skip((int)(responseTimes.Count * 0.99)).FirstOrDefault() : 0;

    Console.WriteLine();
    Console.WriteLine("=== Load Test Results ===");
    Console.WriteLine($"Total Duration: {stopwatch.Elapsed.TotalSeconds:F2} seconds");
    Console.WriteLine($"Total Requests: {totalRequests}");
    Console.WriteLine($"Successful Requests: {successfulRequests}");
    Console.WriteLine($"Failed Requests: {failedRequests}");
    Console.WriteLine($"Success Rate: {(double)successfulRequests / totalRequests * 100:F2}%");
    Console.WriteLine($"Average RPS: {totalRequests / stopwatch.Elapsed.TotalSeconds:F2}");
    Console.WriteLine();
    Console.WriteLine("Response Times (ms):");
    Console.WriteLine($"  Average: {avgResponseTime:F2}");
    Console.WriteLine($"  Min: {minResponseTime}");
    Console.WriteLine($"  Max: {maxResponseTime}");
    Console.WriteLine($"  P95: {p95ResponseTime}");
    Console.WriteLine($"  P99: {p99ResponseTime}");

    // Проверяем алерты
    if (p99ResponseTime > 500)
    {
        Console.WriteLine();
        Console.WriteLine("⚠️  WARNING: P99 response time exceeds 500ms threshold!");
    }

    if (totalRequests / stopwatch.Elapsed.TotalSeconds > 100)
    {
        Console.WriteLine();
        Console.WriteLine("⚠️  WARNING: Request rate exceeds 100 RPS threshold!");
    }
} 