# Руководство по интеграции API во Flutter приложении

## Обзор

В данном проекте была добавлена полная интеграция с backend API для получения и отображения данных в реальном времени. Все статические данные заменены на динамические данные, получаемые с сервера.

## Структура API интеграции

### 1. API Service (`lib/services/api_service.dart`)

Центральный сервис для всех API вызовов:

```dart
class ApiService {
  static const String baseUrl = 'http://localhost:6500/api';

  // Основные методы:
  static Future<Map<String, dynamic>> login(String email, String password)
  static Future<Map<String, dynamic>> getInfoItems({String? category})
  static Future<Map<String, dynamic>> getOrders({String? status, String? priority})
  static Future<Map<String, dynamic>> getOrderStatistics()
  static Future<bool> checkHealth()
}
```

**Конфигурация URL:**

- Локальная разработка: `http://localhost:6500/api`
- Для мобильного эмулятора: замените на IP адрес вашего компьютера

### 2. Новые экраны с API интеграцией

#### 2.1 Экран заказов с API (`orders_with_api.dart`)

**Особенности:**

- Автоматическая загрузка заказов при открытии
- Фильтрация по статусу и приоритету
- Загрузка статистики заказов
- Обработка ошибок с возможностью повторной попытки
- Pull-to-refresh функциональность

**API endpoints:**

- `GET /api/orders` - получение списка заказов
- `GET /api/orders/statistics` - получение статистики

**Состояния экрана:**

- Loading - показ индикатора загрузки
- Error - отображение ошибки с кнопкой повтора
- Empty - сообщение об отсутствии данных
- Data - отображение списка заказов

#### 2.2 Экран информации с API (`info_with_api.dart`)

**Особенности:**

- Загрузка информационных элементов по категориям
- Фильтрация по типу контента
- Детальный просмотр элементов в диалоговом окне
- Цветовая индикация по категориям

**API endpoints:**

- `GET /api/info` - получение всех элементов
- `GET /api/info?category=documents` - фильтрация по категории

#### 2.3 Экран графиков с API (`charts_with_api.dart`)

**Особенности:**

- Динамические графики на основе реальных данных
- Круговая диаграмма распределения заказов
- Столбчатая диаграмма статистики
- Карточки с суммарной информацией
- Таблица детальной статистики

**Используемые данные:**

- Статистика заказов по статусам
- Общая сумма заказов
- Количественные показатели

#### 2.4 Экран состояния API (`api_status_screen.dart`)

**Особенности:**

- Проверка доступности API
- Отображение статистики всех endpoints
- Журнал подключений в реальном времени
- Информация о конфигурации API
- Индикаторы состояния различных сервисов

## 3. Интеграция в основное приложение

### Обновленные файлы:

1. **`orders_page.dart`** - добавлен импорт и использование `OrdersWithApi`
2. **`info_page.dart`** - добавлена категория "API Данные" с `InfoWithApi`
3. **`employee_main.dart`** - добавлена кнопка "API Статус" и соответствующий роутинг

### Навигация:

```dart
// В методе _buildContent():
case 'API Статус':
  return ApiStatusScreen();
case 'Информация':
  return InfoPage(); // Содержит InfoWithApi как первую вкладку
case 'Заказы':
  return OrdersPage(); // Использует OrdersWithApi и ChartsWithApi
```

## 4. Обработка ошибок

### Типы ошибок:

1. **Сетевые ошибки** - проблемы с подключением к серверу
2. **HTTP ошибки** - ошибки статус-кодов (404, 500, etc.)
3. **Ошибки парсинга** - неправильный формат JSON
4. **Timeout ошибки** - превышение времени ожидания

### Паттерн обработки:

```dart
try {
  final response = await ApiService.getOrders();
  setState(() {
    orders = response['orders'] ?? [];
  });
} catch (e) {
  setState(() {
    errorMessage = e.toString();
  });
} finally {
  setState(() {
    isLoading = false;
  });
}
```

## 5. Состояния UI

### Стандартные состояния для всех экранов:

1. **Loading State:**

```dart
if (isLoading) {
  return const Center(child: CircularProgressIndicator());
}
```

2. **Error State:**

```dart
if (errorMessage != null) {
  return Center(
    child: Column(
      children: [
        Icon(Icons.error_outline),
        Text('Ошибка загрузки данных'),
        ElevatedButton(
          onPressed: _loadData,
          child: const Text('Попробовать снова'),
        ),
      ],
    ),
  );
}
```

3. **Empty State:**

```dart
if (data.isEmpty) {
  return const Center(
    child: Text('Данные не найдены'),
  );
}
```

## 6. Конфигурация для разработки

### Настройка URL API:

1. **Для локальной разработки:**

```dart
static const String baseUrl = 'http://localhost:6500/api';
```

2. **Для мобильного эмулятора:**

```dart
static const String baseUrl = 'http://192.168.1.XXX:6500/api';
```

3. **Для production:**

```dart
static const String baseUrl = 'https://your-domain.com/api';
```

### Запуск backend сервера:

```bash
cd backend
docker-compose up -d
# API будет доступен на http://localhost:6500
```

## 7. Тестирование интеграции

### Тестовые сценарии:

1. **Тест подключения:**

   - Откройте экран "API Статус"
   - Нажмите кнопку обновления
   - Проверьте статус всех сервисов

2. **Тест заказов:**

   - Перейдите в раздел "Заказы"
   - Попробуйте фильтрацию по статусу
   - Проверьте загрузку статистики

3. **Тест информации:**

   - Откройте раздел "Информация" -> "API Данные"
   - Попробуйте фильтрацию по категориям
   - Откройте детали любого элемента

4. **Тест графиков:**
   - В разделе "Заказы" перейдите на вкладку "Графики"
   - Проверьте отображение круговой и столбчатой диаграмм

## 8. Troubleshooting

### Частые проблемы:

1. **Connection refused:**

   - Убедитесь, что backend сервер запущен
   - Проверьте правильность URL
   - Для эмулятора используйте IP адрес, а не localhost

2. **CORS ошибки:**

   - Backend уже настроен для работы с frontend
   - Проверьте конфигурацию в `Program.cs`

3. **Timeout ошибки:**

   - Увеличьте timeout в http запросах
   - Проверьте стабильность сетевого соединения

4. **JSON parsing ошибки:**
   - Проверьте формат ответа API
   - Убедитесь в соответствии ключей в модели данных

### Логирование:

Все API вызовы логируются в консоль для отладки:

```dart
print('Request URL: ${response.request?.url}');
print('Response Status Code: ${response.statusCode}');
print('Response Body: ${response.body}');
```

## 9. Дальнейшее развитие

### Возможные улучшения:

1. **Кэширование данных** - сохранение данных локально
2. **Offline режим** - работа без интернета
3. **Пагинация** - загрузка данных по частям
4. **Реальное время** - WebSocket подключения
5. **Аутентификация** - JWT токены и refresh логика
6. **Оптимизация производительности** - ленивая загрузка, мемоизация

### Структура для масштабирования:

```
lib/
├── services/
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── cache_service.dart
│   └── websocket_service.dart
├── models/
│   ├── order.dart
│   ├── info_item.dart
│   └── user.dart
├── screens/
│   ├── orders/
│   ├── info/
│   └── auth/
└── widgets/
    ├── loading_widget.dart
    ├── error_widget.dart
    └── empty_state_widget.dart
```

Это руководство поможет разработчикам понять и дальше развивать API интеграцию в приложении.
