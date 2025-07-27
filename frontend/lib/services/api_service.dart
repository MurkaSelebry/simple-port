import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.1.79:6000/api'; // Для эмулятора Android

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('Request URL: ${response.request?.url}');
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Ошибка авторизации: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Ошибка подключения: $e');
    }
  }

  // Получение информационных элементов
  static Future<Map<String, dynamic>> getInfoItems({String? category}) async {
    try {
      final uri = category != null 
          ? Uri.parse('$baseUrl/info?category=$category')
          : Uri.parse('$baseUrl/info');
      
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Ошибка получения данных: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка подключения: $e');
    }
  }

  // Получение заказов
  static Future<Map<String, dynamic>> getOrders({String? status, String? priority}) async {
    try {
      final queryParams = <String, String>{};
      if (status != null) queryParams['status'] = status;
      if (priority != null) queryParams['priority'] = priority;
      
      final uri = Uri.parse('$baseUrl/orders').replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Ошибка получения заказов: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка подключения: $e');
    }
  }

  // Получение статистики заказов
  static Future<Map<String, dynamic>> getOrderStatistics() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/orders/statistics'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Ошибка получения статистики: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка подключения: $e');
    }
  }

  // Проверка здоровья API
  static Future<bool> checkHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/auth/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
} 