# Руководство по трейсингу и анализу производительности

## 1. Трейсинг с Jaeger

### Настройка трейсинга

Система настроена с полной интеграцией OpenTelemetry и Jaeger для distributed tracing:

#### Конфигурация (.NET API)

```csharp
// Program.cs
builder.Services.AddOpenTelemetry()
    .WithTracing(tracerProviderBuilder =>
        tracerProviderBuilder
            .AddSource("CorporatePortalApi.Orders")
            .AddSource("CorporatePortalApi.Info")
            .AddSource("CorporatePortalApi.Performance")
            .AddAspNetCoreInstrumentation()
            .AddHttpClientInstrumentation()
            .AddEntityFrameworkCoreInstrumentation()
            .AddJaegerExporter())
```

#### Кастомные трейсы в контроллерах

```csharp
// OrdersController.cs
private static readonly ActivitySource ActivitySource = new("CorporatePortalApi.Orders");

[HttpGet]
public async Task<IActionResult> GetOrders()
{
    using var activity = ActivitySource.StartActivity("GetOrders");
    activity?.SetTag("orders.filter.status", status);

    // Трейсинг медленных операций
    if (status?.Contains("slow") == true)
    {
        using var delayActivity = ActivitySource.StartActivity("SimulateSlowOperation");
        delayActivity?.SetTag("delay.reason", "artificial_slowness");
        await Task.Delay(700);
    }

    // Трейсинг DB операций
    using var dbActivity = ActivitySource.StartActivity("DatabaseQuery");
    dbActivity?.SetTag("db.operation", "select_orders");
    var orders = await query.ToListAsync();
    dbActivity?.SetTag("db.result.count", orders.Count);
}
```

#### Load Tester с trace headers

```python
# load-tester/app.py
trace_id = uuid.uuid4().hex
span_id = uuid.uuid4().hex[:16]

headers = {
    'traceparent': f'00-{trace_id}-{span_id}-01',  # W3C Trace Context
    'x-trace-id': trace_id,
    'x-load-test': 'true',
    'user-agent': 'CorporatePortal-LoadTester/1.0'
}

response = requests.get(f"{API_URL}{endpoint}", headers=headers, timeout=10)
```

### Связь между сервисами в трейсах

**Демонстрация связи Load Tester → API:**

1. **Load Tester генерирует уникальные trace ID** для каждого запроса
2. **API принимает trace context** и продолжает трейс
3. **Jaeger показывает полную картину** от load tester до database

**Доступ к Jaeger UI:**

- URL: http://localhost:16686
- Service: `CorporatePortalApi`
- Поиск по: operation, tags, duration

**Ключевые трейсы для анализа:**

- `GetOrders` - обычные запросы заказов
- `SimulateSlowOperation` - искусственные задержки
- `DatabaseQuery` - операции с БД
- `InefficientUserQuery` - N+1 query проблема
- `ProblematicEndpoint` - endpoint с множественными проблемами

### Grafana + Jaeger интеграция

**Дашборд трейсинга:** http://localhost:3000/d/tracing-dashboard

Включает:

- **Prometheus метрики** - RPS, response time, system metrics
- **Jaeger трейсы** - интегрированные в дашборд
- **Корреляция данных** - связь между метриками и трейсами

## 2. Performance Tool - анализ производительности

### Созданные проблемы для демонстрации

#### 2.1 N+1 Query Problem (OrdersController.cs)

**Проблемный код:**

```csharp
// PERFORMANCE PROBLEM: N+1 Query
foreach (var order in orders)
{
    if (order.AssignedUserId.HasValue)
    {
        // Отдельный запрос для каждого заказа!
        order.AssignedUser = await _context.Users
            .FirstOrDefaultAsync(u => u.Id == order.AssignedUserId);
        await Task.Delay(50); // Дополнительная задержка
    }
}
```

**Как обнаружить:**

1. **Jaeger Tracing** - видны множественные `InefficientUserQuery` spans
2. **Performance Analyzer** - API `/api/performance/analyze`
3. **Prometheus metrics** - высокие значения response time

**Решение:**

