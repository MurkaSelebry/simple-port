# Руководство по Мониторингу - Corporate Portal

## Обзор системы мониторинга

Система мониторинга корпоративного портала включает в себя:

- **Prometheus** - сбор и хранение метрик
- **Grafana** - визуализация и дашборды
- **Jaeger** - трейсинг запросов
- **OpenTelemetry** - стандартизированный сбор метрик и трейсов
- **Telegram алерты** - уведомления о проблемах

## Архитектура мониторинга

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Flutter App   │    │   Load Tester   │    │   API (C#)      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │  OpenTelemetry  │
                    └─────────────────┘
                                 │
         ┌───────────────────────┼───────────────────────┐
         │                       │                       │
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│    Jaeger       │    │   Prometheus    │    │   SQL Server    │
│   (Tracing)     │    │   (Metrics)     │    │   (Database)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │     Grafana     │
                    │  (Dashboards)   │
                    └─────────────────┘
                                 │
                    ┌─────────────────┐
                    │   Telegram      │
                    │   (Alerts)      │
                    └─────────────────┘
```

## Компоненты системы

### 1. Prometheus

**URL:** http://localhost:9090

**Назначение:** Сбор и хранение метрик

**Основные метрики:**

- `http_requests_total` - общее количество HTTP запросов
- `http_request_duration_seconds` - время выполнения запросов
- `sqlserver_requests_total` - запросы к базе данных
- `process_cpu_seconds_total` - использование CPU
- `process_resident_memory_bytes` - использование памяти

**Конфигурация:** `backend/prometheus.yml`

### 2. Grafana

**URL:** http://localhost:3000  
**Логин:** admin/admin

**Назначение:** Визуализация метрик и дашборды

**Доступные дашборды:**

- **API Metrics** - метрики API (RPS, время ответа, ошибки)
- **Database Metrics** - метрики SQL Server
- **System Metrics** - системные метрики

### 3. Jaeger

**URL:** http://localhost:16686

**Назначение:** Трейсинг запросов

**Возможности:**

- Просмотр трейсов запросов
- Анализ производительности
- Отладка проблем

### 4. OpenTelemetry

**Назначение:** Стандартизированный сбор метрик и трейсов

**Инструментация:**

- ASP.NET Core автоматическая инструментация
- Entity Framework Core инструментация
- HTTP клиент инструментация

## Метрики и алерты

### Ключевые метрики

#### 1. Производительность API

```promql
# RPS (Requests Per Second)
rate(http_requests_total[5m])

# Время ответа (P95)
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))

# Время ответа (P99)
histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))

# Ошибки (5xx)
rate(http_requests_total{status=~"5.."}[5m])
```

#### 2. База данных

```promql
# RPS базы данных
rate(sqlserver_requests_total[5m])

# Время выполнения запросов
rate(sqlserver_request_duration_seconds_sum[5m]) / rate(sqlserver_request_duration_seconds_count[5m])
```

#### 3. Системные метрики

```promql
# CPU использование
rate(process_cpu_seconds_total[5m]) * 100

# Память
process_resident_memory_bytes / 1024 / 1024

# Доступность сервиса
up
```

### Настроенные алерты

#### 1. Высокое время ответа (P99 > 500ms)

**Условие:**

```promql
histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m])) > 0.5
```

**Действие:** Отправка в Telegram

**Сообщение:**

```
🚨 Высокое время ответа API
P99 response time: 650ms
Service: CorporatePortalApi
Time: 2024-01-15 10:30:00
```

#### 2. Высокая нагрузка на БД (> 100 RPS)

**Условие:**

```promql
rate(sqlserver_requests_total[5m]) > 100
```

**Действие:** Отправка в Telegram

**Сообщение:**

```
🚨 Высокая нагрузка на базу данных
Database RPS: 150
Threshold: 100
Time: 2024-01-15 10:30:00
```

#### 3. Недоступность сервиса

**Условие:**

```promql
up == 0
```

**Действие:** Отправка в Telegram

**Сообщение:**

```
🚨 Сервис недоступен
Service: CorporatePortalApi
Time: 2024-01-15 10:30:00
```

#### 4. Высокий процент ошибок (> 5%)

**Условие:**

```promql
rate(http_requests_total{status=~"5.."}[5m]) / rate(http_requests_total[5m]) > 0.05
```

**Действие:** Отправка в Telegram

## Настройка Telegram алертов

### 1. Создание бота

1. Откройте Telegram и найдите @BotFather
2. Отправьте команду `/newbot`
3. Следуйте инструкциям для создания бота
4. Сохраните токен бота

### 2. Создание канала

1. Создайте новый канал в Telegram
2. Добавьте бота в канал как администратора
3. Получите ID канала (обычно начинается с @)

### 3. Настройка конфигурации

Обновите файл `backend/CorporatePortalApi/appsettings.json`:

```json
{
  "Telegram": {
    "BotToken": "YOUR_BOT_TOKEN_HERE",
    "ChannelId": "@your_channel_here"
  }
}
```

### 4. Тестирование алертов

Для тестирования алертов используйте специальные параметры:

```bash
# Тест медленного ответа API
curl "http://localhost:6500/api/info?category=slow"

