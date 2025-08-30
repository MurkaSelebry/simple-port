# 🏢 Corporate Portal - Полный Стек

Корпоративный портал с бэкендом на Go, фронтендом на Flutter и полной инфраструктурой Docker.

## 🏗️ Архитектура системы

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│  Flutter App    │    │   Caddy Proxy    │    │   Go Backend    │
│  (Frontend)     │◄──►│ (back.portal.ru) │◄──►│   (API Server)  │
│                 │    │                  │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                ▲                        ▲
                                │                        │
                                ▼                        ▼
                       ┌──────────────────┐    ┌─────────────────┐
                       │   Swagger UI     │    │   PostgreSQL    │
                       │  (Documentation) │    │   (Database)    │
                       └──────────────────┘    └─────────────────┘
```

## 🚀 Быстрый старт

### 1. Запуск бэкенда

```bash
cd main_app_backend/Docker
./start.sh
```

### 2. Запуск фронтенда

```bash
cd main_app
flutter pub get
flutter run
```

## 📁 Структура проекта

```
simple-port/
├── main_app_backend/           # Бэкенд (Go + PostgreSQL + Caddy)
│   ├── GoServer/              # Go приложение
│   │   ├── src/              # Исходный код
│   │   ├── docs/             # Swagger документация
│   │   └── index.go          # Главный файл
│   ├── caddy/                # Конфигурация Caddy
│   │   └── Caddyfile        # Прокси настройки
│   └── Docker/               # Docker конфигурация
│       ├── docker-compose.yml
│       ├── start.sh          # Скрипт запуска
│       └── init-db/          # Инициализация БД
│
├── main_app/                  # Фронтенд (Flutter)
│   ├── lib/
│   │   ├── services/         # API сервисы
│   │   ├── user_category/    # Экраны пользователей
│   │   └── main.dart         # Главный файл
│   └── pubspec.yaml
│
└── README_PORTAL.md          # Этот файл
```

## 🔧 Технологический стек

### Бэкенд

- **Go 1.21** - Основной язык
- **Chi Router** - HTTP роутер
- **GORM** - ORM для работы с БД
- **PostgreSQL 15** - База данных
- **Caddy 2** - Reverse proxy и SSL
- **Swagger** - API документация
- **Docker** - Контейнеризация

### Фронтенд

- **Flutter 3.6+** - Фреймворк UI
- **Dart** - Язык программирования
- **HTTP** - Сетевые запросы
- **SharedPreferences** - Локальное хранилище

## 🌐 Доступные сервисы

После запуска доступны:

| Сервис      | URL                            | Описание             |
| ----------- | ------------------------------ | -------------------- |
| Go API      | http://localhost:3000          | Основной API         |
| Swagger UI  | http://localhost:3000/swagger/ | Документация API     |
| Caddy Proxy | http://localhost               | Прокси сервер        |
| PostgreSQL  | localhost:5432                 | База данных          |
| Flutter App | localhost:\*                   | Мобильное приложение |

### Продакшен URLs

- **API**: https://back.portal.ru
- **Swagger**: https://back.portal.ru/swagger/

## 👥 Тестовые пользователи

| Email             | Пароль      | Роль          |
| ----------------- | ----------- | ------------- |
| admin@portal.ru   | password123 | Администратор |
| emp1@portal.ru    | password123 | Сотрудник     |
| emp2@portal.ru    | password123 | Сотрудник     |
| manager@portal.ru | password123 | Менеджер      |

## 🔌 API Endpoints

### Аутентификация

- `POST /api/auth/register` - Регистрация
- `POST /api/auth/login` - Авторизация
- `GET /api/auth/profile` - Профиль пользователя

### Дополнительные модули

- `/api/orders/*` - Управление заказами
- `/api/packaging/*` - Упаковка товаров
- `/api/catalog/*` - Каталог продукции
- `/api/upload/*` - Загрузка файлов

_Полная документация доступна в Swagger UI_

## 🛠️ Разработка

### Локальная разработка бэкенда

```bash
cd main_app_backend/GoServer
go mod tidy
go run index.go
```

### Локальная разработка фронтенда

```bash
cd main_app
flutter run -d chrome  # Веб версия
flutter run -d android # Android
flutter run -d ios     # iOS (только macOS)
```

### Генерация Swagger документации

```bash
cd main_app_backend/GoServer
swag init -g index.go --output ./docs
```

## 🐳 Docker команды

```bash
# Запуск всех сервисов
cd main_app_backend/Docker
docker-compose up -d

# Продакшен режим
docker-compose -f docker-compose.prod.yml up -d

# Просмотр логов
docker-compose logs -f

# Остановка
docker-compose down

# Полная очистка (включая volumes)
docker-compose down -v
```

## 📊 Мониторинг

### Проверка состояния сервисов

```bash
# Статус контейнеров
docker-compose ps

# Health check API
curl http://localhost:3000/health

# Health check через Caddy
curl http://localhost/health

# Логи конкретного сервиса
docker-compose logs -f goapp
docker-compose logs -f postgres
docker-compose logs -f caddy
```

### Подключение к базе данных

```bash
# Через Docker
docker-compose exec postgres psql -U portal_user -d portal_db

# Локально (если PostgreSQL установлен)
psql -h localhost -U portal_user -d portal_db
```

## 🔒 Безопасность

### Для продакшена обязательно:

1. **Смените пароли в `.env`**:

   ```bash
   cd main_app_backend/Docker
   cp env.example .env
   # Отредактируйте .env с сильными паролями
   ```

2. **Настройте firewall**:

   ```bash
   # Только необходимые порты
   ufw allow 80/tcp
   ufw allow 443/tcp
   ufw deny 5432/tcp  # PostgreSQL только для Docker сети
   ```

3. **SSL сертификаты**: Caddy автоматически получает от Let's Encrypt

4. **JWT Secret**: Используйте криптографически стойкий ключ

## 📦 Деплой

### Деплой бэкенда

```bash
# На сервере
git clone <repository>
cd simple-port/main_app_backend/Docker
cp env.example .env
# Настройте .env
./start.sh production
```

### Деплой фронтенда

```bash
# Веб версия
cd main_app
flutter build web --release
# Деплой папки build/web на хостинг

# Мобильные приложения
flutter build apk --release      # Android
flutter build ios --release      # iOS
```

## 🔧 Конфигурация

### Переменные окружения (.env)

```bash
# Database
POSTGRES_PASSWORD=secure_password_here

# JWT
JWT_SECRET=very_long_random_string_here

# Domain
DOMAIN=back.portal.ru

# Environment
ENVIRONMENT=production
```

### Настройка Caddy

Файл `caddy/Caddyfile` содержит конфигурацию для:

- HTTPS с автоматическими сертификатами
- CORS заголовки для Flutter
- Проксирование API запросов
- Обработка preflight запросов

## 🐛 Troubleshooting

### Частые проблемы

1. **Не запускается PostgreSQL**:

   ```bash
   docker-compose logs postgres
   docker-compose restart postgres
   ```

2. **CORS ошибки во Flutter**:

   - Проверьте настройки в Caddyfile
   - Убедитесь что Caddy запущен

3. **JWT токены не работают**:

   - Проверьте JWT_SECRET в .env
   - Перезапустите Go приложение

4. **Не генерируется Swagger**:
   ```bash
   cd GoServer
   go install github.com/swaggo/swag/cmd/swag@latest
   swag init -g index.go --output ./docs
   ```

### Полная переустановка

```bash
# Остановка и удаление всех данных
cd main_app_backend/Docker
docker-compose down -v
docker system prune -a

# Новый запуск
./start.sh
```

## 📚 Дополнительная документация

- [Бэкенд README](main_app_backend/README.md)
- [Фронтенд README](main_app/README.md)
- [Swagger UI](http://localhost:3000/swagger/) - после запуска
- [API документация](https://back.portal.ru/swagger/) - продакшен

## 🤝 Поддержка

При возникновении проблем:

1. Проверьте логи: `docker-compose logs -f`
2. Убедитесь что все сервисы запущены: `docker-compose ps`
3. Проверьте сетевое подключение
4. Обратитесь к соответствующему README для конкретного компонента

---

**🎉 Готово! Корпоративный портал полностью настроен и готов к использованию.**
