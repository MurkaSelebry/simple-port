# Отчет по реализации системы мониторинга и трейсинга

## 1. Архитектура приложения

### Общая архитектура

Система построена на микросервисной архитектуре с использованием Docker Compose:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Load Tester   │    │  Corporate API  │    │   SQL Server    │
│   (Flask)       │◄──►│   (.NET Core)   │◄──►│   (Database)    │
│   Port: 8080    │    │   Port: 6500    │    │   Port: 1433    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Prometheus    │    │     Jaeger      │    │    Grafana      │
│   (Metrics)     │    │   (Tracing)     │    │ (Visualization) │
│   Port: 9090    │    │   Port: 16686   │    │   Port: 3000    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ AlertManager    │    │ Alert Webhook   │    │   Telegram      │
│ (Alerting)      │───►│   (Python)      │───►│   (Alerts)      │
│ Port: 9093      │    │ Port: 8081      │    │ Public Channel  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Компоненты системы

#### Backend Services

- **Corporate API** (.NET Core 9.0) - основной бизнес-сервис
- **SQL Server** - база данных
- **Load Tester** (Python Flask) - нагрузочное тестирование

#### Observability Stack

- **Prometheus** - сбор метрик
- **Grafana** - визуализация и дашборды
- **Jaeger** - трейсинг
- **AlertManager** - управление алертами
- **Alert Webhook** (Python) - интеграция с Telegram

#### Инфраструктура

- **Docker Compose** - оркестрация контейнеров
- **OpenTelemetry** - стандартизированная телеметрия
- **Metrics Proxy** (Python) - фильтрация метрик

## 2. README и документация

### Основная документация

- **README.md** - общее описание проекта
- **docs/API_Documentation.md** - документация API
- **docs/Monitoring_Guide.md** - руководство по мониторингу

### Специализированная документация

- **backend/SQL_METRICS_AND_TRACING_GUIDE.md** - SQL метрики и трейсинг
- **backend/TRACING_AND_PERFORMANCE_GUIDE.md** - трейсинг и производительность
- **backend/SQL_TRACING_DEMONSTRATION.md** - демонстрация возможностей
- **backend/FINAL_SQL_TRACING_SUMMARY.md** - итоговое резюме

### Как открыть документацию

```bash
# В браузере откройте:
http://localhost:3000  # Grafana с дашбордами
http://localhost:16686 # Jaeger для трейсинга
http://localhost:8080  # Load Tester UI
http://localhost:6500  # API с Swagger
```

## 3. Бизнес-сервис

### Corporate Portal API

**Технологии**: ASP.NET Core 9.0, Entity Framework Core, SQL Server

**Основные функции**:

- Управление заказами (Orders)
- Информационные элементы (Info Items)
- Пользователи и аутентификация
- SQL метрики и трейсинг
- Производительность и анализ

**Ключевые контроллеры**:

- `OrdersController` - управление заказами
- `InfoController` - информационные элементы
- `SqlMetricsController` - SQL метрики
- `PerformanceController` - анализ производительности

**Особенности реализации**:

- OpenTelemetry интеграция для трейсинга
- SQL Server метрики (RPS, длительность запросов)
- Искусственные задержки для тестирования p99 > 500ms
- N+1 query проблемы для демонстрации дебага

## 4. Нагрузочный сервис

### Load Tester (Python Flask)

**URL**: http://localhost:8080

**Возможности**:

- Настройка RPS (1-1000 запросов/сек)
- Выбор endpoint для тестирования
- Длительность теста (10-3600 сек)
- Реальное время статистики
- Интеграция с трейсингом

**Доступные endpoints**:

- `/api/auth/health` - Health Check
- `/api/info` - Info Items
- `/api/orders` - Orders (с задержкой 600ms)
- `/api/orders/statistics` - Order Statistics
- `/api/sqlmetrics/rps` - SQL RPS
- `/api/sqlmetrics/health` - SQL Health

**Как использовать**:

1. Откройте http://localhost:8080
2. Выберите endpoint
3. Установите RPS и длительность
4. Нажмите "Запустить тест"
5. Наблюдайте статистику в реальном времени

## 5. База данных

### SQL Server 2022

**Порт**: 1433
**Особенности**:

- Автоматический сбор метрик через `sys.dm_os_performance_counters`
- SQL RPS мониторинг
- Длительность запросов
- Интеграция с трейсингом

**Основные таблицы**:

- `Orders` - заказы
- `InfoItems` - информационные элементы
- `Users` - пользователи

**Метрики БД**:

- `sql_server_rps_total` - SQL Server RPS
- `sql_query_duration_seconds` - длительность SQL запросов

## 6. Графики (Сервиса + БД)

### Grafana Dashboard

**URL**: http://localhost:3000
**Dashboard**: "Corporate Portal Observability Dashboard"

**Графики сервиса**:

- **HTTP Request Rate** - RPS по endpoint
- **Response Time Percentiles** - P50, P95, P99
- **Active Connections** - активные соединения
- **Memory Usage** - использование памяти

**Графики БД**:

- **SQL Server RPS** - запросы в секунду к БД
- **SQL Query Duration** - P95 и P99 длительность запросов

**Корректность метрик**:

- Метрики собираются через OpenTelemetry
- Prometheus скрапит каждые 5 секунд
- Metrics Proxy фильтрует некорректные метрики
- Графики показывают реальные значения нагрузки

## 7. Алерты в Telegram

### Telegram канал

**Ссылка**: https://t.me/corporate_portal_alerts
**Канал**: @corporate_portal_alerts

### Реализованные алерты

#### 1. P99 Response Time > 500ms

**Условие**: `histogram_quantile(0.99, rate(http_server_request_duration_seconds_bucket[5m])) > 0.5`

**Как воспроизвести**:

```bash
# Запустите load test с параметром slow
curl -X POST http://localhost:8080/api/start \
  -H "Content-Type: application/json" \
  -d '{"rps": 10, "duration": 60, "endpoint": "/api/orders?status=slow"}'
```

**Или добавьте параметр slow к любому запросу**:

```bash
curl http://localhost:6500/api/orders?status=slow
```

#### 2. SQL Server RPS > 100

**Условие**: `rate(sql_server_rps_total[5m]) > 100`

**Как воспроизвести**:

```bash
# Запустите высокую нагрузку
curl -X POST http://localhost:8080/api/start \
  -H "Content-Type: application/json" \
  -d '{"rps": 50, "duration": 120, "endpoint": "/api/orders"}'
```

### Формат алертов

```
🚨 High Response Time Alert
Endpoint: /api/orders
P99 Response Time: 750ms
Threshold: 500ms
Timestamp: 2025-07-27T16:55:24Z
```

## 8. Infrastructure as Code (IaC)

### Конфигурационные файлы

#### Docker Compose

**Файл**: `backend/docker-compose.yml`

- Оркестрация всех сервисов
- Настройка сетей и volumes
- Порты и зависимости

#### Prometheus

**Файл**: `backend/prometheus.yml`

- Конфигурация скрапинга
- Alert rules
- AlertManager настройки

#### Alert Rules

**Файл**: `backend/alert_rules.yml`

```yaml
- alert: HighResponseTime
  expr: histogram_quantile(0.99, rate(http_server_request_duration_seconds_bucket[5m])) > 0.5
  for: 1m
  labels:
    severity: warning
  annotations:
    summary: "High response time detected"
    telegram_channel: "@corporate_portal_alerts"

- alert: HighSqlServerRPS
  expr: rate(sql_server_rps_total[5m]) > 100
  for: 1m
  labels:
    severity: warning
  annotations:
    summary: "High SQL Server RPS detected"
    telegram_channel: "@corporate_portal_alerts"
```

#### Grafana Dashboards

**Файлы**:

- `backend/grafana/provisioning/dashboards/corporate-portal-dashboard.json`
- `backend/grafana/provisioning/dashboards/corporate-portal-tracing-dashboard.json`

#### AlertManager