```csharp
// ИСПРАВЛЕННАЯ версия
var query = _context.Orders
    .Include(o => o.AssignedUser)  // Eager loading
    .AsQueryable();
```

#### 2.2 Синхронные операции (PerformanceController.cs)

**Проблемный код:**

```csharp
// ПРОБЛЕМА: Синхронная операция в async методе
Thread.Sleep(200); // Блокирует поток!
```

**Решение:**

```csharp
// ИСПРАВЛЕННАЯ версия
await Task.Delay(200); // Асинхронная задержка
```

#### 2.3 Неэффективная фильтрация

**Проблемный код:**

```csharp
// Неэффективно: фильтрация в памяти
var allOrders = await _context.Orders.ToListAsync();
var filteredOrders = allOrders.Where(o => o.CreatedAt > DateTime.Now.AddDays(-30)).ToList();
```

**Решение:**

```csharp
// ИСПРАВЛЕННАЯ версия: фильтрация в SQL
var filteredOrders = await _context.Orders
    .Where(o => o.CreatedAt > DateTime.Now.AddDays(-30))
    .ToListAsync();
```

#### 2.4 Избыточные запросы

**Проблемный код:**

```csharp
var count1 = await _context.Orders.CountAsync();
var count2 = await _context.Orders.CountAsync(); // Дублированный!
var count3 = await _context.Orders.CountAsync(); // Еще один!
```

#### 2.5 Утечка памяти

**Проблемный код:**

```csharp
var leakyData = new List<byte[]>();
for (int i = 0; i < 1000; i++)
{
    leakyData.Add(new byte[10000]); // 10MB не освобождается
}
```

### Инструменты для анализа производительности

#### 2.1 Custom Performance Analyzer

**API Endpoint:** `GET /api/performance/analyze`

Анализирует:

- **Медленные операции** (>100ms threshold)
- **N+1 query patterns**
- **Memory usage** и GC stats
- **Database performance**

**Пример ответа:**

```json
{
  "analysis_time": 718,
  "performance_issues": [
    {
      "category": "n_plus_one_queries",
      "data": {
        "detected_patterns": 1,
        "issues": [
          {
            "file": "OrdersController.cs",
            "lines": [67, 102],
            "severity": "CRITICAL",
            "fix": "Use .Include(o => o.AssignedUser) in initial query",
            "estimated_performance_gain": "70-90%"
          }
        ]
      }
    }
  ],
  "recommendations": {
    "priority_fixes": ["Fix N+1 query patterns in OrdersController (CRITICAL)"]
  }
}
```

#### 2.2 Problematic Endpoint

**API Endpoint:** `GET /api/performance/problematic-endpoint`

Демонстрирует **5 типов performance проблем** одновременно:

1. Синхронные операции
2. N+1 queries
3. Неэффективная фильтрация
4. Избыточные запросы
5. Утечка памяти

**Пример ответа:**

```json
{
  "execution_time_ms": 954,
  "detected_issues": [
    "ISSUE: Synchronous Thread.Sleep(200) found at line 89",
    "ISSUE: N+1 query pattern found at line 102-108",
    "ISSUE: In-memory filtering instead of SQL WHERE clause at line 116",
    "ISSUE: Redundant database queries at lines 121-123",
    "ISSUE: Potential memory leak - large objects not disposed at line 129"
  ],
  "recommendations": [
    "Replace Thread.Sleep with Task.Delay",
    "Use .Include() to avoid N+1 queries",
    "Move filtering to SQL query level"
  ]
}
```

### Демонстрация процесса отладки

#### Шаг 1: Обнаружение проблемы

**Через Grafana/Prometheus:**

```bash
# P99 response time > 500ms
histogram_quantile(0.99, rate(http_server_request_duration_seconds_bucket[5m])) > 0.5
```

**Через Load Testing:**

```bash
curl -X POST http://localhost:8080/api/start \
  -H "Content-Type: application/json" \
  -d '{"rps": 20, "duration": 60, "endpoint": "/api/orders"}'
```

#### Шаг 2: Анализ с Jaeger

