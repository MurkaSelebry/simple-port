# Corporate Portal Observability System

This is a comprehensive observability system for the Corporate Portal API with metrics, alerts, and monitoring dashboards.

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose
- Telegram Bot Token (optional, for alerts)

### Environment Variables

Create a `.env` file in the backend directory:

```bash
TELEGRAM_BOT_TOKEN=your_telegram_bot_token_here
TELEGRAM_CHANNEL_ID=@corporate_portal_alerts
```

### Start the System

```bash
cd backend
docker-compose up -d
```

## 📊 Observability Components

### 1. **API Metrics Collection**

- **Location**: `CorporatePortalApi/Services/MetricsService.cs`
- **Middleware**: `CorporatePortalApi/Middleware/MetricsMiddleware.cs`
- **Metrics**: HTTP requests, response times, database queries, errors

### 2. **Prometheus Configuration**

- **Location**: `prometheus.yml`
- **Alert Rules**: `alert_rules.yml`
- **Metrics Endpoint**: `http://localhost:6500/metrics`

### 3. **AlertManager**

- **Configuration**: `alertmanager.yml`
- **Webhook Service**: `alert-webhook/`
- **Telegram Integration**: Sends alerts to `@corporate_portal_alerts`

### 4. **Grafana Dashboards**

- **Location**: `grafana/provisioning/dashboards/corporate-portal-dashboard.json`
- **Datasource**: `grafana/provisioning/datasources/datasource.yml`
- **Dashboard**: Corporate Portal Observability Dashboard

## 🔔 Alert Configuration

### Alert Rules (alert_rules.yml)

1. **High Response Time**: P99 > 500ms for orders endpoint
2. **High Database RPS**: > 100 queries/second
3. **Service Down**: API service unavailable
4. **High Error Rate**: > 5% error rate
5. **Slow Database Queries**: P95 > 1 second

### Telegram Alerts

- **Channel**: [@corporate_portal_alerts](https://t.me/corporate_portal_alerts)
- **Format**: Rich HTML messages with emojis and detailed information
- **Types**: Response time, database RPS, service status, errors

## 📈 Dashboard Metrics

### Available Charts

1. **RPS (Requests Per Second)**: Overall API throughput
2. **Response Time**: P99, P95, P50 percentiles
3. **Database Queries**: Queries per second and duration
4. **Error Rate**: Percentage of failed requests
5. **Errors Per Second**: Absolute error count
6. **RPS by Endpoint**: Breakdown by API endpoint

### Dashboard Access

- **URL**: http://localhost:3000
- **Username**: admin
- **Password**: admin
- **Dashboard**: Corporate Portal Observability Dashboard

## 🧪 Testing Alerts

### 1. Test P99 > 500ms Alert

```bash
# Start load test with orders endpoint
curl -X POST http://localhost:8080/api/start \
  -H "Content-Type: application/json" \
  -d '{"rps": 10, "duration": 60, "endpoint": "/api/orders"}'
```

**Expected Result**: Alerts sent to Telegram when P99 response time exceeds 500ms

### 2. Test Database RPS > 100 Alert

```bash
# Start high-load test
curl -X POST http://localhost:8080/api/start \
  -H "Content-Type: application/json" \
  -d '{"rps": 50, "duration": 30, "endpoint": "/api/orders/statistics"}'
```

**Expected Result**: Alerts sent when database queries exceed 100/second

### 3. Test Service Down Alert

```bash
# Stop the API service
docker-compose stop corporate-api
```

**Expected Result**: Critical alert sent to Telegram

## 🔧 Configuration Files

### Infrastructure as Code (IaC)

- **Prometheus**: `prometheus.yml` + `alert_rules.yml`
- **AlertManager**: `alertmanager.yml`
- **Grafana**: `grafana/provisioning/`
- **Docker**: `docker-compose.yml`

### Key Configuration Locations

- **Alert Rules**: [`alert_rules.yml`](./alert_rules.yml)
- **Dashboard**: [`grafana/provisioning/dashboards/corporate-portal-dashboard.json`](./grafana/provisioning/dashboards/corporate-portal-dashboard.json)
- **Datasource**: [`grafana/provisioning/datasources/datasource.yml`](./grafana/provisioning/datasources/datasource.yml)
- **AlertManager**: [`alertmanager.yml`](./alertmanager.yml)

## 📱 Telegram Channel

**Channel**: [@corporate_portal_alerts](https://t.me/corporate_portal_alerts)

### Alert Types

- 🚨 **Critical**: Service down, critical errors
- ⚠️ **Warning**: High response time, high database RPS
- ℹ️ **Info**: Service status updates

### Alert Format

```
🚨 ALERT: High response time detected

Status: FIRING
Severity: warning
Description: P99 response time for orders endpoint is above 500ms for the last 5 minutes
Time: 2025-07-27 10:30:45
Alert Type: response_time
```

## 🎯 Load Testing

### Load Tester Interface

- **URL**: http://localhost:8080
- **Features**:
  - Select endpoint for testing
  - Configure RPS and duration
  - Real-time statistics
  - Built-in delays for alert testing

### Endpoints Available

- `/api/auth/health` - Health check
- `/api/info` - Info items
- `/api/orders` - Orders (with 600ms delay)
- `/api/orders/statistics` - Order statistics

## 🔍 Monitoring URLs

- **API**: http://localhost:6500
- **Prometheus**: http://localhost:9090
- **AlertManager**: http://localhost:9093
- **Grafana**: http://localhost:3000
- **Jaeger**: http://localhost:16686
- **Load Tester**: http://localhost:8080

## 🛠️ Troubleshooting

### Check Service Status

```bash
docker-compose ps
```

### View Logs

```bash
docker-compose logs corporate-api
docker-compose logs prometheus
docker-compose logs alertmanager
docker-compose logs alert-webhook
```

### Test Metrics Endpoint

```bash
curl http://localhost:6500/metrics
```

### Test Alert Webhook

```bash
curl -X POST http://localhost:8081/health
```

## 📋 Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Load Tester   │    │  Corporate API  │    │   SQL Server    │
│   (Port 8080)   │───▶│   (Port 6500)   │───▶│   (Port 1433)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Prometheus    │    │  AlertManager   │    │  Alert Webhook  │
│   (Port 9090)   │◀───│   (Port 9093)   │───▶│   (Port 8081)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                ▼
┌─────────────────┐    ┌─────────────────┐
│     Grafana     │    │   Telegram      │
│   (Port 3000)   │    │   Channel       │
└─────────────────┘    └─────────────────┘
```

## 🎯 Success Criteria

✅ **Metrics Collection**: .NET metrics with OpenTelemetry  
✅ **Database Monitoring**: SQL Server metrics and query tracking  
✅ **Alert System**: Prometheus + AlertManager + Telegram  
✅ **Dashboards**: Grafana with comprehensive charts  
✅ **Load Testing**: Configurable load tester with endpoint selection  
✅ **Infrastructure as Code**: All configs in version control  
✅ **Telegram Integration**: Rich alerts with detailed information  
✅ **P99 Testing**: Artificial delays to trigger response time alerts  
✅ **Database RPS Testing**: High-load scenarios for database alerts

## 📞 Support

For issues or questions:

1. Check the logs: `docker-compose logs`
2. Verify configuration files
3. Test individual components
4. Check Telegram channel for alerts: [@corporate_portal_alerts](https://t.me/corporate_portal_alerts)
