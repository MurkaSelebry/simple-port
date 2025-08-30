#!/bin/bash

# Script для запуска корпоративного портала

set -e

echo "🚀 Запуск корпоративного портала..."

# Проверяем, что мы в правильной директории
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Ошибка: docker-compose.yml не найден"
    echo "Запустите скрипт из директории main_app_backend/Docker/"
    exit 1
fi

# Проверяем наличие .env файла
if [ ! -f ".env" ]; then
    echo "⚠️  Файл .env не найден, создаем из примера..."
    cp env.example .env
    echo "✅ Создан файл .env из примера"
    echo "📝 Отредактируйте .env файл с вашими настройками перед продакшеном"
fi

# Получаем режим запуска (development или production)
MODE=${1:-development}

if [ "$MODE" = "production" ] || [ "$MODE" = "prod" ]; then
    echo "🔥 Запуск в продакшен режиме..."
    COMPOSE_FILE="docker-compose.prod.yml"
    
    # Проверяем критические переменные для продакшена
    source .env
    if [ "$JWT_SECRET" = "your_super_secret_jwt_key_production_change_me_to_random_string" ]; then
        echo "❌ ОШИБКА: Измените JWT_SECRET в .env файле перед запуском в продакшене!"
        exit 1
    fi
    
    if [ "$POSTGRES_PASSWORD" = "portal_strong_password_123" ]; then
        echo "⚠️  ПРЕДУПРЕЖДЕНИЕ: Рекомендуется изменить POSTGRES_PASSWORD в .env файле"
    fi
else
    echo "🛠️  Запуск в режиме разработки..."
    COMPOSE_FILE="docker-compose.yml"
fi

# Останавливаем существующие контейнеры
echo "🛑 Остановка существующих контейнеров..."
docker-compose -f $COMPOSE_FILE down

# Собираем и запускаем сервисы
echo "🔨 Сборка и запуск сервисов..."
docker-compose -f $COMPOSE_FILE up -d --build

# Ждем запуска сервисов
echo "⏳ Ожидание запуска сервисов..."
sleep 10

# Проверяем статус сервисов
echo "📊 Статус сервисов:"
docker-compose -f $COMPOSE_FILE ps

# Проверяем health-check
echo "🏥 Проверка состояния сервисов..."

# Ждем готовности PostgreSQL
echo "⏳ Ожидание готовности PostgreSQL..."
timeout=60
while [ $timeout -gt 0 ]; do
    if docker-compose -f $COMPOSE_FILE exec -T postgres pg_isready -U portal_user -d portal_db >/dev/null 2>&1; then
        echo "✅ PostgreSQL готов"
        break
    fi
    sleep 2
    timeout=$((timeout-2))
done

if [ $timeout -le 0 ]; then
    echo "❌ PostgreSQL не готов после 60 секунд"
    docker-compose -f $COMPOSE_FILE logs postgres
    exit 1
fi

# Проверяем Go приложение
echo "⏳ Проверка Go приложения..."
sleep 5
if curl -f http://localhost:3000/health >/dev/null 2>&1; then
    echo "✅ Go API готов"
else
    echo "❌ Go API не отвечает"
    docker-compose -f $COMPOSE_FILE logs goapp
fi

echo ""
echo "🎉 Корпоративный портал запущен!"
echo ""
echo "📋 Доступные сервисы:"
echo "   🔗 API Backend: http://localhost:3000"
echo "   📚 Swagger UI: http://localhost:3000/swagger/"
echo "   🗄️  PostgreSQL: localhost:5432"

if [ "$MODE" = "production" ] || [ "$MODE" = "prod" ]; then
    echo "   🌐 Production URL: https://back.portal.ru"
else
    echo "   🌐 Development Proxy: http://localhost"
fi

echo ""
echo "👥 Тестовые пользователи:"
echo "   📧 admin@portal.ru / password123"
echo "   📧 emp1@portal.ru / password123"
echo "   📧 emp2@portal.ru / password123"
echo "   📧 manager@portal.ru / password123"
echo ""
echo "📖 Логи: docker-compose -f $COMPOSE_FILE logs -f"
echo "🛑 Остановка: docker-compose -f $COMPOSE_FILE down"
echo ""
