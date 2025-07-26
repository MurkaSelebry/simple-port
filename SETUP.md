# Инструкции по настройке Corporate Portal

## 🚀 Быстрый запуск

### 1. Предварительные требования

```bash
# Убедитесь, что у вас установлены:
# - Docker и Docker Compose
# - .NET 8.0 SDK
# - Python 3.8+ (для нагрузочного тестирования)
```

### 2. Запуск инфраструктуры

```bash
# Клонируйте репозиторий (если еще не сделали)
git clone <repository-url>
cd corporate-portal

# Запустите все сервисы
docker-compose up -d

# Проверьте, что все контейнеры запущены
docker-compose ps
```

### 3. Настройка базы данных

```bash
# Подключитесь к SQL Server и создайте базу данных
docker exec -it corporate-portal-sqlserver /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P YourStrong@Passw0rd \
  -Q "CREATE DATABASE CorporatePortal"
```

### 4. Запуск API

```bash
# Восстановите пакеты
dotnet restore

# Запустите API
cd CorporatePortal.API
dotnet run
```

### 5. Проверка работоспособности

Откройте в браузере:

- **API**: http://localhost:5000
- **Swagger**: http://localhost:5000/docs
- **Grafana**: http://localhost:3000 (admin/admin)
- **Prometheus**: http://localhost:9090
- **Jaeger**: http://localhost:16686
- **Load Testing**: http://localhost:8080

## 🔧 Настройка Telegram алертов

### 1. Создание Telegram бота

1. Откройте Telegram и найдите @BotFather
2. Отправьте команду `/newbot`
3. Следуйте инструкциям для создания бота
4. Сохраните полученный токен

### 2. Создание канала для алертов

1. Создайте новый канал в Telegram
2. Добавьте вашего бота в канал как администратора
3. Скопируйте ID канала (начинается с @)

### 3. Настройка конфигурации

Отредактируйте файл `CorporatePortal.API/appsettings.json`:

```json
{
  "Telegram": {
    "BotToken": "YOUR_BOT_TOKEN_HERE",
    "ChannelId": "@your_channel_name"
  }
}
```

## 📊 Тестирование алертов

### Тест производительности (p99 > 500ms)

1. Откройте http://localhost:8080
2. Выберите endpoint: "AI Chat (with delay)"
3. Установите RPS: 50, Duration: 60
4. Нажмите "Start Test"
5. Проверьте Telegram канал на наличие алерта

### Тест нагрузки БД (RPS > 100)

1. Откройте http://localhost:8080
2. Выберите endpoint: "Orders API"
3. Установите RPS: 150, Duration: 60
4. Нажмите "Start Test"
5. Проверьте Telegram канал на наличие алерта

## 🐛 Трейсинг с Jaeger

### Просмотр трейсов

1. Откройте http://localhost:16686
2. Выберите сервис "corporate-portal-api"
3. Нажмите "Find Traces"
4. Просматривайте детали трейсов

### Пример трейса

После выполнения запроса к API вы увидите:

- HTTP запросы
- Время выполнения
- Детали запросов к базе данных

## 📈 Мониторинг в Grafana

### Настройка дашборда

1. Откройте http://localhost:3000
2. Войдите с логином admin/admin
3. Дашборд "Corporate Portal Dashboard" должен быть доступен автоматически

### Метрики

- **API Response Time (p99)**: Время ответа на 99-м процентиле
- **Database RPS**: Запросы в секунду к базе данных
- **API Requests per Second**: Запросы в секунду к API
- **Error Rate**: Процент ошибок

## 🔍 Performance Profiling

### Использование dotnet-trace

```bash
# Сбор трейсов
dotnet-trace collect --name corporate-portal

# Анализ трейсов
dotnet-trace view corporate-portal.nettrace
```

### Использование dotnet-counters

```bash
# Мониторинг метрик в реальном времени
dotnet-counters monitor --process-id <PID>
```

### Использование dotnet-dump

```bash
# Сбор дампа процесса
dotnet-dump collect --process-id <PID>

# Анализ дампа
dotnet-dump analyze corporate-portal.dmp
```

## 🧪 Нагрузочное тестирование

### Веб-интерфейс

- URL: http://localhost:8080
- Настройка RPS, длительности и endpoint
- Реальное время мониторинга
- Автоматические алерты

### PowerShell скрипт

```powershell
# Запуск теста
.\Scripts\load-test.ps1 -RPS 50 -Duration 60 -Endpoint "ai-chat"

# Параметры:
# -RPS: Запросы в секунду (1-1000)
# -Duration: Длительность в секундах (10-3600)
# -Endpoint: health, ai-chat, orders, users
# -BaseUrl: URL API (по умолчанию http://localhost:5000)
```

## 🔧 Устранение неполадок

### Проблемы с Docker

```bash
# Проверка логов контейнеров
docker-compose logs

# Перезапуск сервисов
docker-compose restart

# Очистка и пересоздание
docker-compose down -v
docker-compose up -d
```

### Проблемы с API

```bash
# Проверка подключения к БД
dotnet ef database update

# Очистка и пересборка
dotnet clean
dotnet build
```

### Проблемы с мониторингом

1. Проверьте, что Prometheus собирает метрики: http://localhost:9090/targets
2. Убедитесь, что Grafana подключен к Prometheus
3. Проверьте конфигурацию дашбордов

## 📚 Полезные команды

### Docker

```bash
# Просмотр логов
docker-compose logs -f

# Остановка всех сервисов
docker-compose down

# Пересборка образов
docker-compose build --no-cache
```

### .NET

```bash
# Восстановление пакетов
dotnet restore

# Сборка проекта
dotnet build

# Запуск в режиме разработки
dotnet run --environment Development

# Создание миграции
dotnet ef migrations add InitialCreate
```

### База данных

```bash
# Подключение к SQL Server
docker exec -it corporate-portal-sqlserver /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P YourStrong@Passw0rd

# Создание базы данных
CREATE DATABASE CorporatePortal;
GO
```

## 🔗 Полезные ссылки

- **API Documentation**: http://localhost:5000/docs
- **Grafana Dashboard**: http://localhost:3000
- **Prometheus**: http://localhost:9090
- **Jaeger UI**: http://localhost:16686
- **Load Testing**: http://localhost:8080
- **Telegram Alerts**: https://t.me/corporate_portal_alerts

## 📞 Поддержка

При возникновении проблем:

1. Проверьте логи в консоли
2. Убедитесь, что все Docker контейнеры запущены
3. Проверьте подключение к базе данных
4. Обратитесь к документации API
5. Проверьте конфигурацию в appsettings.json
