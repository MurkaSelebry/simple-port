# Corporate Portal - ASP.NET Core Web API

Корпоративный портал с документооборотом на ASP.NET Core с полным мониторингом, трейсингом и нагрузочным тестированием.

## 🏗️ Архитектура

### Структура проекта

```
CorporatePortal/
├── CorporatePortal.API/          # Основное API приложение
├── CorporatePortal.Services/      # Бизнес-логика
├── CorporatePortal.Data/          # Entity Framework и DbContext
├── CorporatePortal.Models/        # Модели данных
├── CorporatePortal.DTOs/          # Data Transfer Objects
├── CorporatePortal.Infrastructure/# Конфигурация и middleware
├── configs/                       # Конфигурации для мониторинга
├── load-testing/                  # Нагрузочное тестирование
└── docker-compose.yml            # Docker Compose для всех сервисов
```

### Технологический стек

- **Backend**: ASP.NET Core 8.0
- **Database**: SQL Server 2022 (Docker)
- **ORM**: Entity Framework Core (Code First)
- **Monitoring**: Prometheus + Grafana
- **Tracing**: Jaeger
- **Load Testing**: Custom Flask application
- **Alerts**: Telegram Bot

## 🚀 Быстрый старт

### Предварительные требования

- Docker и Docker Compose
- .NET 8.0 SDK
- Python 3.8+ (для нагрузочного тестирования)

### 1. Запуск инфраструктуры

```bash
# Запуск всех сервисов (SQL Server, Prometheus, Grafana, Jaeger)
docker-compose up -d
```

### 2. Настройка базы данных

```bash
# Подключение к SQL Server
docker exec -it corporate-portal-sqlserver /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P YourStrong@Passw0rd \
  -Q "CREATE DATABASE CorporatePortal"
```

### 3. Запуск API

```bash
# Восстановление пакетов
dotnet restore

# Запуск API
cd CorporatePortal.API
dotnet run
```

### 4. Проверка работоспособности

- API: http://localhost:5000
- Swagger: http://localhost:5000/docs
- Grafana: http://localhost:3000 (admin/admin)
- Prometheus: http://localhost:9090
- Jaeger: http://localhost:16686
- Load Testing: http://localhost:8080

## 📊 API Endpoints

### Аутентификация

- `POST /api/users/login` - Вход в систему

### Пользователи

- `GET /api/users` - Получить всех пользователей
- `GET /api/users/{id}` - Получить пользователя по ID
- `POST /api/users` - Создать пользователя

### Заказы

- `GET /api/orders` - Получить все заказы
- `GET /api/orders/{id}` - Получить заказ по ID
- `POST /api/orders` - Создать заказ
- `PUT /api/orders/{id}` - Обновить заказ
- `DELETE /api/orders/{id}` - Удалить заказ
- `GET /api/orders/statistics` - Статистика заказов

### Документы

- `GET /api/documents` - Получить все документы
- `GET /api/documents/{id}` - Получить документ по ID
- `POST /api/documents` - Создать документ
- `PUT /api/documents/{id}` - Обновить документ
- `DELETE /api/documents/{id}` - Удалить документ
- `GET /api/documents/category/{category}` - Документы по категории

### AI Чат

- `POST /api/aichat/ask` - Задать вопрос AI
- `GET /api/aichat/history` - История чата
- `DELETE /api/aichat/history` - Очистить историю

## 🔍 Мониторинг и алерты

### Графики в Grafana

1. **API Response Time (p99)** - Время ответа API на 99-м процентиле
2. **Database RPS** - Запросы в секунду к базе данных
3. **API Requests per Second** - Запросы в секунду к API
4. **Error Rate** - Процент ошибок

### Алерты в Telegram

Система отправляет алерты в Telegram канал при превышении порогов:

1. **Performance Alert**: p99 > 500ms
2. **Database Load Alert**: RPS > 100