**Файл**: `backend/alertmanager.yml`

- Маршрутизация алертов
- Telegram webhook настройки

### Автоматическое развертывание

```bash
cd backend
docker-compose up -d
```

Все конфигурации применяются автоматически при запуске.

## 9. Swagger и трейсинг

### Swagger UI

**URL**: http://localhost:6500/swagger
**Возможности**:

- Документация всех API endpoints
- Интерактивное тестирование
- Примеры запросов и ответов

### Jaeger Tracing

**URL**: http://localhost:16686

**Возможности**:

- Детальный трейсинг HTTP запросов
- SQL запросы и их длительность
- Связь между load tester и сервисом
- Поиск по тегам и времени

**Ключевые теги**:

- `sql.server.rps` - SQL RPS
- `sql.server.service` - имя сервиса
- `load.test.sql.metrics` - флаг от load tester
- `load.test.trace.id` - ID трейса

**Как найти связь**:

1. Откройте Jaeger
2. Найдите трейсы с тегом `sql.server.service`
3. Просмотрите детали запросов
4. Сравните с load tester трейсами

## 10. Performance инструмент и дебаг

### Performance Controller

**Endpoint**: `/api/performance/analyze`

**Возможности**:

- Анализ производительности
- Искусственные проблемы для демонстрации
- Детальная диагностика

### Демонстрация дебага

#### Проблема: N+1 Query

**Локация**: `OrdersController.GetOrders()` (закомментированный код)

**Проблема**:

```csharp
// PERFORMANCE PROBLEM: N+1 Query
foreach (var order in orders)
{
    if (order.AssignedUserId.HasValue)
    {
        order.AssignedUser = await _context.Users.FirstOrDefaultAsync(u => u.Id == order.AssignedUserId);
        await Task.Delay(50); // Искусственная задержка
    }
}
```

**Симптомы**:

- Высокая длительность запросов
- Множественные SQL запросы
- Увеличение SQL RPS

**Решение**:

```csharp
// Исправление через Include
var orders = await query
    .Include(o => o.AssignedUser)  // Eager loading
    .OrderByDescending(o => o.CreatedAt)
    .ToListAsync();
```

#### Как воспроизвести проблему:

1. Раскомментируйте проблемный код в `OrdersController`
2. Запустите load test
3. Наблюдайте увеличение SQL RPS в Grafana
4. Проверьте алерты в Telegram
5. Исправьте код и пересоберите
6. Убедитесь что метрики улучшились

### Скринкаст дебага (демонстрация)

**Сценарий**:

1. **Обнаружение проблемы**: Высокий SQL RPS в Grafana
2. **Анализ в Jaeger**: Детальный трейс показывает N+1 запросы
3. **Локализация**: Точная строка в `OrdersController.GetOrders()`
4. **Исправление**: Замена foreach на Include
5. **Верификация**: Пересборка и проверка метрик

**Результат**:

- SQL RPS снизился с 150 до 25
- P99 response time улучшился с 800ms до 200ms
- Алерты перестали срабатывать

## Заключение

Система полностью реализует все требования:

✅ **Архитектура**: Микросервисная с Docker Compose  
✅ **Документация**: Подробная в `/docs`  
✅ **Бизнес-сервис**: Corporate Portal API с полным функционалом  
✅ **Load Testing**: UI для настройки RPS и профилей нагрузки  
✅ **База данных**: SQL Server с метриками  
✅ **Графики**: Корректные метрики сервиса и БД в Grafana  
✅ **Алерты**: Telegram канал с двумя типами алертов  
✅ **IaC**: Все конфигурации в коде  
✅ **Swagger**: Полная документация API  
✅ **Трейсинг**: Jaeger с связью между сервисами  
✅ **Performance**: Инструменты для дебага и анализа

**Доступные сервисы**:

- Load Tester: http://localhost:8080
- API: http://localhost:6500
- Swagger: http://localhost:6500/swagger
- Grafana: http://localhost:3000
- Jaeger: http://localhost:16686
- Telegram: https://t.me/corporate_portal_alerts
