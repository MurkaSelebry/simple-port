# Corporate Portal Backend

Корпоративный портал на Go с Caddy, PostgreSQL и Swagger документацией.

## Структура проекта

```
main_app_backend/
├── GoServer/                 # Go приложение
│   ├── src/                 # Исходный код
│   │   ├── controllers/     # Контроллеры API
│   │   ├── models/         # Модели данных
│   │   ├── routes/         # Маршруты
│   │   ├── middlewares/    # Middleware
│   │   └── utils/          # Утилиты
│   ├── docs/               # Swagger документация
│   ├── go.mod              # Go модули
│   └── index.go            # Главный файл
├── caddy/                  # Конфигурация Caddy
│   └── Caddyfile          # Конфигурация прокси
└── Docker/                 # Docker конфигурация
    ├── docker-compose.yml # Development
    ├── docker-compose.prod.yml # Production
    ├── Dockerfile         # Сборка Go приложения
    ├── init-db/          # Скрипты инициализации БД
    └── env.example       # Пример переменных окружения
```

## Быстрый старт

### 1. Клонирование и подготовка

```bash
cd main_app_backend/Docker
cp env.example .env
# Отредактируйте .env файл с вашими настройками
```

### 2. Запуск в режиме разработки

```bash
cd main_app_backend/Docker
docker-compose up -d
```

### 3. Запуск в продакшен режиме

```bash
cd main_app_backend/Docker
docker-compose -f docker-compose.prod.yml up -d
```

## Доступные сервисы

После запуска Docker Compose доступны следующие сервисы:

- **API Backend**: http://localhost:3000
- **Swagger UI**: http://localhost:3000/swagger/
- **Database**: localhost:5432
- **Caddy Proxy**:
  - Development: http://localhost
  - Production: https://back.portal.ru

## API Endpoints

### Аутентификация

- `POST /api/auth/register` - Регистрация пользователя
- `POST /api/auth/login` - Авторизация пользователя
- `GET /api/auth/profile` - Получение профиля (требует авторизации)

### Swagger документация

- `GET /swagger/` - Swagger UI
- `GET /swagger/doc.json` - Swagger JSON спецификация

## Настройка окружения

### Переменные окружения

```bash
# Database
POSTGRES_HOST=postgres
POSTGRES_USER=portal_user
POSTGRES_PASSWORD=your_password
POSTGRES_DATABASE=portal_db
POSTGRES_PORT=5432

# JWT
JWT_SECRET=your_jwt_secret

# Caddy
DOMAIN=back.portal.ru
```

### Тестовые пользователи

После инициализации БД доступны тестовые аккаунты:

- **admin@portal.ru** / password123
- **emp1@portal.ru** / password123
- **emp2@portal.ru** / password123
- **manager@portal.ru** / password123

## Разработка

### Локальная разработка Go приложения

```bash
cd GoServer
go mod tidy
go run index.go
```

### Генерация Swagger документации

```bash
cd GoServer
swag init -g index.go --output ./docs
```

### Управление базой данных

```bash
# Просмотр логов PostgreSQL
docker-compose logs postgres

# Подключение к базе данных
docker-compose exec postgres psql -U portal_user -d portal_db

# Сброс базы данных
docker-compose down -v
docker-compose up -d
```

## Мониторинг и логи

### Просмотр логов

```bash
# Все сервисы
docker-compose logs -f

# Конкретный сервис
docker-compose logs -f goapp
docker-compose logs -f postgres
docker-compose logs -f caddy
```

### Проверка состояния сервисов

```bash
# Статус контейнеров
docker-compose ps

# Проверка health-check
docker-compose exec goapp curl http://localhost:3000/health
```

## Продакшен

### SSL сертификаты

Caddy автоматически получает SSL сертификаты от Let's Encrypt для домена `back.portal.ru`.

### Безопасность

1. Измените все пароли и секретные ключи в `.env`
2. Настройте firewall для портов 80, 443, 5432
3. Регулярно обновляйте Docker образы
4. Настройте бэкапы PostgreSQL

### Бэкапы

```bash
# Создание бэкапа БД
docker-compose exec postgres pg_dump -U portal_user portal_db > backup_$(date +%Y%m%d_%H%M%S).sql

# Восстановление из бэкапа
docker-compose exec -T postgres psql -U portal_user portal_db < backup.sql
```

## Troubleshooting

### Проблемы с подключением к БД

```bash
# Проверить, что PostgreSQL запущен
docker-compose ps postgres

# Проверить логи PostgreSQL
docker-compose logs postgres

# Пересоздать контейнеры
docker-compose down
docker-compose up -d
```

### Проблемы с Caddy

```bash
# Проверить конфигурацию Caddy
docker-compose exec caddy caddy validate --config /etc/caddy/Caddyfile

# Перезагрузить Caddy
docker-compose restart caddy
```

### Проблемы с Go приложением

```bash
# Проверить логи приложения
docker-compose logs goapp

# Пересобрать Go приложение
docker-compose build goapp
docker-compose up -d goapp
```
