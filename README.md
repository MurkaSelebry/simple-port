# Corporate Portal - Полноценный Backend с Мониторингом

## 📋 Описание проекта

Этот проект представляет собой корпоративный портал с Flutter frontend и C# backend, включающий полный стек мониторинга, трейсинга и алертов.

## 🏗️ Архитектура

### Frontend (Flutter)

- **Авторизация** - страница входа с валидацией
- **Информация** - раздел с документами, рекламными материалами и прайсами
- **Заказы** - управление заказами с графиками и статистикой
- **AI-ассистент** - чат-бот для помощи сотрудникам

### Backend (C# .NET 9)

- **Entity Framework Core** с Code First подходом
- **SQL Server** в Docker
- **REST API** с Swagger документацией
- **OpenTelemetry** для трейсинга и метрик
- **Health Checks** для мониторинга

### Инфраструктура

- **SQL Server** - база данных
- **Jaeger** - трейсинг запросов
- **Prometheus** - сбор метрик
- **Grafana** - визуализация и дашборды
- **Load Tester** - нагрузочное тестирование с UI

## 🚀 Быстрый старт

### 1. Запуск всей инфраструктуры

```bash
cd backend
docker-compose up -d
```

### 2. Запуск Flutter приложения

```bash
cd frontend
flutter pub get
flutter run
```

## 📊 Мониторинг и Алерты

### Доступные сервисы:

| Сервис      | URL                           | Описание                         |
| ----------- | ----------------------------- | -------------------------------- |
| API         | http://localhost:6500         | Основной API с Swagger           |
| Swagger     | http://localhost:6500/swagger | Документация API                 |
| Load Tester | http://localhost:8080         | UI для нагрузочного тестирования |
| Jaeger      | http://localhost:16686        | Трейсинг запросов                |
| Prometheus  | http://localhost:9090         | Метрики                          |
| Grafana     | http://localhost:3000         | Дашборды (admin/admin)           |
| SQL Server  | localhost:1433                | База данных                      |

### Telegram Алерты

Для настройки Telegram алертов:

1. Создайте бота через @BotFather
2. Добавьте бота в ваш канал
3. Обновите конфигурацию в `backend/CorporatePortalApi/appsettings.json`:

```json
{
  "Telegram": {
    "BotToken": "YOUR_BOT_TOKEN",
    "ChannelId": "@your_channel"
  }
}
```

## 🔧 API Endpoints

### Авторизация

- `POST /api/auth/login` - вход в систему
- `GET /api/auth/health` - проверка здоровья API

### Информация

- `GET /api/info` - получение всех информационных элементов
- `GET /api/info?category=GeneralDocuments` - фильтрация по категории
- `GET /api/info/{id}` - получение конкретного элемента
- `GET /api/info/categories` - список категорий

### Заказы

- `GET /api/orders` - получение всех заказов
- `GET /api/orders?status=InProgress` - фильтрация по статусу
- `GET /api/orders/{id}` - получение конкретного заказа
- `GET /api/orders/statistics` - статистика заказов

## 📈 Метрики и Алерты

### Настроенные алерты:

1. **Высокое время ответа (P99 > 500ms)**

   - Условие: `histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m])) > 0.5`
   - Действие: Отправка в Telegram

2. **Высокая нагрузка на БД (> 100 RPS)**
   - Условие: `rate(sqlserver_requests_total[5m]) > 100`
   - Действие: Отправка в Telegram

### Для тестирования медленных запросов:

Используйте специальные параметры в API:

- `GET /api/info?category=slow` - искусственная задержка 800ms
- `GET /api/orders?status=slow` - искусственная задержка 700ms
- `POST /api/auth/login` с email содержащим "slow" - задержка 600ms

## 🧪 Нагрузочное тестирование

### Через UI:

1. Откройте http://localhost:8080
2. Установите RPS и длительность
3. Нажмите "Запустить тест"

