import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:diplom/user_category/employee/screens/orders/orders_page.dart';
import 'package:diplom/user_category/employee/screens/screens.dart';
import 'package:http/http.dart' as http; // <--- ДОБАВЛЕНО
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
  // !!! ЗАМЕНИТЕ ЭТОТ URL НА ВАШ АКТУАЛЬНЫЙ URL ОТ NGROK !!!
  final String _apiUrl = "https://enormously-simple-cicada.ngrok-free.app/ask"; 
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
          'ngrok-skip-browser-warning': 'true',
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
      case 'QR код':
        return QRPage();
      case 'Каталог':
        return CatalogPage();
      case 'Администрирование':
        return AdminPage();
      case 'Настройки аккаунта':
        return AccountSettingsPage();
      default:
        return const Dashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 768;
    final isMobile = screenSize.width <= 600;
    
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
                  _buildCategoryButton('QR код'),
                  _buildCategoryButton('Каталог'),
                  _buildCategoryButton('Администрирование'),
                  _buildCategoryButton('Настройки аккаунта'),
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
            bottom: isMobile ? 16 : 20,
            right: isMobile ? 16 : 20,
            child: GestureDetector(
              onTap: _toggleMessenger,
              child: Container(
                width: isMobile ? 56 : 60,
                height: isMobile ? 56 : 60,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.assistant,
                  color: Colors.white,
                  size: isMobile ? 28 : 32,
                ),
              ),
            ),
          ),
          
          // Адаптивный диалог мессенджера
          if (_showMessenger)
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleMessenger,
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {}, // Предотвращает закрытие при клике на диалог
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: isMobile ? 16 : (isTablet ? 64 : 32),
                          vertical: isMobile ? 80 : 60,
                        ),
                        constraints: BoxConstraints(
                          maxWidth: isTablet ? 600 : double.infinity,
                          maxHeight: isMobile ? double.infinity : 500,
                        ),
                        child: Material(
                          elevation: 16,
                          borderRadius: BorderRadius.circular(isMobile ? 12 : 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(isMobile ? 12 : 20),
                            ),
                            child: Column(
                              children: [
                                // Шапка мессенджера
                                Container(
                                  padding: EdgeInsets.all(isMobile ? 12 : 16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.orange.shade400, Colors.orange.shade600],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(isMobile ? 12 : 20),
                                      topRight: Radius.circular(isMobile ? 12 : 20),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.smart_toy_outlined,
                                          color: Colors.white,
                                          size: isMobile ? 20 : 24,
                                        ),
                                      ),
                                      SizedBox(width: isMobile ? 8 : 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'AI-Ассистент',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: isMobile ? 16 : 18,
                                            ),
                                          ),
                                          Text(
                                            'Онлайн',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.8),
                                              fontSize: isMobile ? 12 : 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: isMobile ? 20 : 24,
                                          ),
                                          onPressed: _toggleMessenger,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // История сообщений
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.grey.shade50,
                                          Colors.white,
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: ListView.builder(
                                      padding: EdgeInsets.all(isMobile ? 12 : 16),
                                      reverse: false,
                                      itemCount: _messages.length + (_isLoading ? 1 : 0),
                                      itemBuilder: (context, index) {
                                        if (_isLoading && index == _messages.length) {
                                          return _buildTypingIndicator();
                                        }
                                        final message = _messages[index];
                                        return MessageBubble(
                                          message: message,
                                          isMobile: isMobile,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                
                                // Поле ввода сообщения
                                Container(
                                  padding: EdgeInsets.all(isMobile ? 12 : 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      top: BorderSide(
                                        color: Colors.grey.shade200,
                                        width: 1,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(isMobile ? 12 : 20),
                                      bottomRight: Radius.circular(isMobile ? 12 : 20),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(25),
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                              width: 1,
                                            ),
                                          ),
                                          child: TextField(
                                            controller: _messageController,
                                            decoration: InputDecoration(
                                              hintText: 'Введите сообщение...',
                                              hintStyle: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: isMobile ? 14 : 16,
                                              ),
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.symmetric(
                                                horizontal: isMobile ? 16 : 20,
                                                vertical: isMobile ? 12 : 14,
                                              ),
                                            ),
                                            style: TextStyle(
                                              fontSize: isMobile ? 14 : 16,
                                            ),
                                            onSubmitted: (_) => _sendMessage(),
                                            enabled: !_isLoading,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: isMobile ? 8 : 12),
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Colors.orange.shade400, Colors.orange.shade600],
                                          ),
                                          borderRadius: BorderRadius.circular(25),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.orange.withOpacity(0.3),
                                              blurRadius: 6,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: IconButton(
                                          icon: _isLoading
                                              ? SizedBox(
                                                  width: isMobile ? 18 : 20,
                                                  height: isMobile ? 18 : 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                  ),
                                                )
                                              : Icon(
                                                  Icons.send_rounded,
                                                  color: Colors.white,
                                                  size: isMobile ? 20 : 24,
                                                ),
                                          onPressed: _isLoading ? null : _sendMessage,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTypingDot(0),
            SizedBox(width: 4),
            _buildTypingDot(1),
            SizedBox(width: 4),
            _buildTypingDot(2),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        shape: BoxShape.circle,
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
  final bool isMobile;

  const MessageBubble({
    required this.message,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.0),
        constraints: BoxConstraints(
          maxWidth: isMobile ? MediaQuery.of(context).size.width * 0.85 : 400,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 14.0 : 16.0,
            vertical: isMobile ? 10.0 : 12.0,
          ),
          decoration: BoxDecoration(
            gradient: message.isMe
                ? LinearGradient(
                    colors: [Colors.orange.shade300, Colors.orange.shade500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [Colors.grey.shade100, Colors.grey.shade200],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomLeft: Radius.circular(message.isMe ? 18 : 4),
              bottomRight: Radius.circular(message.isMe ? 4 : 18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.text,
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: message.isMe ? Colors.white : Colors.black87,
                  height: 1.4,
                ),
              ),
              if (message.files.isNotEmpty) ...[
                SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(message.isMe ? 0.2 : 0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: message.isMe 
                          ? Colors.white.withOpacity(0.3)
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: isMobile ? 12 : 16,
                        headingRowHeight: isMobile ? 40 : 48,
                        dataRowHeight: isMobile ? 36 : 42,
                        columns: [
                          DataColumn(
                            label: Text(
                              'Описание',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isMobile ? 12 : 14,
                                color: message.isMe ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Имя файла',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isMobile ? 12 : 14,
                                color: message.isMe ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ],
                        rows: message.files.map((file) {
                          return DataRow(cells: [
                            DataCell(
                              Text(
                                file.description,
                                style: TextStyle(
                                  fontSize: isMobile ? 11 : 12,
                                  color: message.isMe ? Colors.white.withOpacity(0.9) : Colors.black87,
                                ),
                              ),
                            ),
                            DataCell(
                              InkWell(
                                onTap: () {
                                  // Действие при нажатии на файл
                                },
                                borderRadius: BorderRadius.circular(4),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                                  child: Text(
                                    file.fileName,
                                    style: TextStyle(
                                      fontSize: isMobile ? 11 : 12,
                                      color: message.isMe ? Colors.white : Colors.blue.shade600,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
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