# Quick Start Guide

## 🚀 Быстрый старт

### 1. Запуск системы

```bash
cd backend
docker-compose up -d
```

### 2. Проверка сервисов

- **API**: http://localhost:6500
- **Load Tester**: http://localhost:8080
- **Grafana**: http://localhost:3000
- **Jaeger**: http://localhost:16686
- **Swagger**: http://localhost:6500/swagger

### 3. Тестирование алертов

#### P99 Response Time > 500ms

```bash
curl -X POST http://localhost:8080/api/start \
  -H "Content-Type: application/json" \
  -d '{"rps": 10, "duration": 60, "endpoint": "/api/orders?status=slow"}'
```

#### SQL Server RPS > 100

```bash
curl -X POST http://localhost:8080/api/start \
  -H "Content-Type: application/json" \
  -d '{"rps": 50, "duration": 120, "endpoint": "/api/orders"}'
```

### 4. Telegram канал

**Ссылка**: https://t.me/corporate_portal_alerts

## 📊 Мониторинг

### Grafana Dashboard

- **URL**: http://localhost:3000
- **Login**: admin/admin
- **Dashboard**: "Corporate Portal Observability Dashboard"

### Метрики

- **HTTP Request Rate** - RPS по endpoint
- **Response Time Percentiles** - P50, P95, P99
- **SQL Server RPS** - запросы в секунду к БД
- **SQL Query Duration** - длительность SQL запросов

## 🔍 Трейсинг

### Jaeger

- **URL**: http://localhost:16686
- **Поиск**: По тегам `sql.server.service` или `load.test.sql.metrics`

### Связь между сервисами

1. Запустите load test
2. Откройте Jaeger
3. Найдите трейсы с тегом `sql.server.service`
4. Просмотрите детали HTTP и SQL запросов

## 🚨 Алерты

### Telegram

- **Канал**: @corporate_portal_alerts
- **Алерты**: P99 > 500ms, SQL RPS > 100

### Воспроизведение

```bash
# Медленные запросы
curl http://localhost:6500/api/orders?status=slow

# Высокая нагрузка
curl -X POST http://localhost:8080/api/start \
  -H "Content-Type: application/json" \
  -d '{"rps": 50, "duration": 60, "endpoint": "/api/orders"}'
```

## 📝 Документация

- **Полный отчет**: [REPORT.md](REPORT.md)
- **API документация**: http://localhost:6500/swagger
- **Мониторинг**: [Monitoring_Guide.md](Monitoring_Guide.md)

## 🔧 Troubleshooting

### Проблемы с метриками

```bash
# Проверка метрик
curl http://localhost:6500/metrics | grep sql

# Проверка SQL RPS
curl http://localhost:6500/api/sqlmetrics/rps
```

### Проблемы с алертами

```bash
# Проверка Prometheus
curl http://localhost:9090/api/v1/alerts

# Проверка AlertManager
curl http://localhost:9093/api/v1/alerts
```

### Перезапуск сервисов

```bash
docker-compose restart corporate-api
docker-compose restart prometheus
docker-compose restart grafana
```

## ✅ Проверка работоспособности

1. **API работает**: `curl http://localhost:6500/api/auth/health`
2. **Load Tester доступен**: http://localhost:8080
3. **Grafana показывает данные**: http://localhost:3000
4. **Jaeger собирает трейсы**: http://localhost:16686
5. **Алерты отправляются**: https://t.me/corporate_portal_alerts