### Через API:

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

## 🔍 Трейсинг

### Просмотр трейсов в Jaeger:

1. Откройте http://localhost:16686
2. Выберите сервис "CorporatePortalApi"
3. Выполните запросы к API
4. Просмотрите трейсы с детальной информацией

### Связанные трейсы:

- Запросы от Flutter приложения
- Запросы от нагрузочного тестера
- Запросы к базе данных
- Внешние HTTP вызовы

## 📊 Grafana Дашборды

### Доступные дашборды:

1. **API Metrics** - метрики API (RPS, время ответа, ошибки)
2. **Database Metrics** - метрики SQL Server
3. **System Metrics** - системные метрики

### Импорт дашбордов:

Дашборды находятся в `backend/grafana/provisioning/dashboards/`

## 🛠️ Разработка

### Структура проекта:

```
corporate_portal/
├── frontend/                 # Flutter приложение
│   ├── lib/
│   │   ├── services/        # API сервисы
│   │   └── user_category/   # UI компоненты
│   └── pubspec.yaml
├── backend/                  # C# API
│   ├── CorporatePortalApi/
│   │   ├── Controllers/     # API контроллеры
│   │   ├── Models/          # Модели данных
│   │   ├── Data/           # DbContext
│   │   └── Program.cs      # Конфигурация
│   ├── load-tester/        # Python нагрузочный тестер
│   ├── docker-compose.yml  # Инфраструктура
│   └── prometheus.yml      # Конфигурация мониторинга
└── README.md
```

### Команды для разработки:

```bash
# Сборка и запуск API
cd backend/CorporatePortalApi
dotnet build
dotnet run

# Миграции базы данных
dotnet ef migrations add InitialCreate
dotnet ef database update

# Запуск Flutter
cd frontend
flutter run
```

## 🔧 Конфигурация

### Переменные окружения:

```bash
# API
ASPNETCORE_ENVIRONMENT=Development
ConnectionStrings__DefaultConnection=Server=sqlserver,1433;Database=CorporatePortal;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=true;

# Jaeger
Jaeger__Host=jaeger
Jaeger__Port=6831

# Telegram
TELEGRAM_BOT_TOKEN=your_bot_token
TELEGRAM_CHANNEL_ID=@your_channel

# Load Tester
API_URL=http://corporate-api:6500
```

## 📝 Логирование

### Уровни логирования:

- **Information** - общие операции
- **Warning** - предупреждения
- **Error** - ошибки с деталями

### Просмотр логов:

```bash
# API логи
docker-compose logs corporate-api

# База данных
docker-compose logs sqlserver

# Нагрузочный тестер
docker-compose logs load-tester
```

## 🚨 Устранение неполадок

### Проблемы с подключением к БД:

1. Убедитесь, что SQL Server запущен: `docker-compose ps`
2. Проверьте логи: `docker-compose logs sqlserver`
3. Проверьте строку подключения в `appsettings.json`

### Проблемы с API:

1. Проверьте логи: `docker-compose logs corporate-api`
2. Проверьте Swagger: http://localhost:6500/swagger
3. Проверьте health check: http://localhost:6500/health

### Проблемы с мониторингом:

1. Проверьте Prometheus: http://localhost:9090
2. Проверьте Jaeger: http://localhost:16686
3. Проверьте Grafana: http://localhost:3000

## 📚 Дополнительные ресурсы

- [Entity Framework Core](https://docs.microsoft.com/en-us/ef/core/)
- [OpenTelemetry](https://opentelemetry.io/)
- [Jaeger](https://www.jaegertracing.io/)
- [Prometheus](https://prometheus.io/)
- [Grafana](https://grafana.com/)
- [Flutter](https://flutter.dev/)

## 🤝 Вклад в проект

1. Fork репозитория
2. Создайте feature branch
3. Внесите изменения
4. Создайте Pull Request

## 📄 Лицензия

MIT License
