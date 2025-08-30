# Corporate Portal Frontend (Flutter)

Flutter фронтенд для корпоративного портала с интеграцией к Go бэкенду.

## Особенности

- 🔐 Авторизация и регистрация через API
- 📱 Адаптивный дизайн для всех устройств
- 🌐 Интеграция с бэкендом на `back.portal.ru`
- 💾 Локальное хранение токенов
- 📊 Управление заказами, каталогом и пользователями

## Быстрый старт

### Предварительные требования

- Flutter SDK (3.6.0 или выше)
- Dart SDK
- Android Studio / VS Code
- Запущенный бэкенд (см. main_app_backend/README.md)

### Установка

```bash
cd main_app

# Установка зависимостей
flutter pub get

# Запуск приложения
flutter run
```

### Для веб-разработки

```bash
flutter run -d chrome
```

### Для Android/iOS

```bash
# Android
flutter run -d android

# iOS (только на macOS)
flutter run -d ios
```

## Конфигурация API

Настройки API находятся в файле `lib/services/api_service.dart`:

```dart
// Продакшен URL
static const String baseUrl = 'https://back.portal.ru/api';

// Локальная разработка
// static const String baseUrl = 'http://localhost/api';
```

### Изменение адреса API

Для локальной разработки:

1. Откройте `lib/services/api_service.dart`
2. Закомментируйте продакшен URL
3. Раскомментируйте локальный URL
4. Выполните hot reload

## Структура проекта

```
lib/
├── main.dart                    # Главный файл приложения
├── services/
│   └── api_service.dart        # Сервис для работы с API
└── user_category/              # Категории пользователей
    ├── admin/                  # Функции администратора
    │   └── admin.dart
    └── employee/               # Функции сотрудника
        └── screens/            # Экраны приложения
            ├── account/        # Настройки аккаунта
            ├── administration/ # Администрирование
            ├── catalog/        # Каталог товаров
            ├── info/          # Информационные материалы
            ├── orders/        # Заказы и упаковки
            └── qr/            # QR коды
```

## Аутентификация

### Доступные тестовые аккаунты

- **admin@portal.ru** / password123 - Администратор
- **emp1@portal.ru** / password123 - Сотрудник 1
- **emp2@portal.ru** / password123 - Сотрудник 2
- **manager@portal.ru** / password123 - Менеджер

### Функционал аутентификации

- ✅ Регистрация новых пользователей
- ✅ Авторизация существующих пользователей
- ✅ Автоматическое сохранение токенов
- ✅ Проверка валидности токенов
- ✅ Автоматический logout при истечении токена

## API Integration

Приложение интегрируется с следующими API endpoints:

### Аутентификация

- `POST /api/auth/login` - Авторизация
- `POST /api/auth/register` - Регистрация
- `GET /api/auth/profile` - Получение профиля

### Использование API сервиса

```dart
import 'package:diplom/services/api_service.dart';

// Авторизация
final result = await ApiService.login(
  email: 'user@portal.ru',
  password: 'password123',
);

if (result['success']) {
  // Успешная авторизация
  Navigator.pushReplacementNamed(context, '/employee');
} else {
  // Обработка ошибки
  print(result['error']);
}

// Получение профиля
final profile = await ApiService.getProfile();

// Проверка авторизации
final isLoggedIn = await ApiService.isLoggedIn();
```

## Разработка

### Запуск в режиме разработки

```bash
# С hot reload
flutter run

# С debug информацией
flutter run --verbose

# Для конкретного устройства
flutter devices
flutter run -d device_id
```

### Сборка для продакшена

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (только на macOS)
flutter build ios --release

# Web
flutter build web --release
```

### Полезные команды

```bash
# Анализ кода
flutter analyze

# Запуск тестов
flutter test

# Очистка build кеша
flutter clean
flutter pub get

# Обновление зависимостей
flutter pub upgrade
```

## Настройка для разных окружений

### Development

```dart
// В api_service.dart
static const String baseUrl = 'http://localhost/api';
```

### Production

```dart
// В api_service.dart
static const String baseUrl = 'https://back.portal.ru/api';
```

### Staging (если нужно)

```dart
// В api_service.dart
static const String baseUrl = 'https://staging.back.portal.ru/api';
```

## Troubleshooting

### Проблемы с сетевыми запросами

1. **CORS ошибки** - убедитесь, что бэкенд настроен правильно
2. **Timeout ошибки** - проверьте доступность API
3. **SSL сертификаты** - для HTTPS убедитесь в валидности сертификатов

### Проблемы с авторизацией

1. **Токен истек** - приложение автоматически redirectит на login
2. **Неверные credentials** - проверьте email/password
3. **API недоступен** - проверьте статус бэкенда

### Общие проблемы

```bash
# Очистка и переустановка
flutter clean
rm -rf pubspec.lock
flutter pub get

# Проблемы с iOS симулятором
flutter clean
cd ios && pod install && cd ..
flutter run

# Проблемы с Android
flutter clean
flutter pub get
flutter run
```

## Зависимости

Основные зависимости проекта:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.1 # HTTP клиент
  shared_preferences: ^2.2.2 # Локальное хранилище
  cupertino_icons: ^1.0.6 # iOS иконки
  image_picker: ^1.1.2 # Выбор изображений
  permission_handler: ^11.3.1 # Разрешения
  provider: ^6.1.2 # State management
  excel: ^2.0.20 # Работа с Excel
  pdf: ^3.10.4 # Генерация PDF
  fl_chart: ^0.70.2 # Графики
```

## Контрибуция

1. Создайте feature branch
2. Внесите изменения
3. Добавьте тесты если необходимо
4. Запустите `flutter analyze`
5. Создайте Pull Request

## Поддержка

При возникновении проблем:

1. Проверьте статус бэкенда
2. Убедитесь в правильности API URL
3. Проверьте логи Flutter: `flutter logs`
4. Проверьте network inspector в браузере (для web)
