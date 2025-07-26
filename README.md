# Корпоративный портал

Полноценное решение корпоративного портала с Flutter frontend и C# backend.

## 🚀 Быстрый старт

### Предварительные требования

- Docker и Docker Compose (для инфраструктуры)
- .NET 8.0 SDK (для backend)
- Flutter SDK (для frontend)

### Запуск проекта

1. **Клонирование репозитория**

```bash
git clone <repository-url>
cd corporate_portal
```

2. **Запуск инфраструктуры (Docker)**

```bash
cd backend
docker-compose up -d
```

3. **Сборка и запуск backend**

```bash
cd backend/CorporatePortal.API
dotnet restore
dotnet build
dotnet ef database update
dotnet run
```

4. **Запуск frontend**

```bash
cd frontend
flutter pub get
flutter run -d chrome
```

5. **Проверка сервисов**

- Frontend: http://localhost:3000
- API: http://localhost:5000
- Swagger: http://localhost:5000/swagger
- Grafana: http://localhost:3000 (admin/admin)
- Prometheus: http://localhost:9090
- Jaeger: http://localhost:16686

## 📋 Выполненные требования

### ✅ 1. README и документация

- Подробная документация в `/docs` (Swagger UI)
- Инструкции по запуску и тестированию
- Архитектурная документация

### ✅ 2. Сервис с бизнес-логикой

- ASP.NET Core Web API
- Entity Framework Code First
- SQL Server база данных
- JWT аутентификация
- CRUD операции для заказов
- AI-ассистент чат

### ✅ 3. Нагрузочный сервис

- CLI инструмент с настройкой RPS
- Real-time отображение результатов
- Статистика производительности
- Скрипт для автоматизации

### ✅ 4. База данных

- SQL Server в Docker
- Entity Framework Code First
- Миграции и seed данные
- Оптимизированные индексы

### ✅ 5. Графики и алерты

- Prometheus для сбора метрик
- Grafana для визуализации
- Telegram алерты
- Настраиваемые пороги

### ✅ 6. IAC (Infrastructure as Code)

- Docker Compose конфигурация
- Grafana дашборды в JSON
- Prometheus конфигурация
- Все конфиги в коде

### ✅ 7. Swagger документация

- Полная API документация
- Интерактивное тестирование
- JWT авторизация в UI
- Примеры запросов

### ✅ 8. Трейсинг

- Jaeger для распределенного трейсинга
- OpenTelemetry интеграция
- Отслеживание запросов между сервисами
- Анализ производительности

### ✅ 9. Performance инструменты

- Профилирование кода
- Искусственные проблемы для демонстрации
- Инструкции по отладке
- Метрики производительности

## 🔧 Тестирование

### Тестирование API

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

### Тестирование алертов

```bash
# Тест p99 > 500ms
curl http://localhost:5000/api/orders/slow-query

# Нагрузочное тестирование
cd backend/Scripts
./load-test.sh --rps 50 --duration 60

# Тест БД RPS > 100
curl -X POST http://localhost:5000/api/orders/bulk-create \
  -H "Content-Type: application/json" \
  -d '1000'
```

## 📊 Мониторинг

### Grafana дашборды

- API Performance - время ответа, RPS, ошибки
- Database Metrics - соединения, запросы
- System Metrics - CPU, Memory, Disk

### Telegram алерты

- Канал: https://t.me/corporate_portal_alerts
- Алерты при p99 > 500ms
- Алерты при БД RPS > 100

## 🏗️ Архитектура

```
corporate_portal/
├── frontend/                    # Flutter приложение
│   ├── lib/
│   │   ├── user_category/      # Пользовательские категории
│   │   │   ├── admin/          # Админ панель
│   │   │   └── employee/       # Сотрудник панель
│   │   └── main.dart           # Главный файл
│   └── pubspec.yaml
├── backend/                     # C# API
│   ├── CorporatePortal.API/    # Основное приложение
│   ├── Scripts/                # Нагрузочное тестирование
│   ├── Configs/                # Конфиги мониторинга
│   └── docker-compose.yml      # Docker конфигурация (инфраструктура)
└── README.md                   # Документация
```

## 🔍 Performance инструменты

### Воспроизведение проблем

1. **Медленный запрос**

```bash
curl http://localhost:5000/api/orders/slow-query
```

2. **Анализ в Jaeger**

- Откройте http://localhost:16686
- Найдите медленные запросы
- Анализируйте трейсы

3. **Исправление**

- Найдите проблемную строку кода
- Оптимизируйте запрос
- Пересоберите и протестируйте

## 🛠️ Разработка

### Добавление новых endpoints

1. Создайте контроллер в `backend/CorporatePortal.API/Controllers/`
2. Добавьте сервис в `backend/CorporatePortal.API/Services/`
3. Создайте DTOs в `backend/CorporatePortal.API/DTOs/`
4. Обновите Swagger документацию

### Тестирование

```bash
# Backend тесты
cd backend/CorporatePortal.API
dotnet test

# Frontend тесты
cd frontend
flutter test
```

## 📚 Документация

- [Backend документация](backend/README.md)
- [API документация](http://localhost:5000/swagger)
- [Документация для проверяющего](backend/DOCUMENTATION.md)

## 🐛 Troubleshooting

### Частые проблемы

1. **Ошибка подключения к БД**

```bash
docker-compose restart sqlserver
dotnet ef database update
```

2. **Алерты не отправляются**

- Проверьте токен Telegram бота
- Проверьте ID чата
- Проверьте логи сервиса

3. **Метрики не отображаются**

- Проверьте Prometheus: http://localhost:9090
- Проверьте Grafana: http://localhost:3000

### Логи

```bash
# Инфраструктура
docker-compose logs sqlserver
docker-compose logs prometheus
docker-compose logs grafana

# API логи (локальное приложение)
# Логи отображаются в консоли при запуске dotnet run
```

## 📞 Контакты

Для вопросов и поддержки обращайтесь к команде разработки.

---

**Версия**: 1.0.0  
**Дата**: 2024  
**Статус**: Готово к проверке
