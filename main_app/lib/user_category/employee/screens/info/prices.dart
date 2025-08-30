import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../common/universal_responsive_table.dart';

class Document {
  String description;   // Описание
  String fileName;      // Имя файла
  String addedBy;       // Кем добавлено
  String addedDate;     // Дата добавления
  String readStatus;    // Статус прочтения
  String filePath;      // Путь к файлу

  Document({
    required this.description,
    required this.fileName,
    required this.addedBy,
    required this.addedDate,
    required this.readStatus,
    required this.filePath,
  });

  factory Document.fromMap(Map<String, String> map) {
    return Document(
      description: map['Описание'] ?? '',
      fileName: map['Имя файла'] ?? '',
      addedBy: map['Кем добавлено'] ?? '',
      addedDate: map['Дата добавления'] ?? '',
      readStatus: map['Прочитан'] ?? '',
      filePath: map['Путь'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'Описание': description,
      'Имя файла': fileName,
      'Кем добавлено': addedBy,
      'Дата добавления': addedDate,
      'Прочитан': readStatus,
      'Путь': filePath,
    };
  }

  Document copyWith({
    String? description,
    String? fileName,
    String? addedBy,
    String? addedDate,
    String? readStatus,
    String? filePath,
  }) {
    return Document(
      description: description ?? this.description,
      fileName: fileName ?? this.fileName,
      addedBy: addedBy ?? this.addedBy,
      addedDate: addedDate ?? this.addedDate,
      readStatus: readStatus ?? this.readStatus,
      filePath: filePath ?? this.filePath,
    );
  }

  Document copyWithField(String field, String value) {
    switch (field) {
      case 'Описание':
        return copyWith(description: value);
      case 'Имя файла':
        return copyWith(fileName: value);
      case 'Кем добавлено':
        return copyWith(addedBy: value);
      case 'Дата добавления':
        return copyWith(addedDate: value);
      case 'Прочитан':
        return copyWith(readStatus: value);
      case 'Путь':
        return copyWith(filePath: value);
      default:
        return this;
    }
  }
}

final List<Document> initialOrders = [
  Document(
    description: 'Актуальные цены на мебельную продукцию',
    fileName: 'Прайс-лист на мебель (январь 2024).xlsx',
    addedBy: 'anna.morozova',
    addedDate: '2024-01-05',
    readStatus: 'Прочитан',
    filePath: '/prices/furniture.xlsx',
  ),
  Document(
    description: 'Цены на компьютеры и периферию',
    fileName: 'Прайс-лист на электронику (январь 2024).xlsx',
    addedBy: 'dmitry.kozlov',
    addedDate: '2024-01-06',
    readStatus: 'Прочитан',
    filePath: '/prices/electronics.xlsx',
  ),
  Document(
    description: 'Цены на строительные инструменты',
    fileName: 'Прайс-лист на инструменты (январь 2024).xlsx',
    addedBy: 'alex.kuznetsov',
    addedDate: '2024-01-07',
    readStatus: 'Не прочитан',
    filePath: '/prices/tools.xlsx',
  ),
  Document(
    description: 'Цены на рабочую одежду и спецодежду',
    fileName: 'Прайс-лист на одежду (январь 2024).xlsx',
    addedBy: 'maria.sidorova',
    addedDate: '2024-01-08',
    readStatus: 'Прочитан',
    filePath: '/prices/clothing.xlsx',
  ),
  Document(
    description: 'Цены на продукты питания и напитки',
    fileName: 'Прайс-лист на продукты (январь 2024).xlsx',
    addedBy: 'anna.morozova',
    addedDate: '2024-01-09',
    readStatus: 'Прочитан',
    filePath: '/prices/food.xlsx',
  ),
  Document(
    description: 'Специальные цены для оптовых покупателей',
    fileName: 'Оптовые цены (январь 2024).pdf',
    addedBy: 'ivan.petrov',
    addedDate: '2024-01-10',
    readStatus: 'Не прочитан',
    filePath: '/prices/wholesale.pdf',
  ),
  Document(
    description: 'Дилерские цены и условия',
    fileName: 'Прайс-лист для дилеров (январь 2024).xlsx',
    addedBy: 'maria.sidorova',
    addedDate: '2024-01-11',
    readStatus: 'Прочитан',
    filePath: '/prices/dealers.xlsx',
  ),
  Document(
    description: 'Актуальные скидки и акции',
    fileName: 'Сезонные скидки (январь 2024).pdf',
    addedBy: 'ivan.petrov',
    addedDate: '2024-01-12',
    readStatus: 'Прочитан',
    filePath: '/prices/discounts.pdf',
  ),
];

class Prices extends StatefulWidget {
  const Prices({super.key});

