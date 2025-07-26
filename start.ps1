#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Скрипт для запуска корпоративного портала

.DESCRIPTION
    Запускает все сервисы: API, база данных, мониторинг и нагрузочное тестирование
#>

Write-Host "=== Запуск корпоративного портала ===" -ForegroundColor Green

# Проверка наличия Docker
Write-Host "Проверка Docker..." -ForegroundColor Yellow
docker --version
if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker не установлен или не запущен!" -ForegroundColor Red
    Write-Host "Установите Docker Desktop и запустите его" -ForegroundColor Yellow
    exit 1
}

# Остановка существующих контейнеров
Write-Host "Остановка существующих контейнеров..." -ForegroundColor Yellow
docker-compose down

# Сборка и запуск сервисов
Write-Host "Запуск сервисов..." -ForegroundColor Yellow
docker-compose up -d --build

if ($LASTEXITCODE -ne 0) {
    Write-Host "Ошибка при запуске сервисов!" -ForegroundColor Red
    exit 1
}

# Ожидание запуска сервисов
Write-Host "Ожидание запуска сервисов..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Проверка статуса контейнеров
Write-Host "Проверка статуса контейнеров..." -ForegroundColor Yellow
docker-compose ps

Write-Host ""
Write-Host "=== Сервисы запущены ===" -ForegroundColor Green
Write-Host ""
Write-Host "Доступные URL:" -ForegroundColor Cyan
Write-Host "  API: http://localhost:5000" -ForegroundColor White
Write-Host "  Swagger: http://localhost:5000/docs" -ForegroundColor White
Write-Host "  Grafana: http://localhost:3000 (admin/admin)" -ForegroundColor White
Write-Host "  Prometheus: http://localhost:9090" -ForegroundColor White
Write-Host "  Jaeger: http://localhost:16686" -ForegroundColor White
Write-Host "  Load Testing: http://localhost:8080" -ForegroundColor White
Write-Host ""
Write-Host "Для остановки используйте: docker-compose down" -ForegroundColor Yellow
Write-Host "Для просмотра логов используйте: docker-compose logs -f" -ForegroundColor Yellow 