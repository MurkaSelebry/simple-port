# Documentation Server

Веб-сервер для размещения документации проекта Corporate Portal на localhost:80/docs

## 🚀 Запуск

```bash
cd backend
docker-compose up -d docs-server
```

## 📚 Доступные страницы

- **Главная**: http://localhost:80/docs
- **Быстрый старт**: http://localhost:80/docs/QUICK_START
- **Полный отчет**: http://localhost:80/docs/REPORT
- **Финальное резюме**: http://localhost:80/docs/FINAL_SUMMARY
- **API документация**: http://localhost:80/docs/API_Documentation
- **Руководство по мониторингу**: http://localhost:80/docs/Monitoring_Guide

## 🔧 Технологии

- **Flask** - веб-фреймворк
- **Markdown** - конвертация markdown в HTML
- **Bootstrap 5** - стилизация
- **Font Awesome** - иконки
- **Prism.js** - подсветка синтаксиса

## 📁 Структура

```
docs-server/
├── app.py              # Основное приложение
├── requirements.txt    # Python зависимости
├── Dockerfile         # Docker образ
├── templates/         # HTML шаблоны
│   ├── base.html      # Базовый шаблон
│   ├── index.html     # Главная страница
│   └── markdown.html  # Шаблон для markdown
└── README.md          # Этот файл
```

## 🌐 Особенности

- **Адаптивный дизайн** - работает на мобильных устройствах
- **Боковая навигация** - быстрый доступ к разделам
- **Подсветка синтаксиса** - для кода в документации
- **Ссылки на сервисы** - прямые ссылки на все компоненты системы
- **Хлебные крошки** - навигация по разделам

## 🔗 Интеграция

Документация автоматически интегрирована с основными сервисами:

- **API**: http://localhost:6500
- **Swagger**: http://localhost:6500/swagger
- **Load Tester**: http://localhost:8080
- **Grafana**: http://localhost:3000
- **Jaeger**: http://localhost:16686
- **Telegram**: https://t.me/corporate_portal_alerts

## 📝 Обновление документации

Для обновления документации:

1. Отредактируйте файлы в папке `docs/`
2. Перезапустите контейнер:
   ```bash
   docker-compose restart docs-server
   ```

## ✅ Проверка

```bash
# Проверка главной страницы
curl -I http://localhost:80/docs

# Проверка всех страниц
for page in QUICK_START FINAL_SUMMARY API_Documentation Monitoring_Guide; do
  echo "Testing $page:"
  curl -s -o /dev/null -w "%{http_code}" http://localhost:80/docs/$page
  echo
done
```

## 🎯 Результат

Документация доступна по адресу **http://localhost:80/docs** и содержит:

- ✅ Полный отчет по всем пунктам задания
- ✅ Быстрый старт и инструкции
- ✅ API документацию
- ✅ Руководство по мониторингу
- ✅ Ссылки на все сервисы
- ✅ Красивое оформление с навигацией