  @override
  _PricesState createState() => _PricesState();
}

class _PricesState extends State<Prices> {
  final List<Document> _orders = [...initialOrders];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }



  void _exportToCsv() async {
    try {
      String content = 'Описание;Имя файла;Кем добавлено;Дата добавления;Прочитан;Путь\n';
          
      for (var order in _orders) {
        content += '${order.description};${order.fileName};${order.addedBy};'
            '${order.addedDate};${order.readStatus};${order.filePath}\n';
      }
      
      String? directory = await FilePicker.platform.getDirectoryPath();
      if (directory != null) {
        final now = DateTime.now();
        final fileName = 'export_orders_${DateFormat('yyyyMMdd_HHmmss').format(now)}.csv';
        final file = File('$directory/$fileName');
        await file.writeAsString(content);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Файл сохранен как $fileName'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при экспорте: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _createNewOrder() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController descriptionController = TextEditingController();
        
        return AlertDialog(
          title: const Text('Новый документ'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Описание',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final now = DateTime.now();
                final formattedDate = _formatDate(now);
                
                setState(() {
                  _orders.add(Document(
                    description: descriptionController.text.isNotEmpty ? descriptionController.text : 'Новый документ',
                    fileName: '',
                    addedBy: 'Текущий пользователь',
                    addedDate: formattedDate,
                    readStatus: 'Не прочитан',
                    filePath: '',
                  ));
                });
                
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Новый документ создан'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Создать'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            _buildSearchAndControls(),
            Expanded(
              child: _buildDataTableView(),
            ),
          ],
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchAndControls() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Поиск...',
              hintText: 'Введите текст для поиска',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _searchController.clear(),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Всего записей: ${_getFilteredOrders().length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
                ),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Новый документ', style: TextStyle(fontSize: 13)),
                    onPressed: _createNewOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.file_download, size: 18),
                    label: const Text('Экспорт CSV', style: TextStyle(fontSize: 13)),
                    onPressed: _exportToCsv,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Document> _getFilteredOrders() {
    if (_searchQuery.isEmpty) return _orders;
    
    final query = _searchQuery.toLowerCase();
    return _orders.where((order) {
      return order.toMap().values.any(
            (value) => value.toLowerCase().contains(query),
          );
    }).toList();
  }

  Widget _buildDataTableView() {
    final filteredOrders = _getFilteredOrders();
    
    if (filteredOrders.isEmpty) {
      return const Center(
        child: Text(
          'Нет записей для отображения',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    final List<Map<String, dynamic>> ordersData = filteredOrders.map((order) => order.toMap()).toList();
    
    return UniversalResponsiveTable(
      data: ordersData,
      columns: ['Описание', 'Имя файла', 'Кем добавлено', 'Дата добавления', 'Прочитан'],
      columnKeys: ['Описание', 'Имя файла', 'Кем добавлено', 'Дата добавления', 'Прочитан'],
      onEdit: (index, field, value) {
        final order = filteredOrders[index];
        final updatedOrder = order.copyWithField(field, value.toString());
        setState(() {
          _orders[_orders.indexOf(order)] = updatedOrder;
        });
      },
      onDelete: (index) {
        setState(() {
          _orders.removeAt(index);
        });
      },
      onAdd: () {
        _createNewOrder();
      },
      primaryColor: Theme.of(context).colorScheme.primary,
      showFileUpload: true,
      columnTypes: {
        'Дата добавления': 'date',
      },
    );
  }
}
