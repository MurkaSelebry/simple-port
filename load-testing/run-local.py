#!/usr/bin/env python3
"""
Локальный запуск нагрузочного тестирования без Docker
"""

import os
import sys
import subprocess

def install_requirements():
    """Установка зависимостей"""
    print("Установка зависимостей...")
    subprocess.run([sys.executable, "-m", "pip", "install", "-r", "requirements.txt"])

def run_app():
    """Запуск приложения"""
    print("Запуск нагрузочного тестирования...")
    print("URL: http://localhost:8080")
    print("Нажмите Ctrl+C для остановки")
    
    # Установка переменных окружения
    os.environ.setdefault('API_BASE_URL', 'http://localhost:5000')
    os.environ.setdefault('TELEGRAM_BOT_TOKEN', 'YOUR_BOT_TOKEN_HERE')
    os.environ.setdefault('TELEGRAM_CHANNEL_ID', '@corporate_portal_alerts')
    
    # Запуск Flask приложения
    subprocess.run([sys.executable, "app.py"])

if __name__ == "__main__":
    try:
        install_requirements()
        run_app()
    except KeyboardInterrupt:
        print("\nПриложение остановлено")
    except Exception as e:
        print(f"Ошибка: {e}")
        sys.exit(1) 