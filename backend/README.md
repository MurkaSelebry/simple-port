# Корпоративный портал - Backend

## Описание проекта

Backend для корпоративного портала с документооборотом, построенный на ASP.NET Core Web API с использованием Entity Framework Code First и SQL Server.

## Архитектура

```
backend/
├── Controllers/          # API контроллеры
├── Models/              # Entity Framework модели
├── Services/            # Бизнес логика
├── Data/               # DbContext и миграции
├── DTOs/               # Data Transfer Objects
├── Infrastructure/     # Конфигурация, middleware
├── docker-compose.yml  # Docker конфигурация (инфраструктура)
├── Configs/           # Конфиги для Grafana, Prometheus
└── Scripts/           # Скрипты для нагрузочного тестирования
```

## Технологический стек

- **ASP.NET Core 8.0** - Web API framework
- **Entity Framework Core** - ORM для работы с БД
- **SQL Server** - База данных (Docker)
- **JWT** - Аутентификация
- **AutoMapper** - Маппинг объектов
- **FluentValidation** - Валидация данных
- **Swagger/OpenAPI** - API документация
- **Prometheus** - Метрики
- **Grafana** - Визуализация метрик
- **Jaeger** - Трейсинг
- **Telegram Bot** - Алерты

## Быстрый старт

### Предварительные требования

- Docker и Docker Compose (для инфраструктуры)
- .NET 8.0 SDK (для сборки приложения)
- Git

### Запуск проекта

1. **Запуск инфраструктуры (Docker)**

```bash
cd backend
docker-compose up -d
```

2. **Сборка и запуск API приложения (локально)**

```bash
cd CorporatePortal.API
dotnet restore
dotnet build
dotnet ef database update
dotnet run
```

3. **Доступ к сервисам**

- API: http://localhost:5000
- Swagger: http://localhost:5000/swagger
- Grafana: http://localhost:3000 (admin/admin)
- Prometheus: http://localhost:9090
- Jaeger: http://localhost:16686

## API Endpoints

### Аутентификация

- `POST /api/auth/login` - Вход в систему
- `POST /api/auth/register` - Регистрация
- `POST /api/auth/refresh` - Обновление токена

### Пользователи

- `GET /api/users` - Список пользователей (Admin)
- `GET /api/users/{id}` - Получить пользователя
- `PUT /api/users/{id}` - Обновить пользователя
- `DELETE /api/users/{id}` - Удалить пользователя

### Документы

- `GET /api/documents` - Список документов
- `GET /api/documents/{id}` - Получить документ
- `POST /api/documents` - Создать документ
- `PUT /api/documents/{id}` - Обновить документ
- `DELETE /api/documents/{id}` - Удалить документ
- `POST /api/documents/{id}/upload` - Загрузить файл
- `GET /api/documents/{id}/download` - Скачать файл

### Заказы

- `GET /api/orders` - Список заказов
- `GET /api/orders/{id}` - Получить заказ
- `POST /api/orders` - Создать заказ
- `PUT /api/orders/{id}` - Обновить заказ
- `DELETE /api/orders/{id}` - Удалить заказ
- `GET /api/orders/export/csv` - Экспорт в CSV

### Чат (AI Assistant)

- `POST /api/chat/send` - Отправить сообщение
- `GET /api/chat/history` - История сообщений

## Мониторинг и алерты

### Графики и метрики

Доступны в Grafana по адресу: http://localhost:3000

**Основные дашборды:**

- API Performance - время ответа, количество запросов
- Database Metrics - метрики БД
- System Metrics - CPU, Memory, Disk

### Алерты в Telegram

**Канал для алертов:** https://t.me/corporate_portal_alerts

**Условия срабатывания:**

1. p99 latency > 500ms на любом API endpoint
2. RPS к БД > 100

### Воспроизведение нагрузки для тестирования алертов

1. **Для тестирования алерта p99 > 500ms:**

```bash
# Запустить нагрузочное тестирование
cd Scripts
./load-test.sh --rps 50 --duration 60
```

2. **Для тестирования алерта БД RPS > 100:**

```bash
# Создать искусственную нагрузку на БД
curl -X POST http://localhost:5000/api/orders/bulk-create \
  -H "Content-Type: application/json" \
  -d '{"count": 1000}'
```

## Нагрузочное тестирование

### Командная строка

```bash
# Базовое тестирование
dotnet run --project Scripts/LoadTest -- --rps 10 --duration 30

# Стресс-тест
dotnet run --project Scripts/LoadTest -- --rps 100 --duration 300
```

