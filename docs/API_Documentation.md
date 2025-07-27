# API Документация - Corporate Portal

## Обзор

API корпоративного портала предоставляет RESTful интерфейс для работы с пользователями, информационными элементами и заказами.

**Базовый URL:** `http://localhost:6000/api`

## Аутентификация

### POST /auth/login

Вход в систему пользователя.

**Запрос:**

```json
{
  "email": "employee@company.com",
  "password": "employee123"
}
```

**Ответ:**

```json
{
  "id": 2,
  "nick": "employee",
  "email": "employee@company.com",
  "message": "Успешный вход"
}
```

**Коды ответов:**

- `200` - Успешный вход
- `401` - Неверные учетные данные
- `500` - Внутренняя ошибка сервера

### GET /auth/health

Проверка здоровья API.

**Ответ:**

```json
{
  "status": "OK",
  "timestamp": "2024-01-15T10:30:00Z"
}
```

## Информационные элементы

### GET /info

Получение списка информационных элементов.

**Параметры запроса:**

- `category` (опционально) - фильтрация по категории

**Примеры:**

```bash
# Все элементы
GET /api/info

# Только документы
GET /api/info?category=GeneralDocuments

# Только рекламные материалы
GET /api/info?category=AdvertisingMaterials

# Только прайсы
GET /api/info?category=Prices
```

**Ответ:**

```json
{
  "items": [
    {
      "id": 1,
      "title": "Правила внутреннего трудового распорядка",
      "description": "Документ, регламентирующий порядок работы сотрудников",
      "category": "GeneralDocuments",
      "createdAt": "2024-01-15T10:30:00Z",
      "filePath": null,
      "fileType": null
    }
  ],
  "total": 1
}
```

### GET /info/{id}

Получение конкретного информационного элемента.

**Ответ:**

```json
{
  "id": 1,
  "title": "Правила внутреннего трудового распорядка",
  "description": "Документ, регламентирующий порядок работы сотрудников",
  "category": "GeneralDocuments",
  "createdAt": "2024-01-15T10:30:00Z",
  "updatedAt": null,
  "filePath": null,
  "fileType": null
}
```

### GET /info/categories

Получение списка доступных категорий.

**Ответ:**

```json
{
  "categories": ["GeneralDocuments", "AdvertisingMaterials", "Prices"]
}
```

## Заказы

### GET /orders

Получение списка заказов.

**Параметры запроса:**

- `status` (опционально) - фильтрация по статусу (New, InProgress, Completed, Cancelled)
- `priority` (опционально) - фильтрация по приоритету (Low, Medium, High)

**Примеры:**

```bash
# Все заказы
GET /api/orders

# Только новые заказы
GET /api/orders?status=New

# Только высокоприоритетные заказы
GET /api/orders?priority=High

# Комбинированная фильтрация
GET /api/orders?status=InProgress&priority=High
```

**Ответ:**

```json
{
  "orders": [
    {
      "id": 1,
      "title": "Заказ на разработку сайта",
      "description": "Создание корпоративного сайта для клиента",
      "status": "InProgress",
      "priority": "High",
      "createdAt": "2024-01-10T10:30:00Z",
      "updatedAt": "2024-01-12T15:45:00Z",
      "completedAt": null,
      "assignedUser": {
        "id": 2,
        "nick": "employee",
        "email": "employee@company.com"
      },
      "notes": "Срочный заказ",
      "totalAmount": 50000
    }
  ],
  "total": 1,
  "statistics": {
    "new": 1,
    "inProgress": 1,
    "completed": 1,
    "cancelled": 0
  }
}
```

### GET /orders/{id}

Получение конкретного заказа.

**Ответ:**

