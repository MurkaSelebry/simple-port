# Документация для проверяющего

## Обзор проекта

Создан полноценный backend для корпоративного портала на C# с интеграцией Flutter frontend. Проект включает все требуемые компоненты:

### ✅ Выполненные требования:

1. **README и документация** - `/docs` доступна через Swagger UI
2. **Сервис с бизнес-логикой** - API для заказов, документов, чата
3. **Нагрузочный сервис** - CLI инструмент с настройкой RPS
4. **База данных** - SQL Server с Entity Framework Code First
5. **Графики и алерты** - Prometheus + Grafana + Telegram
6. **IAC** - Все конфиги в коде
7. **Swagger** - Полная API документация
8. **Трейсинг** - Jaeger для отслеживания запросов
9. **Performance инструменты** - Профилирование и отладка

## Быстрый старт

### 1. Запуск проекта

```bash
cd backend
docker-compose up -d
```

### 2. Проверка сервисов

- **API**: http://localhost:5000
- **Swagger**: http://localhost:5000/swagger
- **Grafana**: http://localhost:3000 (admin/admin)
- **Prometheus**: http://localhost:9090
- **Jaeger**: http://localhost:16686

### 3. Тестирование API

```bash
# Вход в систему
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"nickname":"employee","email":"employee@corporate.com","password":"employee123"}'

# Получение заказов
curl http://localhost:5000/api/orders

# Отправка сообщения в чат
curl -X POST http://localhost:5000/api/chat/send \
  -H "Content-Type: application/json" \
  -d '{"query":"привет"}'
```

## Тестирование алертов

### 1. Тест алерта p99 > 500ms

```bash
# Запуск медленного запроса
curl http://localhost:5000/api/orders/slow-query

# Нагрузочное тестирование
cd Scripts
./load-test.sh --rps 50 --duration 60
```

### 2. Тест алерта БД RPS > 100

```bash
# Создание нагрузки на БД
curl -X POST http://localhost:5000/api/orders/bulk-create \
  -H "Content-Type: application/json" \
  -d '1000'
```

## Telegram канал для алертов

**Канал**: https://t.me/corporate_portal_alerts

Для настройки:

1. Создайте бота через @BotFather
2. Получите токен бота
3. Добавьте бота в канал
4. Получите ID канала
5. Обновите переменные в docker-compose.yml

## Мониторинг и метрики

### Grafana дашборды

1. **API Performance Dashboard**

   - Время ответа (p50, p95, p99)
   - Количество запросов в секунду
   - Ошибки (4xx, 5xx)

2. **Database Metrics**
   - Активные соединения
   - Время выполнения запросов
   - RPS к БД

### Prometheus метрики

- `http_requests_total` - Общее количество запросов
- `http_request_duration_seconds` - Время выполнения запросов
- `sqlserver_connections` - Соединения с БД

## Performance инструменты

### 1. Воспроизведение проблемы

```bash
# Медленный запрос (600ms)
curl http://localhost:5000/api/orders/slow-query
```

### 2. Анализ в Jaeger

1. Откройте http://localhost:16686
2. Найдите медленные запросы
3. Анализируйте трейсы

### 3. Исправление проблемы

Код с искусственной задержкой находится в `OrdersController.SlowQuery()`:

```csharp
await Task.Delay(600); // 600ms для p99 > 500ms
```

## Структура проекта

```
backend/
├── CorporatePortal.API/          # Основное API приложение
│   ├── Controllers/              # API контроллеры
│   ├── Models/                   # Entity Framework модели
│   ├── Services/                 # Бизнес логика
│   ├── Data/                    # DbContext
│   ├── DTOs/                    # Data Transfer Objects
│   └── Infrastructure/          # Middleware
├── Scripts/
│   └── LoadTest/                # Нагрузочное тестирование
├── Configs/                     # Конфиги мониторинга
│   ├── grafana/                 # Grafana дашборды
│   └── prometheus/              # Prometheus конфигурация
└── docker-compose.yml           # Docker конфигурация
```

## API Endpoints

### Аутентификация

- `POST /api/auth/login` - Вход в систему
- `POST /api/auth/refresh` - Обновление токена

### Заказы

- `GET /api/orders` - Список заказов
- `GET /api/orders/{id}` - Получить заказ
- `POST /api/orders` - Создать заказ
- `PUT /api/orders/{id}` - Обновить заказ
- `DELETE /api/orders/{id}` - Удалить заказ
- `GET /api/orders/export/csv` - Экспорт в CSV
- `GET /api/orders/slow-query` - Медленный запрос (тест)
- `POST /api/orders/bulk-create` - Массовое создание (тест)

### Чат

- `POST /api/chat/send` - Отправить сообщение
- `GET /api/chat/history` - История сообщений

## Интеграция с Flutter

Frontend обновлен для работы с C# backend:

```dart
final String _apiUrl = "http://localhost:5000/api/chat/send";
```

## Логи и отладка

### Просмотр логов

```bash
# API логи
docker-compose logs api

# База данных
docker-compose logs sqlserver

# Prometheus
docker-compose logs prometheus

# Grafana
docker-compose logs grafana
```

### Health checks

```bash
# API health
curl http://localhost:5000/health

# Prometheus metrics
curl http://localhost:5000/metrics
```

## Troubleshooting

### Частые проблемы

1. **Ошибка подключения к БД**

   ```bash
   docker-compose restart sqlserver
   ```

2. **Алерты не отправляются**

   - Проверьте токен Telegram бота
   - Проверьте ID чата
   - Проверьте логи сервиса

3. **Метрики не отображаются**
   - Проверьте Prometheus: http://localhost:9090
   - Проверьте Grafana: http://localhost:3000

### Восстановление

```bash
# Полная перезагрузка
docker-compose down
docker-compose up -d

# Применение миграций
docker-compose exec api dotnet ef database update
```

## Контакты

Для вопросов и поддержки обращайтесь к команде разработки.

---

**Версия**: 1.0.0  
**Дата**: 2024  
**Статус**: Готово к проверке
