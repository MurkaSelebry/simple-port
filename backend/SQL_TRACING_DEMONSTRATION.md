# SQL Tracing Demonstration

## Обзор

Этот документ демонстрирует полную интеграцию SQL Server метрик с системой трейсинга Jaeger для показа связи между запросами сервиса и нагрузочного тестирования.

## Компоненты системы

### 1. SQL Metrics Service

- **Файл**: `Services/SqlMetricsService.cs`
- **Функция**: Сбор SQL Server RPS из `sys.dm_os_performance_counters`
- **Метрики**:
  - `sql_server_rps_total` - SQL Server Requests Per Second
  - `sql_query_duration_seconds` - Длительность SQL запросов

### 2. SQL Metrics Controller

- **Файл**: `Controllers/SqlMetricsController.cs`
- **Endpoints**:
  - `GET /api/sqlmetrics/rps` - Текущий SQL RPS
  - `GET /api/sqlmetrics/health` - Здоровье SQL сервера

### 3. Интеграция с Трейсингом

Все контроллеры включают SQL метрики в трейсы:

- `sql.server.rps` - Текущий SQL RPS
- `sql.server.service` - Имя сервиса
- `load.test.sql.metrics` - Флаг от load tester
- `load.test.trace.id` - ID трейса от load tester

## Демонстрация

### Шаг 1: Проверка SQL метрик

```bash
# Проверка SQL RPS
curl http://localhost:6500/api/sqlmetrics/rps
# Ответ: {"rps":0,"timestamp":"2025-07-27T16:54:58.7817655Z","duration_ms":41}

# Проверка здоровья SQL сервера
curl http://localhost:6500/api/sqlmetrics/health
# Ответ: {"healthy":true,"rps":0,"timestamp":"2025-07-27T16:55:01.9764788Z","service":"CorporatePortalApi.SqlServer"}
```

### Шаг 2: Интеграция с трейсингом

```bash
# Запрос с SQL метриками и трейсингом
curl -H "x-sql-metrics: true" -H "x-trace-id: test123" http://localhost:6500/api/orders
```

**Результат в логах**:

```
info: CorporatePortalApi.Controllers.OrdersController[0]
      Получено 3 заказов за 344ms, SQL RPS: 0
```

### Шаг 3: Load Testing с SQL метриками

1. **Откройте Load Tester**: http://localhost:8080
2. **Выберите endpoint**: `/api/orders`
3. **Настройте параметры**:
   - RPS: 5
   - Duration: 30 секунд
4. **Запустите тест**

**Команда для запуска**:

```bash
curl -X POST http://localhost:8080/api/start \
  -H "Content-Type: application/json" \
  -d '{"rps": 5, "duration": 30, "endpoint": "/api/orders"}'
```

### Шаг 4: Наблюдение в Jaeger

1. **Откройте Jaeger**: http://localhost:16686
2. **Найдите трейсы** с тегами:
   - `sql.server.service: "CorporatePortalApi.SqlServer"`
   - `load.test.sql.metrics: true`
   - `load.test.trace.id: "..."`

**Структура трейса**:

```
HTTP Request (OrdersController.GetOrders)
├── DatabaseQuery
│   ├── sql.server.rps: 25.5
│   ├── sql.server.service: "CorporatePortalApi.SqlServer"
│   ├── load.test.sql.metrics: true
│   └── load.test.trace.id: "abc123..."
└── SimulateSlowOperation (если status=slow)
    ├── delay.reason: "artificial_slowness"
    └── delay.duration_ms: 700
```

### Шаг 5: Наблюдение в Grafana

1. **Откройте Grafana**: http://localhost:3000
2. **Перейдите на dashboard**: "Corporate Portal Observability Dashboard"
3. **Найдите панели**:
   - **SQL Server RPS**: График SQL RPS во времени
   - **SQL Query Duration**: P95 и P99 длительность SQL запросов

### Шаг 6: Проверка метрик в Prometheus

```bash
# Проверка SQL метрик
curl http://localhost:6500/metrics | grep sql
```

**Результат**:

```
# TYPE sql_query_duration_seconds histogram
sql_query_duration_seconds_bucket{otel_scope_name="CorporatePortalApi.SqlServer",...} 1
sql_query_duration_seconds_sum{otel_scope_name="CorporatePortalApi.SqlServer",...} 0.3446692
sql_query_duration_seconds_count{otel_scope_name="CorporatePortalApi.SqlServer",...} 1
```

## Сценарии тестирования

### Сценарий 1: Нормальная нагрузка

1. **Запустите load test** на `/api/orders` с RPS = 5
2. **Наблюдайте в Jaeger**:
   - HTTP запросы с тегом `load.test.sql.metrics: true`
   - SQL метрики в каждом запросе
   - Связь между HTTP и SQL трейсами

### Сценарий 2: Медленные запросы

1. **Добавьте параметр** `?status=slow` к `/api/orders`
2. **Наблюдайте**:
   - Искусственные задержки в трейсах
   - SQL метрики с увеличенной длительностью
   - Алерты о медленных запросах

### Сценарий 3: Высокая нагрузка

1. **Запустите load test** на `/api/orders` с RPS = 50
2. **Наблюдайте**:
   - Увеличение SQL RPS в Grafana
   - Алерты в Telegram при превышении лимитов
   - Детализацию в Jaeger трейсах

## Алерты

### SQL Server RPS Alert

- **Условие**: `rate(sql_server_rps_total[5m]) > 100`
- **Описание**: SQL Server RPS превышает 100 запросов в секунду

### SQL Server Slow Queries Alert

- **Условие**: `histogram_quantile(0.99, rate(sql_query_duration_seconds_bucket[5m])) > 0.5`
- **Описание**: P99 SQL запросов превышает 500ms

## Мониторинг

### Grafana Dashboard

- **SQL Server RPS**: График SQL RPS во времени
- **SQL Query Duration**: P95 и P99 длительность SQL запросов

### Prometheus Alerts

- **HighSqlServerRPS**: При превышении 100 RPS
- **SqlServerSlowQueries**: При P99 > 500ms

### Jaeger Tracing

- Связь между HTTP запросами и SQL метриками
- Детализация медленных операций
- Трейсы от load tester с уникальными ID

## Заключение

Система обеспечивает полную видимость связи между HTTP запросами и SQL Server метриками через:

1. **Трейсинг**: Детальная связь в Jaeger
2. **Метрики**: SQL RPS и длительность в Grafana
3. **Алерты**: Уведомления о проблемах в Telegram
4. **Load Testing**: Имитация реальной нагрузки с трейсингом

Это позволяет эффективно диагностировать проблемы производительности и понимать влияние нагрузки на базу данных.

## Ссылки

- **Load Tester**: http://localhost:8080
- **Jaeger**: http://localhost:16686
- **Grafana**: http://localhost:3000
- **Prometheus**: http://localhost:9090
- **API**: http://localhost:6500