```json
{
  "id": 1,
  "title": "Заказ на разработку сайта",
  "description": "Создание корпоративного сайта для клиента",
  "status": "InProgress",
  "priority": "High",
  "createdAt": "2024-01-10T10:30:00Z",
  "updatedAt": "2024-01-12T15:45:00Z",
  "completedAt": null,
  "assignedUser": {
    "id": 2,
    "nick": "employee",
    "email": "employee@company.com"
  },
  "notes": "Срочный заказ",
  "totalAmount": 50000
}
```

### GET /orders/statistics

Получение статистики по заказам.

**Ответ:**

```json
{
  "total": 3,
  "new": 1,
  "inProgress": 1,
  "completed": 1,
  "cancelled": 0,
  "totalAmount": 73000
}
```

## Модели данных

### User

```json
{
  "id": 1,
  "nick": "admin",
  "email": "admin@company.com",
  "password": "admin123",
  "createdAt": "2024-01-15T10:30:00Z",
  "isActive": true
}
```

### InfoItem

```json
{
  "id": 1,
  "title": "Название документа",
  "description": "Описание документа",
  "category": "GeneralDocuments",
  "createdAt": "2024-01-15T10:30:00Z",
  "updatedAt": null,
  "isActive": true,
  "filePath": "/files/document.pdf",
  "fileType": "pdf"
}
```

### Order

```json
{
  "id": 1,
  "title": "Название заказа",
  "description": "Описание заказа",
  "status": "InProgress",
  "createdAt": "2024-01-15T10:30:00Z",
  "updatedAt": null,
  "completedAt": null,
  "assignedUserId": 2,
  "notes": "Дополнительные заметки",
  "totalAmount": 10000,
  "priority": "High"
}
```

## Статусы заказов

- `New` - Новый заказ
- `InProgress` - В работе
- `Completed` - Завершен
- `Cancelled` - Отменен

## Приоритеты заказов

- `Low` - Низкий
- `Medium` - Средний
- `High` - Высокий

## Категории информационных элементов

- `GeneralDocuments` - Общие документы
- `AdvertisingMaterials` - Рекламные материалы
- `Prices` - Прайсы

## Обработка ошибок

Все ошибки возвращают JSON с описанием:

```json
{
  "message": "Описание ошибки"
}
```

**Коды ошибок:**

- `400` - Неверный запрос
- `401` - Не авторизован
- `404` - Не найдено
- `500` - Внутренняя ошибка сервера

## Тестирование производительности

Для тестирования медленных запросов используйте специальные параметры:

```bash
# Медленный запрос к информации
GET /api/info?category=slow

# Медленный запрос к заказам
GET /api/orders?status=slow

# Медленный запрос авторизации
POST /api/auth/login
{
  "email": "slow@example.com",
  "password": "password"
}
```

Эти запросы будут иметь искусственную задержку для тестирования алертов производительности.

## Мониторинг

### Health Check

```bash
GET /health
```

### Метрики Prometheus

```bash
GET /metrics
```

## Примеры использования

### cURL

```bash
# Авторизация
curl -X POST http://localhost:6000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "employee@company.com", "password": "employee123"}'

# Получение всех заказов
curl http://localhost:6000/api/orders

# Получение статистики
curl http://localhost:6000/api/orders/statistics

# Получение документов
curl http://localhost:6000/api/info?category=GeneralDocuments
```

### JavaScript

```javascript
// Авторизация
const loginResponse = await fetch("http://localhost:6000/api/auth/login", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    email: "employee@company.com",
    password: "employee123",
  }),
});

// Получение заказов
const ordersResponse = await fetch("http://localhost:6000/api/orders");
const orders = await ordersResponse.json();

// Получение информации
const infoResponse = await fetch("http://localhost:6000/api/info");
const info = await infoResponse.json();
```

### Python

```python
import requests

# Авторизация
response = requests.post('http://localhost:6000/api/auth/login', json={
    'email': 'employee@company.com',
    'password': 'employee123'
})

# Получение заказов
orders = requests.get('http://localhost:6000/api/orders').json()

# Получение информации
info = requests.get('http://localhost:6000/api/info').json()
```