**Telegram канал**: [@corporate_portal_alerts](https://t.me/corporate_portal_alerts)

### Воспроизведение алертов

#### Тест производительности (p99 > 500ms):

1. Откройте http://localhost:8080
2. Выберите endpoint: "AI Chat (with delay)"
3. Установите RPS: 50, Duration: 60
4. Нажмите "Start Test"
5. Система автоматически добавит задержку 600ms для запросов с ключевым словом "медленный"

#### Тест нагрузки БД (RPS > 100):

1. Откройте http://localhost:8080
2. Выберите endpoint: "Orders API" или "Users API"
3. Установите RPS: 150, Duration: 60
4. Нажмите "Start Test"

## 🐛 Трейсинг с Jaeger

Система настроена для трейсинга всех HTTP запросов:

- Откройте http://localhost:16686
- Выберите сервис "corporate-portal-api"
- Просматривайте трейсы запросов

## 📈 Нагрузочное тестирование

### Веб-интерфейс

- URL: http://localhost:8080
- Возможности:
  - Настройка RPS (1-1000)
  - Выбор длительности теста (10-3600 сек)
  - Выбор endpoint для тестирования
  - Реальное время мониторинга
  - Автоматические алерты

### Endpoints для тестирования

1. **Health Check** - Базовый endpoint
2. **AI Chat** - Endpoint с искусственной задержкой
3. **Orders API** - API заказов
4. **Users API** - API пользователей

## 🔧 Конфигурация

### Основные настройки (appsettings.json)

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost,1433;Database=CorporatePortal;User Id=sa;Password=YourStrong@Passw0rd;"
  },
  "Telegram": {
    "BotToken": "YOUR_BOT_TOKEN",
    "ChannelId": "@corporate_portal_alerts"
  },
  "Performance": {
    "SlowQueryThresholdMs": 500
  }
}
```

### Prometheus конфигурация

- Файл: `configs/prometheus.yml`
- Сбор метрик каждые 5 секунд
- Алерты настроены для p99 > 500ms и RPS > 100

### Grafana дашборды

- Файл: `configs/grafana/dashboards/corporate-portal-dashboard.json`
- Автоматически импортируется при запуске

## 🐳 Docker Compose сервисы

### SQL Server

- Порт: 1433
- База данных: CorporatePortal
- Пользователь: sa
- Пароль: YourStrong@Passw0rd

### Prometheus

- Порт: 9090
- Конфигурация: configs/prometheus.yml
- Хранение данных: 200 часов

### Grafana

- Порт: 3000
- Логин: admin
- Пароль: admin
- Дашборды: автоматический импорт

### Jaeger

- UI: http://localhost:16686
- Collector: 6831/udp
- Tracing: автоматический сбор трейсов

### Load Testing

- Порт: 8080
- Веб-интерфейс для нагрузочного тестирования
- Интеграция с Telegram алертами

## 📁 Структура файлов IaC

```
configs/
├── prometheus.yml                    # Конфигурация Prometheus
├── grafana/
│   ├── provisioning/
│   │   └── datasources/
│   │       └── prometheus.yml       # Источник данных Grafana
│   └── dashboards/
│       └── corporate-portal-dashboard.json  # Дашборд
└── alerts.yml                       # Правила алертов Prometheus
```

## 🔍 Performance Profiling

### Инструменты для профилирования

1. **dotnet-trace** - для сбора трейсов
2. **dotnet-counters** - для метрик
3. **dotnet-dump** - для анализа дампов

### Пример использования

```bash
# Сбор трейсов
dotnet-trace collect --name corporate-portal

# Просмотр метрик
dotnet-counters monitor --process-id <PID>

# Анализ дампа
dotnet-dump collect --process-id <PID>
```

## 🚨 Алерты и мониторинг

### Настройка Telegram бота

1. Создайте бота через @BotFather
2. Получите токен
3. Добавьте бота в канал @corporate_portal_alerts
4. Обновите токен в appsettings.json

### Типы алертов

1. **Performance Alert**: Время ответа p99 > 500ms
2. **Database Load Alert**: RPS > 100
3. **Error Rate Alert**: Процент ошибок > 5%

### Воспроизведение проблем

- **Медленные запросы**: Используйте AI Chat endpoint с ключевым словом "медленный"
- **Высокая нагрузка**: Установите RPS > 100 в нагрузочном тестировании
- **Ошибки**: Система автоматически отслеживает 5xx ошибки

## 📚 Документация API

Swagger UI доступен по адресу: http://localhost:5000/docs

Включает:

- Все доступные endpoints
- Схемы запросов и ответов
- Интерактивное тестирование API
- Примеры запросов

## 🔗 Полезные ссылки

- **API Documentation**: http://localhost:5000/docs
- **Grafana Dashboard**: http://localhost:3000
- **Prometheus**: http://localhost:9090
- **Jaeger UI**: http://localhost:16686
- **Load Testing**: http://localhost:8080
- **Telegram Alerts**: https://t.me/corporate_portal_alerts

## 🛠️ Разработка

### Добавление новых endpoints

1. Создайте контроллер в `CorporatePortal.API/Controllers/`
2. Добавьте сервис в `CorporatePortal.Services/`
3. Создайте DTOs в `CorporatePortal.DTOs/`
4. Добавьте модели в `CorporatePortal.Models/`

### Добавление метрик

```csharp
// В контроллере
private readonly Counter _requestCounter = Metrics.CreateCounter("api_requests_total", "Total API requests");

// Увеличить счетчик
_requestCounter.Inc();
```

### Добавление трейсинга

```csharp
// Автоматически добавляется OpenTelemetry
// Дополнительные span'ы
using var span = tracer.StartSpan("custom_operation");
```

## 📝 Логи

Логи сохраняются в:

- Консоль (Serilog)
- Файлы: `logs/corporate-portal-YYYY-MM-DD.txt`
- Уровень логирования настраивается в appsettings.json

## 🔒 Безопасность

- Пароли хешируются с помощью BCrypt
- CORS настроен для всех источников (для разработки)
- Валидация входных данных
- Логирование всех операций

## 📞 Поддержка

При возникновении проблем:

1. Проверьте логи в консоли
2. Убедитесь, что все Docker контейнеры запущены
3. Проверьте подключение к базе данных
4. Обратитесь к документации API

---

**Версия**: 1.0.0  
**Дата**: 2024  
**Автор**: Corporate Portal Team
