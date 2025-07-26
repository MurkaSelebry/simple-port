#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Скрипт для сборки корпоративного портала

.DESCRIPTION
    Восстанавливает пакеты NuGet и собирает все проекты решения
#>

Write-Host "=== Сборка корпоративного портала ===" -ForegroundColor Green

# Очистка предыдущих сборок
Write-Host "Очистка предыдущих сборок..." -ForegroundColor Yellow
dotnet clean CorporatePortal.sln

# Восстановление пакетов
Write-Host "Восстановление пакетов NuGet..." -ForegroundColor Yellow
dotnet restore CorporatePortal.sln

if ($LASTEXITCODE -ne 0) {
    Write-Host "Ошибка при восстановлении пакетов!" -ForegroundColor Red
    exit 1
}

# Сборка решения
Write-Host "Сборка решения..." -ForegroundColor Yellow
dotnet build CorporatePortal.sln --no-restore

if ($LASTEXITCODE -ne 0) {
    Write-Host "Ошибка при сборке!" -ForegroundColor Red
    exit 1
}

Write-Host "Сборка завершена успешно!" -ForegroundColor Green
Write-Host ""
Write-Host "Для запуска API используйте:" -ForegroundColor Cyan
Write-Host "  dotnet run --project CorporatePortal.API" -ForegroundColor White
Write-Host ""
Write-Host "Для запуска с Docker используйте:" -ForegroundColor Cyan
Write-Host "  docker-compose up -d" -ForegroundColor White 