1. **Открываем Jaeger UI:** http://localhost:16686
2. **Выбираем service:** `CorporatePortalApi`
3. **Ищем медленные трейсы:** duration > 500ms
4. **Анализируем span структуру:**
   - Основной `GetOrders` span
   - Множественные `InefficientUserQuery` spans
   - Видим N+1 pattern в timeline

#### Шаг 3: Performance Analysis API

```bash
curl http://localhost:6500/api/performance/analyze
```

**Получаем точную диагностику:**

- Файл: `OrdersController.cs`
- Строки: `67, 102`
- Проблема: `N+1 query pattern`
- Решение: `Use .Include(o => o.AssignedUser)`

#### Шаг 4: Исправление проблемы

**Было:**

```csharp
var orders = await _context.Orders.ToListAsync();
// N+1 проблема в foreach loop
```

**Стало:**

```csharp
var orders = await _context.Orders
    .Include(o => o.AssignedUser)  // Исправление!
    .ToListAsync();
```

#### Шаг 5: Проверка исправления

1. **Пересобираем API:** `docker-compose build corporate-api`
2. **Перезапускаем:** `docker-compose restart corporate-api`
3. **Повторяем нагрузочное тестирование**
4. **Проверяем в Jaeger:** исчезли множественные DB запросы
5. **Проверяем в Grafana:** P99 < 500ms

### URL и доступы для демонстрации

**Основные сервисы:**

- **API:** http://localhost:6500
- **Jaeger UI:** http://localhost:16686
- **Grafana:** http://localhost:3000 (admin/admin)
- **Prometheus:** http://localhost:9090
- **Load Tester:** http://localhost:8080

**Performance API endpoints:**

- **Анализ:** `GET /api/performance/analyze`
- **Проблемный endpoint:** `GET /api/performance/problematic-endpoint`
- **Обычные заказы:** `GET /api/orders`
- **Медленные заказы:** `GET /api/orders?status=slow`

**Grafana дашборды:**

- **Основной:** Corporate Portal Observability Dashboard
- **Трейсинг:** Corporate Portal - Tracing & Performance

### Сценарий для скринкаста

#### 1. Демонстрация проблемы (2-3 минуты)

1. **Запуск нагрузочного тестирования:**

```bash
curl -X POST http://localhost:8080/api/start \
  -d '{"rps": 20, "duration": 60, "endpoint": "/api/orders"}'
```

2. **Показ в Grafana:** P99 response time > 500ms alert
3. **Показ в Prometheus:** high response time metrics

#### 2. Анализ с инструментами (3-4 минуты)

1. **Jaeger UI анализ:**

   - Поиск медленных трейсов
   - Анализ span структуры
   - Обнаружение N+1 pattern

2. **Performance Analyzer:**

```bash
curl http://localhost:6500/api/performance/analyze | jq
```

- Точное указание файла и строк
- CRITICAL severity
- Рекомендации по исправлению

#### 3. Исправление проблемы (1-2 минуты)

1. **Показ проблемного кода** в OrdersController.cs
2. **Исправление:** добавление `.Include(o => o.AssignedUser)`
3. **Пересборка:** `docker-compose build corporate-api`

#### 4. Проверка результата (1-2 минуты)

1. **Повторное тестирование**
2. **Jaeger:** исчезновение N+1 spans
3. **Grafana:** P99 < 500ms
4. **Performance gain:** 70-90% улучшение

### Дополнительные инструменты

**Для продвинутого анализа:**

- **dotnet-counters** - real-time .NET performance counters
- **PerfView** - .NET memory and CPU profiling
- **Application Insights** - cloud-based performance monitoring
- **SQL Server Profiler** - database query analysis

**Команды для мониторинга:**

```bash
# .NET performance counters
dotnet-counters monitor --process-id <pid>

# Memory dump analysis
dotnet-dump collect -p <pid>

# GC monitoring
dotnet-gcdump collect -p <pid>
```

Эта система демонстрирует полный цикл performance debugging - от обнаружения проблемы до ее исправления с помощью современных инструментов трейсинга и анализа производительности.
