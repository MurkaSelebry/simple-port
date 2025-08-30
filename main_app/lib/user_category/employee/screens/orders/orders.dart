import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../common/universal_responsive_table.dart';

// Модель данных для заказа
class Order {
  String opCode;
  String number;
  String type;
  String description;
  String shipmentNumber;
  String shipmentDate;
  String desiredDate;
  String plannedDate;
  String creator;
  String createdAt;
  String status;
  String salon;
  String designer;
  String warehouse;
  String production;
  String logistics;
  String payment;
  String filePath;

  Order({
    required this.opCode,
    required this.number,
    required this.type,
    required this.description,
    required this.shipmentNumber,
    required this.shipmentDate,
    required this.desiredDate,
    required this.plannedDate,
    required this.creator,
    required this.createdAt,
    required this.status,
    required this.salon,
    required this.designer,
    required this.warehouse,
    required this.production,
    required this.logistics,
    required this.payment,
    required this.filePath,
  });

  factory Order.fromMap(Map<String, String> map) {
    return Order(
      opCode: map['Код ОП'] ?? '',
      number: map['Номер'] ?? '',
      type: map['Тип'] ?? '',
      description: map['Описание'] ?? '',
      shipmentNumber: map['№ отгрузки'] ?? '',
      shipmentDate: map['Отгрузка'] ?? '',
      desiredDate: map['Желаемая дата'] ?? '',
      plannedDate: map['Планируемая дата'] ?? '',
      creator: map['Создал'] ?? '',
      createdAt: map['Создано'] ?? '',
      status: map['Статус'] ?? '',
      salon: map['Салон'] ?? '',
      designer: map['Конструктор'] ?? '',
      warehouse: map['Склад комплектации'] ?? '',
      production: map['Производство'] ?? '',
      logistics: map['Логистика'] ?? '',
      payment: map['Оплата'] ?? '',
      filePath: map['Путь'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'Код ОП': opCode,
      'Номер': number,
      'Тип': type,
      'Описание': description,
      '№ отгрузки': shipmentNumber,
      'Отгрузка': shipmentDate,
      'Желаемая дата': desiredDate,
      'Планируемая дата': plannedDate,
      'Создал': creator,
      'Создано': createdAt,
      'Статус': status,
      'Салон': salon,
      'Конструктор': designer,
      'Склад комплектации': warehouse,
      'Производство': production,
      'Логистика': logistics,
      'Оплата': payment,
      'Путь': filePath,
    };
  }
}

final List<Order> initialOrders = [
  Order(
    opCode: 'OP001',
    number: 'ORD-2024-001',
    type: 'Заказ',
    description: 'Кухня "Модерн" - современный кухонный гарнитур',
    shipmentNumber: 'SH-2024-001',
    shipmentDate: '2024-01-15',
    desiredDate: '2024-01-20',
    plannedDate: '2024-01-20',
    creator: 'ivan.petrov',
    createdAt: '2024-01-10',
    status: 'В обработке',
    salon: 'Салон "Модерн"',
    designer: 'maria.sidorova',
    warehouse: 'Готов',
    production: 'В производстве',
    logistics: '...',
    payment: 'Оплачено',
    filePath: '/files/order1.pdf',
  ),
  Order(
    opCode: 'OP002',
    number: 'ORD-2024-002',
    type: 'Заказ',
    description: 'Кухня "Классика" - классический кухонный гарнитур',
    shipmentNumber: 'SH-2024-002',
    shipmentDate: '2024-01-16',
    desiredDate: '2024-01-22',
    plannedDate: '2024-01-22',
    creator: 'dmitry.kozlov',
    createdAt: '2024-01-11',
    status: 'Отгружено на фабрике',
    salon: 'Салон "Классика"',
    designer: 'alex.kuznetsov',
    warehouse: 'Отгружено',
    production: 'Завершено',
    logistics: '...',
    payment: 'Оплачено',
    filePath: '/files/order2.pdf',
  ),
  Order(
    opCode: 'OP003',
    number: 'ORD-2024-003',
    type: 'Заказ',
    description: 'Кухня "Прованс" - кухня в стиле прованс',
    shipmentNumber: 'SH-2024-003',
    shipmentDate: '2024-01-17',
    desiredDate: '2024-01-25',
    plannedDate: '2024-01-25',
    creator: 'maria.sidorova',
    createdAt: '2024-01-12',
    status: 'Новый',
    salon: 'Салон "Прованс"',
    designer: 'anna.morozova',
    warehouse: 'В ожидании',
    production: 'Планируется',
    logistics: '...',
    payment: 'Частично оплачено',
    filePath: '/files/order3.pdf',
  ),
  Order(
    opCode: 'OP004',
    number: 'ORD-2024-004',
    type: 'Заказ',
    description: 'Кухня "Лофт" - кухня в стиле лофт',
    shipmentNumber: 'SH-2024-004',
    shipmentDate: '2024-01-18',
    desiredDate: '2024-01-28',
    plannedDate: '2024-01-28',
    creator: 'alex.kuznetsov',
    createdAt: '2024-01-13',
    status: 'В обработке',
    salon: 'Салон "Лофт"',
    designer: 'ivan.petrov',
    warehouse: 'Готов',
    production: 'В производстве',
    logistics: '...',
    payment: 'Оплачено',
    filePath: '/files/order4.pdf',
  ),
  Order(
    opCode: 'OP005',
    number: 'ORD-2024-005',
    type: 'Заказ',
    description: 'Кухня "Минимализм" - минималистичная кухня',
    shipmentNumber: 'SH-2024-005',
    shipmentDate: '2024-01-19',
    desiredDate: '2024-01-30',
    plannedDate: '2024-01-30',
    creator: 'anna.morozova',
    createdAt: '2024-01-14',
    status: 'Отгружено на фабрике',
    salon: 'Салон "Минимализм"',
    designer: 'dmitry.kozlov',
    warehouse: 'Отгружено',
    production: 'Завершено',
    logistics: '...',
    payment: 'Оплачено',
    filePath: '/files/order5.pdf',
  ),
  Order(
    opCode: 'OP006',
    number: 'ORD-2024-006',
    type: 'Заказ',
    description: 'Кухня "Скандинавия" - кухня в скандинавском стиле',
    shipmentNumber: 'SH-2024-006',
    shipmentDate: '2024-01-20',
    desiredDate: '2024-02-02',
    plannedDate: '2024-02-02',
    creator: 'ivan.petrov',
    createdAt: '2024-01-15',
    status: 'В обработке',
    salon: 'Салон "Скандинавия"',
    designer: 'maria.sidorova',
    warehouse: 'Готов',
    production: 'В производстве',
    logistics: '...',
    payment: 'Оплачено',
    filePath: '/files/order6.pdf',
  ),
  Order(
    opCode: 'OP007',
    number: 'ORD-2024-007',
    type: 'Заказ',
    description: 'Кухня "Хай-тек" - кухня в стиле хай-тек',
    shipmentNumber: 'SH-2024-007',
    shipmentDate: '2024-01-21',
    desiredDate: '2024-02-05',
    plannedDate: '2024-02-05',
    creator: 'dmitry.kozlov',
    createdAt: '2024-01-16',
    status: 'Новый',
    salon: 'Салон "Хай-тек"',
    designer: 'alex.kuznetsov',
    warehouse: 'В ожидании',
    production: 'Планируется',
    logistics: '...',
    payment: 'Ожидает оплаты',
    filePath: '/files/order7.pdf',
  ),
  Order(
    opCode: 'OP008',
    number: 'ORD-2024-008',
    type: 'Заказ',
    description: 'Кухня "Кантри" - кухня в деревенском стиле',
    shipmentNumber: 'SH-2024-008',
    shipmentDate: '2024-01-22',
    desiredDate: '2024-02-08',
    plannedDate: '2024-02-08',
    creator: 'maria.sidorova',
    createdAt: '2024-01-17',
    status: 'В обработке',
    salon: 'Салон "Кантри"',
    designer: 'anna.morozova',
    warehouse: 'Готов',
    production: 'В производстве',
    logistics: '...',
    payment: 'Оплачено',
    filePath: '/files/order8.pdf',
  ),
  Order(
    opCode: 'OP009',
    number: 'ORD-2024-009',
    type: 'Заказ',
    description: 'Кухня "Арт-деко" - кухня в стиле арт-деко',
    shipmentNumber: 'SH-2024-009',
    shipmentDate: '2024-01-23',
    desiredDate: '2024-02-10',
    plannedDate: '2024-02-10',
    creator: 'alex.kuznetsov',
    createdAt: '2024-01-18',
    status: 'Отгружено на фабрике',
    salon: 'Салон "Арт-деко"',
    designer: 'ivan.petrov',
    warehouse: 'Отгружено',
    production: 'Завершено',
    logistics: '...',
    payment: 'Оплачено',
    filePath: '/files/order9.pdf',
  ),
  Order(
    opCode: 'OP010',
    number: 'ORD-2024-010',
    type: 'Заказ',
    description: 'Кухня "Неоклассика" - кухня в неоклассическом стиле',
    shipmentNumber: 'SH-2024-010',
    shipmentDate: '2024-01-24',
    desiredDate: '2024-02-12',
    plannedDate: '2024-02-12',
    creator: 'ivan.petrov',
    createdAt: '2024-01-19',
    status: 'Новый',
    salon: 'Салон "Неоклассика"',
    designer: 'maria.sidorova',
    warehouse: 'В ожидании',
    production: 'Планируется',
    logistics: '...',
    payment: 'Частично оплачено',
    filePath: '/files/order10.pdf',
  ),
];

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final List<Order> _orders = [...initialOrders];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isAscending = true;
  String _sortField = 'Код ОП';
  bool _isLoading = false;
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  // Варианты для выпадающих списков
  final List<String> _statusOptions = [
    'Новый',
    'В обработке',
    'В производстве',
    'В план на отгрузку',
    'Готов',
    'Отменен'
  ];
  
