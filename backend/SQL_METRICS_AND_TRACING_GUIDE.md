# SQL Metrics and Tracing Guide

## Обзор

Этот документ описывает интеграцию SQL Server метрик с системой трейсинга Jaeger для демонстрации связи между запросами сервиса и нагрузочного тестирования.

## Компоненты

### 1. SqlMetricsService

**Файл**: `Services/SqlMetricsService.cs`

Сервис для сбора SQL Server метрик:

- Собирает RPS (Requests Per Second) из `sys.dm_os_performance_counters`
- Измеряет длительность SQL запросов
- Интегрируется с OpenTelemetry для трейсинга

**Ключевые метрики**:

- `sql_server_rps_total` - SQL Server RPS
- `sql_query_duration_seconds` - Длительность SQL запросов

### 2. SqlMetricsController

**Файл**: `Controllers/SqlMetricsController.cs`

API endpoints для SQL метрик:

- `GET /api/sqlmetrics/rps` - Текущий SQL RPS
- `GET /api/sqlmetrics/health` - Здоровье SQL сервера

### 3. Интеграция с Трейсингом

Все контроллеры теперь включают SQL метрики в трейсы:

- `sql.server.rps` - Текущий SQL RPS
- `sql.server.service` - Имя сервиса
- `load.test.sql.metrics` - Флаг от load tester
- `load.test.trace.id` - ID трейса от load tester

## Использование

### 1. Запуск системы

```bash
cd backend
docker-compose up -d
```

### 2. Проверка SQL метрик

```bash
# Проверка SQL RPS
curl http://localhost:6500/api/sqlmetrics/rps

# Проверка здоровья SQL сервера
curl http://localhost:6500/api/sqlmetrics/health
```

### 3. Load Testing с SQL метриками

1. Откройте http://localhost:8080
2. Выберите endpoint (например, `/api/orders`)
3. Запустите нагрузочное тестирование
4. Наблюдайте связь между запросами и SQL метриками в Jaeger

### 4. Просмотр в Jaeger

1. Откройте http://localhost:16686
2. Найдите трейсы с тегом `sql.server.service`
3. Просмотрите связь между HTTP запросами и SQL метриками

### 5. Просмотр в Grafana

1. Откройте http://localhost:3000
2. Перейдите на dashboard "Corporate Portal Observability Dashboard"
3. Найдите панели:
   - "SQL Server RPS"
   - "SQL Query Duration"

## Алерты

### SQL Server RPS Alert

**Условие**: `rate(sql_server_rps_total[5m]) > 100`
**Описание**: SQL Server RPS превышает 100 запросов в секунду

### SQL Server Slow Queries Alert

**Условие**: `histogram_quantile(0.99, rate(sql_query_duration_seconds_bucket[5m])) > 0.5`
**Описание**: P99 SQL запросов превышает 500ms

## Демонстрация связи

### Сценарий 1: Нормальная нагрузка

1. Запустите load test на `/api/orders` с RPS = 10
2. Наблюдайте в Jaeger:
   - HTTP запросы с тегом `load.test.sql.metrics: true`
   - SQL метрики в каждом запросе
   - Связь между HTTP и SQL трейсами

### Сценарий 2: Высокая нагрузка

1. Запустите load test на `/api/orders` с RPS = 50
2. Наблюдайте:
   - Увеличение SQL RPS в Grafana
   - Алерты в Telegram при превышении лимитов
   - Детализацию в Jaeger трейсах

### Сценарий 3: Медленные запросы

1. Добавьте параметр `?status=slow` к `/api/orders`
2. Наблюдайте:
   - Искусственные задержки в трейсах
   - SQL метрики с увеличенной длительностью
   - Алерты о медленных запросах

## Структура трейсов

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

## Troubleshooting

### Проблема: Нет SQL метрик

**Решение**:

1. Проверьте подключение к SQL Server
2. Убедитесь, что SqlMetricsService запущен
3. Проверьте логи: `docker logs corporate-api`

### Проблема: Нет связи в Jaeger

**Решение**:

1. Убедитесь, что Jaeger запущен: `docker ps | grep jaeger`
2. Проверьте конфигурацию OpenTelemetry
3. Убедитесь, что трейсы отправляются: `curl http://localhost:6500/api/orders`

### Проблема: Нет алертов

**Решение**:

1. Проверьте Prometheus: http://localhost:9090
2. Проверьте AlertManager: http://localhost:9093
3. Проверьте Telegram бота и канал

## Заключение

Система обеспечивает полную видимость связи между HTTP запросами и SQL Server метриками через:

1. **Трейсинг**: Детальная связь в Jaeger
2. **Метрики**: SQL RPS и длительность в Grafana
3. **Алерты**: Уведомления о проблемах в Telegram
4. **Load Testing**: Имитация реальной нагрузки с трейсингом

Это позволяет эффективно диагностировать проблемы производительности и понимать влияние нагрузки на базу данных.
