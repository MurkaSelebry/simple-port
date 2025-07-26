FROM python:3.9-slim

WORKDIR /app

# Копируем requirements.txt сначала для лучшего кэширования
COPY load-testing/requirements.txt .
RUN pip install -r requirements.txt

# Копируем остальные файлы
COPY load-testing/ .

EXPOSE 8080

CMD ["python", "app.py"] 