  final List<String> _typeOptions = [
    'Рекламация',
    'Заказ',
    'Доп. заказ',
    'Срочный заказ'
  ];
  
  final List<String> _paymentOptions = [
    'Не сверено',
    'Оплачено',
    'Частично оплачено',
    'Ожидает оплаты'
  ];

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
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy, HH:mm').format(date);
  }

  Future<void> _pickFile(int? index) async {
    setState(() {
      _isLoading = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        final fileName = result.files.single.name;

        setState(() {
          if (index != null) {
            // Обновляем существующий заказ
            _orders[index] = _orders[index].copyWith(
              description: fileName,
              filePath: file.path,
            );
          } else {
            // Добавляем новый заказ
            _orders.add(Order(
              opCode: '---',
              number: '---',
              type: '---',
              description: fileName,
              shipmentNumber: '---',
              shipmentDate: '---',
              desiredDate: '---',
              plannedDate: '---',
              creator: 'Пользователь',
              createdAt: _formatDate(DateTime.now()),
              status: 'Новый',
              salon: '---',
              designer: '---',
              warehouse: '---',
              production: '---',
              logistics: '---',
              payment: '---',
              filePath: file.path,
            ));
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Файл "$fileName" успешно ${index != null ? 'обновлен' : 'добавлен'}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _removeItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение удаления'),
          content: const Text('Вы уверены, что хотите удалить этот элемент?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _orders.removeAt(index);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Элемент удален'),
                    backgroundColor: Colors.blue,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Удалить', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    ).then((_) {}); // Закрываем диалог сразу после нажатия
  }

  Future<void> _downloadFile(String filePath) async {
    if (filePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Нет файла для скачивания'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final file = File(filePath);
      if (await file.exists()) {
        String? directory = await FilePicker.platform.getDirectoryPath();

        if (directory != null) {
          final fileName = file.uri.pathSegments.last;
          final downloadPath = '$directory/$fileName';
          await file.copy(downloadPath);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Файл сохранен в: $downloadPath'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Файл не найден: $filePath'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleSort(String field) {
    setState(() {
      _isAscending = _sortField == field ? !_isAscending : true;
      _sortField = field;

      _orders.sort((a, b) {
        final valueA = a.toMap()[field] ?? '';
        final valueB = b.toMap()[field] ?? '';
        return _isAscending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
      });
    });
  }

  Widget _buildEditableCell(String value, int index, String field) {
    return InkWell(
      onTap: () => _showEditDialog(index, field, value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          value.isEmpty ? '---' : value,
          style: TextStyle(
            color: value.isEmpty ? Colors.grey : Colors.black87,
          ),
        ),
      ),
    );
  }

  void _showEditDialog(int index, String field, String initialValue) {
    if (field == 'Статус' || field == 'Тип' || field == 'Оплата') {
      _showDropdownDialog(index, field, initialValue);
      return;
    }

    final TextEditingController controller = TextEditingController(text: initialValue);
    final FocusNode focusNode = FocusNode();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Редактировать $field'),
          content: TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: field,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            maxLines: field == 'Описание' ? 3 : 1,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedOrder = _orders[index].copyWithField(field, controller.text);
                setState(() {
                  _orders[index] = updatedOrder;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  void _showDropdownDialog(int index, String field, String initialValue) {
    List<String> options = [];
    
    if (field == 'Статус') {
      options = _statusOptions;
    } else if (field == 'Тип') {
      options = _typeOptions;
    } else if (field == 'Оплата') {
      options = _paymentOptions;
    }

    String selectedValue = initialValue.isEmpty && options.isNotEmpty ? options.first : initialValue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Выберите $field'),
              content: SizedBox(
                width: double.maxFinite,
                child: DropdownButton<String>(
                  value: selectedValue,
                  isExpanded: true,
                  items: options.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Отмена'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final updatedOrder = _orders[index].copyWithField(field, selectedValue);
                    setState(() {
                      _orders[index] = updatedOrder;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Сохранить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSortableColumnHeader(String fieldName) {
    return GestureDetector(
      onTap: () => _toggleSort(fieldName),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              fieldName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            if (_sortField == fieldName)
              Icon(
                _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
                color: Colors.blue,
              ),
          ],
        ),
      ),
    );
  }

  void _exportToCsv() async {
    try {
      String content = 'Код ОП;Номер;Тип;Описание;№ отгрузки;Отгрузка;Желаемая дата;'
          'Планируемая дата;Создал;Создано;Статус;Салон;Конструктор;'
          'Склад комплектации;Производство;Логистика;Оплата\n';
          
      for (var order in _orders) {
        content += '${order.opCode};${order.number};${order.type};${order.description};'
            '${order.shipmentNumber};${order.shipmentDate};${order.desiredDate};'
            '${order.plannedDate};${order.creator};${order.createdAt};${order.status};'
            '${order.salon};${order.designer};${order.warehouse};${order.production};'
            '${order.logistics};${order.payment}\n';
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
        final TextEditingController opCodeController = TextEditingController();
        final TextEditingController numberController = TextEditingController();
        final TextEditingController typeController = TextEditingController();
        final TextEditingController descriptionController = TextEditingController();
        
        return AlertDialog(
          title: const Text('Новый заказ'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: opCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Код ОП',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: numberController,
                  decoration: const InputDecoration(
                    labelText: 'Номер',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: typeController,
                  decoration: const InputDecoration(
                    labelText: 'Тип',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
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
                setState(() {
                  _orders.add(Order(
                    opCode: opCodeController.text.isNotEmpty ? opCodeController.text : '---',
                    number: numberController.text.isNotEmpty ? numberController.text : '---',
                    type: typeController.text.isNotEmpty ? typeController.text : '---',
                    description: descriptionController.text.isNotEmpty ? descriptionController.text : '---',
                    shipmentNumber: '---',
                    shipmentDate: '---',
                    desiredDate: '---',
                    plannedDate: '---',
                    creator: 'Пользователь',
                    createdAt: _formatDate(DateTime.now()),
                    status: 'Новый',
                    salon: '---',
                    designer: '---',
                    warehouse: '---',
                    production: '---',
                    logistics: '---',
                    payment: '---',
                    filePath: '',
                  ));
                });
                
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Новый заказ создан'),
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
      padding: const EdgeInsets.all(16.0),
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
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Всего записей: ${_getFilteredOrders().length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Новый заказ'),
                    onPressed: _createNewOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  // const SizedBox(width: 8),
                  // ElevatedButton.icon(
                  //   icon: const Icon(Icons.upload_file),
                  //   label: const Text('Добавить файл'),
                  //   onPressed: () => _pickFile(null),
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.green,
                  //     foregroundColor: Colors.white,
                  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  //   ),
                  // ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.file_download),
                    label: const Text('Экспорт CSV'),
                    onPressed: _exportToCsv,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

  List<Order> _getFilteredOrders() {
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
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      );
    }

    final List<Map<String, dynamic>> ordersData = filteredOrders.map((order) => order.toMap()).toList();
    
    return UniversalResponsiveTable(
      data: ordersData,
      columns: [
        'Код ОП', 'Номер', 'Тип', 'Описание', '№ отгрузки', 'Отгрузка', 
        'Желаемая дата', 'Планируемая дата', 'Создал', 'Создано', 'Статус',
        'Салон', 'Конструктор', 'Склад комплектации', 'Производство', 'Логистика', 'Оплата'
      ],
      columnKeys: [
        'Код ОП', 'Номер', 'Тип', 'Описание', '№ отгрузки', 'Отгрузка', 
        'Желаемая дата', 'Планируемая дата', 'Создал', 'Создано', 'Статус',
        'Салон', 'Конструктор', 'Склад комплектации', 'Производство', 'Логистика', 'Оплата'
      ],
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
        'Отгрузка': 'date',
        'Желаемая дата': 'date',
        'Планируемая дата': 'date',
        'Создано': 'date',
        'Статус': 'status',
      },
      statusOptions: {
        'Статус': ['Новый', 'В обработке', 'В производстве', 'В план на отгрузку', 'Отгружен', 'Завершен'],
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'новый':
        return Colors.blue;
      case 'в обработке':
        return Colors.blue[300]!;
      case 'в производстве':
        return Colors.orange;
      case 'в план на отгрузку':
        return Colors.purple;
      case 'готов':
        return Colors.green;
      case 'отменен':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }
}

extension OrderCopyWith on Order {
  Order copyWith({
    String? opCode,
    String? number,
    String? type,
    String? description,
    String? shipmentNumber,
    String? shipmentDate,
    String? desiredDate,
    String? plannedDate,
    String? creator,
    String? createdAt,
    String? status,
    String? salon,
    String? designer,
    String? warehouse,
    String? production,
    String? logistics,
    String? payment,
    String? filePath,
  }) {
    return Order(
      opCode: opCode ?? this.opCode,
      number: number ?? this.number,
      type: type ?? this.type,
      description: description ?? this.description,
      shipmentNumber: shipmentNumber ?? this.shipmentNumber,
      shipmentDate: shipmentDate ?? this.shipmentDate,
      desiredDate: desiredDate ?? this.desiredDate,
      plannedDate: plannedDate ?? this.plannedDate,
      creator: creator ?? this.creator,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      salon: salon ?? this.salon,
      designer: designer ?? this.designer,
      warehouse: warehouse ?? this.warehouse,
      production: production ?? this.production,
      logistics: logistics ?? this.logistics,
      payment: payment ?? this.payment,
      filePath: filePath ?? this.filePath,
    );
  }

  Order copyWithField(String field, String value) {
    switch (field) {
      case 'Код ОП':
        return copyWith(opCode: value);
      case 'Номер':
        return copyWith(number: value);
      case 'Тип':
        return copyWith(type: value);
      case 'Описание':
        return copyWith(description: value);
      case '№ отгрузки':
        return copyWith(shipmentNumber: value);
      case 'Отгрузка':
        return copyWith(shipmentDate: value);
      case 'Желаемая дата':
        return copyWith(desiredDate: value);
      case 'Планируемая дата':
        return copyWith(plannedDate: value);
      case 'Статус':
        return copyWith(status: value);
      case 'Салон':
        return copyWith(salon: value);
      case 'Конструктор':
        return copyWith(designer: value);
      case 'Склад комплектации':
        return copyWith(warehouse: value);
      case 'Производство':
        return copyWith(production: value);
      case 'Логистика':
        return copyWith(logistics: value);
      case 'Оплата':
        return copyWith(payment: value);
      default:
        return this;
    }
  }
}
