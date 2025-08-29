# Dockerfile для Caddy
FROM caddy:2.6.4

# Копируем Caddyfile в контейнер
COPY Caddyfile /etc/caddy/Caddyfile

# Копируем статику Flutter (если клиент собран)
COPY /path/to/flutter/build/web /srv

# Порт 443 для HTTPS
EXPOSE 443

# Запуск Caddy
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
# Dockerfile для Go-сервера
# Используем официальный образ Golang
FROM golang:1.20-alpine

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файлы проекта в контейнер
COPY . .

# Собираем Go приложение
RUN go build -o myapp .

# Порт, который использует приложение Go
EXPOSE 8080

# Запускаем приложение Go
CMD ["./myapp"]
