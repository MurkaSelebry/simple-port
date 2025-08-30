import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Базовый URL для API (HTTP only - без HTTPS)
  static const String baseUrl = 'http://localhost/api';
  
  // Для продакшена можно использовать:
  // static const String baseUrl = 'http://back.portal.ru/api';

  // Получение токена из локального хранилища
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Сохранение токена в локальное хранилище
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Удаление токена из локального хранилища
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Получение заголовков с авторизацией
  static Future<Map<String, String>> getHeaders({bool includeAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (includeAuth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // Базовый метод для выполнения HTTP запросов
  static Future<http.Response> _makeRequest(
    String method,
    String endpoint,
    {Map<String, dynamic>? body, bool includeAuth = false}
  ) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await getHeaders(includeAuth: includeAuth);

    late http.Response response;

    switch (method.toUpperCase()) {
      case 'GET':
        response = await http.get(url, headers: headers);
        break;
      case 'POST':
        response = await http.post(
          url,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
        break;
      case 'PUT':
        response = await http.put(
          url,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
        break;
      case 'DELETE':
        response = await http.delete(url, headers: headers);
        break;
      default:
        throw Exception('Unsupported HTTP method: $method');
    }

    return response;
  }

  // Регистрация пользователя
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String nickname,
  }) async {
    try {
      final response = await _makeRequest('POST', '/auth/register', body: {
        'email': email,
        'password': password,
        'nickname': nickname,
      });

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Сохраняем токен если регистрация успешна
        if (responseData['data'] != null && responseData['data']['token'] != null) {
          await saveToken(responseData['data']['token']);
        }
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'error': responseData['message'] ?? 'Ошибка регистрации',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Ошибка сети: $e',
      };
    }
  }

  // Авторизация пользователя
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _makeRequest('POST', '/auth/login', body: {
        'email': email,
        'password': password,
      });

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Сохраняем токен если авторизация успешна
        if (responseData['data'] != null && responseData['data']['token'] != null) {
          await saveToken(responseData['data']['token']);
        }
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'error': responseData['message'] ?? 'Неверный email или пароль',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Ошибка сети: $e',
      };
    }
  }

  // Получение профиля пользователя
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _makeRequest('GET', '/auth/profile', includeAuth: true);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData,
        };
      } else if (response.statusCode == 401) {
        // Токен недействителен, удаляем его
        await removeToken();
        return {
          'success': false,
          'error': 'Необходима повторная авторизация',
          'needsReauth': true,
        };
      } else {
        return {
          'success': false,
          'error': responseData['message'] ?? 'Ошибка получения профиля',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Ошибка сети: $e',
      };
    }
  }

  // Выход из системы
  static Future<void> logout() async {
    await removeToken();
  }

  // Проверка, авторизован ли пользователь
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // Проверка состояния сервера
  static Future<bool> checkServerHealth() async {
    try {
      final url = Uri.parse('http://localhost/health');
      final response = await http.get(url);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
