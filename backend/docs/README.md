# Corporate Portal - Документация

## 📚 Содержание

### 🚀 Быстрый старт

- **[Quick Start Guide](QUICK_START.md)** - Быстрый старт и проверка системы

### 📋 Полный отчет

- **[REPORT.md](REPORT.md)** - Подробный отчет по всем пунктам задания

### 🔧 Техническая документация

- **[API Documentation](../backend/README.md)** - Документация API
- **[Monitoring Guide](../backend/README.md)** - Руководство по мониторингу

### 🎯 Специализированные гайды

- **[SQL Metrics & Tracing](../backend/SQL_METRICS_AND_TRACING_GUIDE.md)** - SQL метрики и трейсинг
- **[Tracing & Performance](../backend/TRACING_AND_PERFORMANCE_GUIDE.md)** - Трейсинг и производительность
- **[SQL Tracing Demo](../backend/SQL_TRACING_DEMONSTRATION.md)** - Демонстрация возможностей
- **[Final Summary](../backend/FINAL_SQL_TRACING_SUMMARY.md)** - Итоговое резюме

## 🌐 Доступные сервисы

| Сервис           | URL                                  | Описание                 |
| ---------------- | ------------------------------------ | ------------------------ |
| **API**          | http://localhost:6500                | Основной бизнес-сервис   |
| **Swagger**      | http://localhost:6500/swagger        | API документация         |
| **Load Tester**  | http://localhost:8080                | Нагрузочное тестирование |
| **Grafana**      | http://localhost:3000                | Мониторинг и дашборды    |
| **Jaeger**       | http://localhost:16686               | Трейсинг                 |
| **Prometheus**   | http://localhost:9090                | Метрики                  |
| **AlertManager** | http://localhost:9093                | Алерты                   |
| **Telegram**     | https://t.me/corporate_portal_alerts | Алерты в Telegram        |

## 🎯 Ключевые возможности

### ✅ Реализованные требования

1. **Архитектура** - Микросервисная с Docker Compose
2. **Документация** - Подробная в `/docs`
3. **Бизнес-сервис** - Corporate Portal API
4. **Load Testing** - UI для настройки RPS
5. **База данных** - SQL Server с метриками
6. **Графики** - Корректные метрики в Grafana
7. **Алерты** - Telegram канал с двумя типами
8. **IaC** - Все конфигурации в коде
9. **Swagger** - Полная документация API
10. **Трейсинг** - Jaeger с связью между сервисами
11. **Performance** - Инструменты для дебага

### 🚨 Алерты

#### 1. P99 Response Time > 500ms

**Как воспроизвести**:

```bash
curl -X POST http://localhost:8080/api/start \
  -H "Content-Type: application/json" \
  -d '{"rps": 10, "duration": 60, "endpoint": "/api/orders?status=slow"}'
```

#### 2. SQL Server RPS > 100

**Как воспроизвести**:

```bash
curl -X POST http://localhost:8080/api/start \
  -H "Content-Type: application/json" \
  -d '{"rps": 50, "duration": 120, "endpoint": "/api/orders"}'
```

### 🔍 Трейсинг

**Связь между сервисами**:

1. Запустите load test
2. Откройте Jaeger: http://localhost:16686
3. Найдите трейсы с тегом `sql.server.service`
4. Просмотрите детали HTTP и SQL запросов

### 📊 Мониторинг

**Grafana Dashboard**: http://localhost:3000

- HTTP Request Rate
- Response Time Percentiles
- SQL Server RPS
- SQL Query Duration

## 🚀 Запуск системы

```bash
cd backend
docker-compose up -d
```

## 📝 Структура проекта

```
corporate_portal/
├── backend/                    # Основной бэкенд
│   ├── CorporatePortalApi/    # .NET Core API
│   ├── load-tester/           # Python Flask load tester
│   ├── grafana/               # Grafana конфигурация
│   ├── alert-webhook/         # Telegram webhook
│   └── docker-compose.yml     # Оркестрация
├── frontend/                   # Flutter приложение
└── docs/                      # Документация
    ├── README.md              # Этот файл
    ├── QUICK_START.md         # Быстрый старт
    └── REPORT.md              # Полный отчет
```

## 🔧 Troubleshooting

### Проблемы с запуском

```bash
# Проверка статуса контейнеров
docker ps

# Просмотр логов
docker logs backend-corporate-api-1

# Перезапуск сервисов
docker-compose restart
```

### Проблемы с метриками

```bash
# Проверка метрик API
curl http://localhost:6500/metrics

# Проверка SQL RPS
curl http://localhost:6500/api/sqlmetrics/rps
```

### Проблемы с алертами

```bash
# Проверка Prometheus алертов
curl http://localhost:9090/api/v1/alerts

# Проверка AlertManager
curl http://localhost:9093/api/v1/alerts
```

## 📞 Поддержка

При возникновении проблем:

1. Проверьте логи контейнеров
2. Убедитесь что все порты свободны
3. Проверьте документацию в соответствующих разделах
4. Обратитесь к полному отчету [REPORT.md](REPORT.md)
