import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:diplom/user_category/employee/screens/orders/orders_page.dart';
import 'package:diplom/user_category/employee/screens/screens.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RagResponse {
  final String answer;
  final List<dynamic> sources;

  RagResponse({required this.answer, required this.sources});

  factory RagResponse.fromJson(Map<String, dynamic> json) {
    return RagResponse(
      answer: json['answer'] ?? 'No answer received',
      sources: json['sources'] ?? [],
    );
  }
}

void main() {
  runApp(EmployeeMainPage());
}

class EmployeeMainPage extends StatelessWidget {
  const EmployeeMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedCategory;
  bool _showMessenger = false;
  final TextEditingController _messageController = TextEditingController();
  
  // Я сохранил ваши примеры сообщений для демонстрации
  final List<Message> _messages = [
    Message(
      text: "Здравствуйте! Я ваш цифровой помощник. Чем могу помочь?",
      isMe: false,
      files: [],
    ),
  ];

  // --- НОВЫЕ ПЕРЕМЕННЫЕ для API ---
  bool _isLoading = false;
  // Обновленный URL для локального C# backend
  final String _apiUrl = "http://localhost:5000/api/chat/send"; 
  // --- Конец новых переменных ---

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _toggleMessenger() {
    setState(() {
      _showMessenger = !_showMessenger;
    });
  }

  // --- ОБНОВЛЕННЫЙ МЕТОД _sendMessage ---
  void _sendMessage() {
    final String query = _messageController.text;
    if (query.isEmpty) return;

    // 1. Сразу добавляем сообщение пользователя в чат для отзывчивости
    setState(() {
      _messages.add(Message(
        text: query,
        isMe: true,
        files: [],
      ));
      _isLoading = true; // Показываем индикатор загрузки
    });
    _messageController.clear();

    // 2. Отправляем запрос к API и ждем ответа
    _getRagResponse(query);
  }
  // --- Конец обновленного метода ---

  Future<void> _getRagResponse(String query) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'query': query}),
      );

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final ragResponse = RagResponse.fromJson(jsonDecode(decodedResponse));

        // --- НОВАЯ ЛОГИКА: Парсинг источников ---
        List<FileItem> sourceFiles = [];
        for (var sourceData in ragResponse.sources) {
          if (sourceData is Map<String, dynamic>) {
            print(sourceData);
            sourceFiles.add(FileItem(
              // Используем 'filename' из JSON для поля 'description'
              description: sourceData['filename'] ?? 'Unknown File',
              // Используем 'source' (полный путь) из JSON для поля 'fileName'
              fileName: sourceData['source'] ?? 'Unknown Path',
            ));
          }
        }
        // --- Конец новой логики ---

        setState(() {
          _messages.add(Message(
            text: ragResponse.answer,
            isMe: false,
            files: sourceFiles, // <-- Добавляем распарсенные файлы
          ));
        });
      } else {
        setState(() {
          _messages.add(Message(
            text: "Ошибка сервера: ${response.statusCode}. Пожалуйста, попробуйте позже.",
            isMe: false,
            files: [],
          ));
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(Message(
          text: "Ошибка подключения: $e. Убедитесь, что сервер запущен и URL правильный.",
          isMe: false,
          files: [],
        ));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildContent() {
    switch (_selectedCategory) {
      case 'Информация':
        return InfoPage();
      case 'Заказы':
        return OrdersPage();
      default:
        return const Dashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16.0,
                runSpacing: 8.0,
                children: <Widget>[
                  _buildCategoryButton('Информация'),
                  _buildCategoryButton('Заказы'),
                ],
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildContent(),
                ),
              ),
            ],
          ),
          
          // Кнопка мессенджера в правом нижнем углу
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: _toggleMessenger,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.assistant,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
          
          // Диалог мессенджера
          if (_showMessenger)
            Positioned(
              bottom: 90,
              right: 30,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 550,
                  height: 450,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // Шапка мессенджера
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.chat, color: Colors.white),
                            const SizedBox(width: 8),
                            const Text(
                              'AI-Ассистент',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: _toggleMessenger,
                            ),
                          ],
                        ),
                      ),
                      
                      // История сообщений
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          reverse: false,
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final message = _messages[index];
                            return MessageBubble(message: message);
                          },
                        ),
                      ),
                      
                      // Поле ввода сообщения
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                decoration: const InputDecoration(
                                  hintText: 'Введите сообщение',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                ),
                                onSubmitted: (_) => _sendMessage(),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send, color: Colors.orange),
                              onPressed: _sendMessage,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    final bool isSelected = _selectedCategory == category;

    return GestureDetector(
      onTap: () => _selectCategory(category),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Text(
              category,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.orange : Colors.black,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4.0),
                height: 2.0,
                width: 60.0,
                color: Colors.orange,
              ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        padding: EdgeInsets.all(12.0),
        constraints: BoxConstraints(maxWidth: 350),
        decoration: BoxDecoration(
          color: message.isMe ? Colors.orange[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(fontSize: 16),
            ),
            if (message.files.isNotEmpty) ...[
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DataTable(
                  columnSpacing: 8,
                  columns: [
                    DataColumn(label: Text('Описание')),
                    DataColumn(label: Text('Имя файла')),
                  ],
                  rows: message.files.map((file) {
                    return DataRow(cells: [
                      DataCell(
                        Text(
                          file.description,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      DataCell(
                        InkWell(
                          onTap: () {
                            // Действие при нажатии на файл
                          },
                          child: Text(
                            file.fileName,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final bool isMe;
  final List<FileItem> files;

  Message({
    required this.text,
    required this.isMe,
    required this.files,
  });
}

class FileItem {
  final String description;
  final String fileName;

  FileItem({
    required this.description,
    required this.fileName,
  });
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Дашборд',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16.0),
        Expanded(
          child: Row(
            children: [
              _buildStatisticCard(
                title: "Всего заказов",
                count: 120,
                color: Colors.blue,
              ),
              _buildStatisticCard(
                title: "В разработке",
                count: 50,
                color: Colors.orange,
              ),
              _buildStatisticCard(
                title: "Закрыто",
                count: 70,
                color: Colors.green,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: _buildPieChart(),
              ),
              Expanded(
                child: _buildBarChart(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        Expanded(
          child: _buildLineChart(),
        ),
      ],
    );
  }

  Widget _buildStatisticCard({
    required String title,
    required int count,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16.0, color: color),
              ),
              const SizedBox(height: 8.0),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(
                value: 70,
                color: Colors.green,
                title: 'Закрыто',
              ),
              PieChartSectionData(
                value: 50,
                color: Colors.orange,
                title: 'В разработке',
              ),
              PieChartSectionData(
                value: 20,
                color: Colors.red,
                title: 'Новые',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            barGroups: [
              BarChartGroupData(x: 1, barRods: [
                BarChartRodData(toY: 20, color: Colors.green),
              ]),
              BarChartGroupData(x: 2, barRods: [
                BarChartRodData(toY: 40, color: Colors.orange),
              ]),
              BarChartGroupData(x: 3, barRods: [
                BarChartRodData(toY: 30, color: Colors.red),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(1, 20),
                  FlSpot(2, 40),
                  FlSpot(3, 30),
                ],
                isCurved: true,
                color: Colors.blue,
                barWidth: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}