## Performance инструменты

### Профилирование

1. **Воспроизведение проблемы с производительностью:**

```bash
# Создать искусственную задержку
curl -X GET http://localhost:5000/api/orders/slow-query
```

2. **Использование профайлера:**

- Откройте Jaeger: http://localhost:16686
- Найдите медленные запросы
- Анализируйте трейсы

3. **Исправление проблемы:**

- Найдите проблемную строку кода
- Оптимизируйте запрос
- Пересоберите и протестируйте

## База данных

### Структура БД

**Основные таблицы:**

- `Users` - Пользователи системы
- `Documents` - Документы
- `Orders` - Заказы
- `DocumentCategories` - Категории документов
- `ChatMessages` - Сообщения чата

### Миграции

```bash
# Создать миграцию
dotnet ef migrations add MigrationName

# Применить миграции
dotnet ef database update

# Откатить миграцию
dotnet ef database update PreviousMigrationName
```

## Развертывание

### Docker Compose (только инфраструктура)

```bash
# Запуск инфраструктуры
docker-compose up -d

# Просмотр логов
docker-compose logs -f

# Остановка
docker-compose down
```

### Переменные окружения

Создайте файл `appsettings.Development.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost,1433;Database=CorporatePortal;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=true"
  },
  "JWT": {
    "Secret": "your-super-secret-jwt-key-here-make-it-long-and-secure",
    "Issuer": "CorporatePortal",
    "Audience": "CorporatePortal",
    "ExpiryInHours": 24
  },
  "Telegram": {
    "BotToken": "your-telegram-bot-token",
    "ChatId": "your-chat-id"
  }
}
```

## Разработка

### Структура проекта

```
backend/
├── Controllers/
│   ├── AuthController.cs
│   ├── UsersController.cs
│   ├── DocumentsController.cs
│   ├── OrdersController.cs
│   └── ChatController.cs
├── Models/
│   ├── User.cs
│   ├── Document.cs
│   ├── Order.cs
│   ├── DocumentCategory.cs
│   └── ChatMessage.cs
├── Services/
│   ├── IAuthService.cs
│   ├── AuthService.cs
│   ├── IUserService.cs
│   ├── UserService.cs
│   ├── IDocumentService.cs
│   ├── DocumentService.cs
│   ├── IOrderService.cs
│   ├── OrderService.cs
│   ├── IChatService.cs
│   ├── ChatService.cs
│   ├── IAlertService.cs
│   ├── AlertService.cs
│   └── IPerformanceService.cs
│   └── PerformanceService.cs
├── Data/
│   ├── ApplicationDbContext.cs
│   └── Migrations/
├── DTOs/
│   ├── Auth/
│   ├── Users/
│   ├── Documents/
│   ├── Orders/
│   └── Chat/
├── Infrastructure/
│   ├── Middleware/
│   ├── Extensions/
│   ├── Filters/
│   └── Configuration/
├── Configs/
│   ├── grafana/
│   ├── prometheus/
│   └── jaeger/
└── Scripts/
    ├── LoadTest/
    └── load-test.sh
```

### Добавление новых endpoints

1. Создайте контроллер в `Controllers/`
2. Добавьте сервис в `Services/`
3. Создайте DTOs в `DTOs/`
4. Добавьте валидацию
5. Обновите Swagger документацию

### Тестирование

```bash
# Запуск тестов
dotnet test

# Покрытие кода
dotnet test --collect:"XPlat Code Coverage"
```

## Troubleshooting

### Частые проблемы

1. **Ошибка подключения к БД:**

   - Проверьте, что SQL Server запущен: `docker-compose ps`
   - Проверьте строку подключения
   - Убедитесь, что миграции применены: `dotnet ef database update`

2. **Алерты не отправляются:**

   - Проверьте токен Telegram бота
   - Проверьте ID чата
   - Проверьте логи сервиса

3. **Метрики не отображаются:**
   - Проверьте, что Prometheus запущен
   - Проверьте конфигурацию метрик
   - Проверьте подключение к Grafana

### Логи

```bash
# Инфраструктура
docker-compose logs sqlserver
docker-compose logs prometheus
docker-compose logs grafana

# API логи (локальное приложение)
# Логи отображаются в консоли при запуске dotnet run
```

## Контакты

Для вопросов и поддержки обращайтесь к команде разработки.

---

**Версия:** 1.0.0  
**Дата:** 2024  
**Автор:** Development Team
