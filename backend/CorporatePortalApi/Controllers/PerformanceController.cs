using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using CorporatePortalApi.Data;
using CorporatePortalApi.Models;
using System.Diagnostics;
using System.Reflection;

namespace CorporatePortalApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PerformanceController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<PerformanceController> _logger;
        private static readonly ActivitySource ActivitySource = new("CorporatePortalApi.Performance");

        public PerformanceController(ApplicationDbContext context, ILogger<PerformanceController> logger)
        {
            _context = context;
            _logger = logger;
        }

        [HttpGet("analyze")]
        public async Task<IActionResult> AnalyzePerformance()
        {
            using var activity = ActivitySource.StartActivity("PerformanceAnalysis");
            var analysis = new List<object>();
            var stopwatch = Stopwatch.StartNew();

            try
            {
                // 1. Анализ медленных операций
                activity?.AddEvent(new("starting_slow_operations_analysis", DateTimeOffset.UtcNow));
                var slowOperationsAnalysis = await AnalyzeSlowOperations();
                analysis.Add(new { category = "slow_operations", data = slowOperationsAnalysis });

                // 2. Анализ N+1 запросов
                activity?.AddEvent(new("starting_n_plus_one_analysis", DateTimeOffset.UtcNow));
                var nPlusOneAnalysis = await AnalyzeNPlusOneQueries();
                analysis.Add(new { category = "n_plus_one_queries", data = nPlusOneAnalysis });

                // 3. Анализ использования памяти
                activity?.AddEvent(new("starting_memory_analysis", DateTimeOffset.UtcNow));
                var memoryAnalysis = AnalyzeMemoryUsage();
                analysis.Add(new { category = "memory_usage", data = memoryAnalysis });

                // 4. Анализ базы данных
                activity?.AddEvent(new("starting_database_analysis", DateTimeOffset.UtcNow));
                var databaseAnalysis = await AnalyzeDatabasePerformance();
                analysis.Add(new { category = "database_performance", data = databaseAnalysis });

                stopwatch.Stop();
                activity?.SetTag("analysis.duration_ms", stopwatch.ElapsedMilliseconds);
                activity?.SetTag("analysis.categories_count", analysis.Count);

                return Ok(new
                {
                    analysis_time = stopwatch.ElapsedMilliseconds,
                    timestamp = DateTime.UtcNow,
                    performance_issues = analysis,
                    recommendations = GenerateRecommendations(analysis)
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Ошибка при анализе производительности");
                return StatusCode(500, new { message = "Ошибка анализа производительности" });
            }
        }

        [HttpGet("problematic-endpoint")]
        public async Task<IActionResult> ProblematicEndpoint()
        {
            using var activity = ActivitySource.StartActivity("ProblematicEndpoint");
            activity?.SetTag("endpoint.purpose", "performance_testing");
            
            var stopwatch = Stopwatch.StartNew();
            var issues = new List<string>();

            try
            {
                // ПРОБЛЕМА 1: Синхронные операции в асинхронном методе
                activity?.AddEvent(new("starting_synchronous_operations", DateTimeOffset.UtcNow));
                Thread.Sleep(200); // Блокирует поток!
                issues.Add("ISSUE: Synchronous Thread.Sleep(200) found at line 89");

                // ПРОБЛЕМА 2: N+1 запросы
                activity?.AddEvent(new("starting_n_plus_one_demonstration", DateTimeOffset.UtcNow));
                var orders = await _context.Orders.Take(10).ToListAsync();
                
                foreach (var order in orders)
                {
                    using var subActivity = ActivitySource.StartActivity("IndividualUserQuery");
                    subActivity?.SetTag("performance.issue", "n_plus_one");
                    subActivity?.SetTag("order.id", order.Id);
                    
                    // Отдельный запрос для каждого заказа - N+1 проблема!
                    var user = await _context.Users.FirstOrDefaultAsync(u => u.Id == order.AssignedUserId);
                    await Task.Delay(30); // Дополнительная задержка
                }
                issues.Add("ISSUE: N+1 query pattern found at line 102-108");

                // ПРОБЛЕМА 3: Неэффективная работа с коллекциями
                activity?.AddEvent(new("starting_inefficient_collection_operations", DateTimeOffset.UtcNow));
                var allOrders = await _context.Orders.ToListAsync();
                
                // Неэффективная фильтрация в памяти вместо SQL
                var filteredOrders = allOrders.Where(o => o.CreatedAt > DateTime.Now.AddDays(-30)).ToList();
                issues.Add("ISSUE: In-memory filtering instead of SQL WHERE clause at line 116");

                // ПРОБЛЕМА 4: Избыточные запросы
                activity?.AddEvent(new("starting_redundant_queries", DateTimeOffset.UtcNow));
                var count1 = await _context.Orders.CountAsync();
                var count2 = await _context.Orders.CountAsync(); // Дублированный запрос!
                var count3 = await _context.Orders.CountAsync(); // Еще один!
                issues.Add("ISSUE: Redundant database queries at lines 121-123");

                // ПРОБЛЕМА 5: Утечка памяти (симуляция)
                activity?.AddEvent(new("starting_memory_leak_simulation", DateTimeOffset.UtcNow));
                var leakyData = new List<byte[]>();
                for (int i = 0; i < 1000; i++)
                {
                    leakyData.Add(new byte[10000]); // 10KB * 1000 = 10MB
                }
                issues.Add("ISSUE: Potential memory leak - large objects not disposed at line 129");

                stopwatch.Stop();
                activity?.SetTag("execution.duration_ms", stopwatch.ElapsedMilliseconds);
                activity?.SetTag("issues.count", issues.Count);

                return Ok(new
                {
                    message = "Endpoint executed with multiple performance issues",
                    execution_time_ms = stopwatch.ElapsedMilliseconds,
                    detected_issues = issues,
                    orders_processed = orders.Count,
                    memory_allocated_mb = leakyData.Count * 10 / 1024.0, // Примерный размер
                    recommendations = new[]
                    {
                        "Replace Thread.Sleep with Task.Delay",
                        "Use .Include() to avoid N+1 queries",
                        "Move filtering to SQL query level",
                        "Cache repeated query results", 
                        "Dispose large objects properly"
                    }
                });
            }
            catch (Exception ex)
            {
                activity?.SetTag("error", ex.Message);
                _logger.LogError(ex, "Ошибка в проблемном endpoint");
                return StatusCode(500, new { message = "Ошибка выполнения" });
            }
        }

        private async Task<object> AnalyzeSlowOperations()
        {
            var slowThreshold = 100; // ms
            var operations = new List<object>();

            // Симуляция анализа медленных операций
            var testOperation1 = Stopwatch.StartNew();
            await Task.Delay(150); // Медленная операция
            testOperation1.Stop();

            if (testOperation1.ElapsedMilliseconds > slowThreshold)
            {
                operations.Add(new
                {
                    operation = "TestOperation1",
                    duration_ms = testOperation1.ElapsedMilliseconds,
                    location = "PerformanceController.cs:Line 156",
                    severity = "HIGH",
                    recommendation = "Replace Task.Delay with actual optimized operation"
                });
            }

            return new
            {
                slow_threshold_ms = slowThreshold,
                detected_operations = operations,
                total_issues = operations.Count
            };
        }

        private async Task<object> AnalyzeNPlusOneQueries()
        {
            var issues = new List<object>();
            
            // Проверяем реальную N+1 проблему в OrdersController
            var sourceFile = "OrdersController.cs";
            var problematicLines = new[] { 67, 102 }; // Примерные номера строк

            issues.Add(new
            {
                file = sourceFile,
                lines = problematicLines,
                description = "N+1 query pattern detected in foreach loop",
                severity = "CRITICAL",
                impact = "Each order triggers separate database query",
                fix = "Use .Include(o => o.AssignedUser) in initial query",
                estimated_performance_gain = "70-90%"
            });

            return new
            {
                detected_patterns = issues.Count,
                issues = issues,
                total_estimated_queries_saved = issues.Count * 10 // Примерная оценка
            };
        }

        private object AnalyzeMemoryUsage()
        {
            var gc = GC.GetTotalMemory(false);
            var workingSet = Environment.WorkingSet;
            
            return new
            {
                managed_memory_bytes = gc,
                working_set_bytes = workingSet,
                managed_memory_mb = Math.Round(gc / 1024.0 / 1024.0, 2),
                working_set_mb = Math.Round(workingSet / 1024.0 / 1024.0, 2),
                gc_gen0_collections = GC.CollectionCount(0),
                gc_gen1_collections = GC.CollectionCount(1),
                gc_gen2_collections = GC.CollectionCount(2),
                recommendations = new[]
                {
                    gc > 50 * 1024 * 1024 ? "High managed memory usage detected" : "Memory usage normal",
                    GC.CollectionCount(2) > 10 ? "Frequent Gen2 GC collections" : "GC performance normal"
                }
            };
        }

        private async Task<object> AnalyzeDatabasePerformance()
        {
            var dbAnalysis = new List<object>();
            var stopwatch = Stopwatch.StartNew();

            // Тест производительности запросов
            var simpleQuery = Stopwatch.StartNew();
            var orderCount = await _context.Orders.CountAsync();
            simpleQuery.Stop();

            var complexQuery = Stopwatch.StartNew();
            var complexResult = await _context.Orders
                .Include(o => o.AssignedUser)
                .Where(o => o.CreatedAt > DateTime.Now.AddDays(-30))
                .GroupBy(o => o.Status)
                .Select(g => new { Status = g.Key, Count = g.Count() })
                .ToListAsync();
            complexQuery.Stop();

            dbAnalysis.Add(new
            {
                query_type = "simple_count",
                duration_ms = simpleQuery.ElapsedMilliseconds,
                performance = simpleQuery.ElapsedMilliseconds < 50 ? "Good" : "Needs optimization"
            });

            dbAnalysis.Add(new
            {
                query_type = "complex_aggregation",
                duration_ms = complexQuery.ElapsedMilliseconds,
                performance = complexQuery.ElapsedMilliseconds < 200 ? "Good" : "Needs optimization",
                result_count = complexResult.Count
            });

            return new
            {
                total_orders = orderCount,
                query_performance = dbAnalysis,
                recommendations = new[]
                {
                    "Consider indexing on CreatedAt column",
                    "Monitor query execution plans",
                    "Use query result caching for frequent operations"
                }
            };
        }

        private object GenerateRecommendations(List<object> analysis)
        {
            return new
            {
                priority_fixes = new[]
                {
                    "Fix N+1 query patterns in OrdersController (CRITICAL)",
                    "Replace synchronous operations with async alternatives (HIGH)",
                    "Optimize database queries with proper indexing (MEDIUM)",
                    "Implement caching for frequent operations (MEDIUM)",
                    "Monitor memory usage and GC performance (LOW)"
                },
                tools_to_use = new[]
                {
                    "Jaeger for distributed tracing",
                    "Prometheus for metrics monitoring", 
                    "dotnet-counters for .NET performance",
                    "Application Insights for detailed analytics",
                    "SQL Server Profiler for database optimization"
                },
                next_steps = new[]
                {
                    "1. Fix the identified N+1 query issue",
                    "2. Add performance monitoring middleware",
                    "3. Set up automated performance testing",
                    "4. Create performance budgets and alerts"
                }
            };
        }
    }
} 