# Тест высокой нагрузки на БД
curl "http://localhost:6500/api/orders?status=slow"
```

## Дашборды Grafana

### 1. API Metrics Dashboard

**ID:** `api-metrics`

**Панели:**

- **RPS** - запросы в секунду
- **Response Time** - время ответа (P50, P95, P99)
- **Error Rate** - процент ошибок
- **Status Codes** - распределение кодов ответа
- **Top Endpoints** - самые популярные эндпоинты

### 2. Database Metrics Dashboard

**ID:** `database-metrics`

**Панели:**

- **Database RPS** - запросы к БД в секунду
- **Query Duration** - время выполнения запросов
- **Connection Pool** - использование пула соединений
- **Slow Queries** - медленные запросы

### 3. System Metrics Dashboard

**ID:** `system-metrics`

**Панели:**

- **CPU Usage** - использование процессора
- **Memory Usage** - использование памяти
- **Disk I/O** - операции ввода/вывода
- **Network Traffic** - сетевой трафик

## Трейсинг с Jaeger

### Просмотр трейсов

1. Откройте http://localhost:16686
2. Выберите сервис "CorporatePortalApi"
3. Установите временной диапазон
4. Нажмите "Find Traces"

### Анализ трейса

Каждый трейс содержит:

- **Spans** - отдельные операции
- **Timing** - время выполнения
- **Tags** - дополнительная информация
- **Logs** - логи операций

### Пример трейса

```
HTTP POST /api/auth/login
├── Database Query (5ms)
│   └── SELECT * FROM Users WHERE Email = ?
└── Response (200 OK)
    └── JSON Serialization (2ms)
```

## Нагрузочное тестирование

### UI интерфейс

1. Откройте http://localhost:8080
2. Установите параметры:
   - **RPS:** 50 (запросов в секунду)
   - **Duration:** 120 (секунд)
3. Нажмите "Запустить тест"

### API интерфейс

```bash
# Запуск теста
curl -X POST http://localhost:8080/api/start \
  -H "Content-Type: application/json" \
  -d '{"rps": 50, "duration": 120}'

# Остановка теста
curl -X POST http://localhost:8080/api/stop

# Получение статуса
curl http://localhost:8080/api/status
```

### Мониторинг во время тестирования

1. **Grafana** - наблюдайте за метриками в реальном времени
2. **Jaeger** - анализируйте трейсы запросов
3. **Telegram** - получайте алерты о проблемах

## Устранение неполадок

### Проблемы с Prometheus

```bash
# Проверка статуса
docker-compose ps prometheus

# Просмотр логов
docker-compose logs prometheus

# Проверка конфигурации
curl http://localhost:9090/-/reload
```

### Проблемы с Grafana

```bash
# Проверка статуса
docker-compose ps grafana

# Просмотр логов
docker-compose logs grafana

# Сброс пароля
docker-compose exec grafana grafana-cli admin reset-admin-password admin
```

### Проблемы с Jaeger

```bash
# Проверка статуса
docker-compose ps jaeger

# Просмотр логов
docker-compose logs jaeger

# Проверка доступности
curl http://localhost:16686/api/services
```

### Проблемы с алертами

1. **Проверьте токен бота:**

```bash
curl "https://api.telegram.org/botYOUR_TOKEN/getMe"
```

2. **Проверьте права бота в канале:**

- Бот должен быть администратором канала
- Бот должен иметь права на отправку сообщений

3. **Проверьте логи API:**

```bash
docker-compose logs corporate-api | grep Telegram
```

## Лучшие практики

### 1. Мониторинг

- Регулярно проверяйте дашборды
- Настройте алерты на критические метрики
- Используйте SLO/SLI для измерения качества сервиса

### 2. Трейсинг

- Добавляйте пользовательские теги в трейсы
- Используйте correlation IDs для связывания запросов
- Анализируйте медленные трейсы

### 3. Алерты

- Не создавайте слишком много алертов
- Используйте разные уровни критичности
- Регулярно тестируйте алерты

### 4. Производительность

- Мониторьте P95 и P99 метрики
- Отслеживайте рост метрик
- Планируйте масштабирование заранее

## Полезные команды

### Prometheus

```bash
# Проверка правил алертов
curl http://localhost:9090/api/v1/rules

# Проверка алертов
curl http://localhost:9090/api/v1/alerts

# Экспорт метрик
curl http://localhost:9090/api/v1/export
```

### Grafana

```bash
# Список дашбордов
curl http://localhost:3000/api/search

# Экспорт дашборда
curl http://localhost:3000/api/dashboards/uid/api-metrics
```

### Jaeger

```bash
# Список сервисов
curl http://localhost:16686/api/services

# Поиск трейсов
curl "http://localhost:16686/api/traces?service=CorporatePortalApi&limit=10"
```

## Дополнительные ресурсы

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Jaeger Documentation](https://www.jaegertracing.io/docs/)
- [OpenTelemetry Documentation](https://opentelemetry.io/docs/)
- [Telegram Bot API](https://core.telegram.org/bots/api)
