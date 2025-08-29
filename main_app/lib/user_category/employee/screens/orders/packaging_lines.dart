import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

// Модель данных для заказа
class Order {
  String orderNumber;
  String opCode;
  String shipmentNumber;
  String shipmentDate;
  String line;
  String description;
  String packageType;
  String defaultPackages;
  String number;
  String fromLetters;
  String details;
  String createdAt;
  String status;
  String returnable;
  String city;
  String filePath;

  Order({
    required this.orderNumber,
    required this.opCode,
    required this.shipmentNumber,
    required this.shipmentDate,    
    required this.line,    
    required this.description,
    required this.packageType,
    required this.defaultPackages,
    required this.number,    
    required this.fromLetters,
    required this.details,
    required this.createdAt,
    required this.status,
    required this.returnable,
    required this.city,
    required this.filePath,
  });

  factory Order.fromMap(Map<String, String> map) {
    return Order(
      orderNumber: map['Номер заказа'] ?? '',
      opCode: map['Код ОП'] ?? '',
      shipmentNumber: map['Номер отгрузки'] ?? '',
      shipmentDate: map['Отгрузка'] ?? '',
      line: map['Линия'] ?? '',
      description: map['Описание'] ?? '',
      packageType: map['Тип упаковки'] ?? '',
      defaultPackages: map['Упаковка по умолчанию'] ?? '',
      number: map['Номер'] ?? '',
      fromLetters: map['Из букв'] ?? '',
      details: map['Деталей'] ?? '',
      createdAt: map['Создано'] ?? '',
      status: map['Общий статус'] ?? '',
      returnable: map['Возвратных'] ?? '',
      city: map['Город'] ?? '',
      filePath: map['Путь'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'Номер заказа': orderNumber,
      'Код ОП': opCode,
      'Номер отгрузки': shipmentNumber,
      'Отгрузка': shipmentDate,
      'Линия': line,
      'Описание': description,
      'Тип упаковки': packageType,
      'Упаковка по умолчанию': defaultPackages,
      'Номер': number,
      'Из букв': fromLetters,
      'Деталей': details,
      'Создано': createdAt,
      'Общий статус': status,
      'Возвратных': returnable,
      'Город': city,
      'Путь': filePath,
    };
  }
}

final List<Order> initialOrders = [
  Order(
    orderNumber: '105',
    opCode: 'ОфГр',
    shipmentNumber: '2943',
    shipmentDate: '06.06.2024',
    line: 'Линия 1',
    description: 'Прислали горизонтальные...',
    packageType: 'Коробка',
    defaultPackages: '2',
    number: '105',
    fromLetters: 'АБВ',
    details: '5',
    createdAt: '21.05.2024, 13:27',
    status: 'В план на отгрузку',
    returnable: '1',
    city: 'Москва',
    filePath: '',
  ),
];

class PackagingLines extends StatefulWidget {
  const PackagingLines({super.key});

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<PackagingLines> {
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
  
  final List<String> _packageTypeOptions = [
    'Коробка',
    'Паллета',
    'Конверт',
    'Пакет'
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
            _orders[index] = _orders[index].copyWith(
              description: fileName,
              filePath: file.path,
            );
          } else {
            _orders.add(Order(
              orderNumber: '---',
              opCode: '---',
              shipmentNumber: '---',
              shipmentDate: '---',
              line: '---',
              description: fileName,
              packageType: '---',
              defaultPackages: '---',
              number: '---',
              fromLetters: '---',
              details: '---',
              createdAt: _formatDate(DateTime.now()),
              status: 'Новый',
              returnable: '---',
              city: '---',
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
    ).then((_) {});
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
    if (field == 'Общий статус' || field == 'Тип упаковки') {
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
    
    if (field == 'Общий статус') {
      options = _statusOptions;
    } else if (field == 'Тип упаковки') {
      options = _packageTypeOptions;
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
      String content = 'Номер заказа;Код ОП;Номер отгрузки;Отгрузка;Линия;Описание;'
          'Тип упаковки;Упаковка по умолчанию;Номер;Из букв;Деталей;Создано;'
          'Общий статус;Возвратных;Город;Путь\n';
          
      for (var order in _orders) {
        content += '${order.orderNumber};${order.opCode};${order.shipmentNumber};'
            '${order.shipmentDate};${order.line};${order.description};'
            '${order.packageType};${order.defaultPackages};${order.number};'
            '${order.fromLetters};${order.details};${order.createdAt};'
            '${order.status};${order.returnable};${order.city};${order.filePath}\n';
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
        final TextEditingController orderNumberController = TextEditingController();
        final TextEditingController opCodeController = TextEditingController();
        final TextEditingController descriptionController = TextEditingController();
        
        return AlertDialog(
          title: const Text('Новый заказ'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: orderNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Номер заказа',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: opCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Код ОП',
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
                    orderNumber: orderNumberController.text.isNotEmpty ? orderNumberController.text : '---',
                    opCode: opCodeController.text.isNotEmpty ? opCodeController.text : '---',
                    shipmentNumber: '---',
                    shipmentDate: '---',
                    line: '---',
                    description: descriptionController.text.isNotEmpty ? descriptionController.text : '---',
                    packageType: '---',
                    defaultPackages: '---',
                    number: '---',
                    fromLetters: '---',
                    details: '---',
                    createdAt: _formatDate(DateTime.now()),
                    status: 'Новый',
                    returnable: '---',
                    city: '---',
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
    
    return Scrollbar(
      controller: _verticalScrollController,
      thumbVisibility: true,
      child: Scrollbar(
        controller: _horizontalScrollController,
        thumbVisibility: true,
        notificationPredicate: (notification) => notification.depth == 1,
        child: SingleChildScrollView(
          controller: _verticalScrollController,
          child: SingleChildScrollView(
            controller: _horizontalScrollController,
            scrollDirection: Axis.horizontal,
            child: DataTable(
              decoration: BoxDecoration(color: Colors.white),
              headingRowColor: MaterialStateProperty.all(Colors.blue[50]),
              dataRowMinHeight: 60,
              dataRowMaxHeight: 80,
              columnSpacing: 20, 
              horizontalMargin: 16,
              dividerThickness: 1,
              showCheckboxColumn: false,
              columns: [
                DataColumn(label: _buildSortableColumnHeader('Номер заказа')),
                DataColumn(label: _buildSortableColumnHeader('Код ОП')),
                DataColumn(label: _buildSortableColumnHeader('Номер отгрузки')),
                DataColumn(label: _buildSortableColumnHeader('Отгрузка')),
                DataColumn(label: _buildSortableColumnHeader('Линия')),
                DataColumn(label: _buildSortableColumnHeader('Описание')),
                DataColumn(label: _buildSortableColumnHeader('Тип упаковки')),
                DataColumn(label: _buildSortableColumnHeader('Упаковка по умолчанию')),
                DataColumn(label: _buildSortableColumnHeader('Номер')),
                DataColumn(label: _buildSortableColumnHeader('Из букв')),
                DataColumn(label: _buildSortableColumnHeader('Деталей')),
                DataColumn(label: _buildSortableColumnHeader('Создано')),
                DataColumn(label: _buildSortableColumnHeader('Общий статус')),
                DataColumn(label: _buildSortableColumnHeader('Возвратных')),
                DataColumn(label: _buildSortableColumnHeader('Город')),
                const DataColumn(
                  label: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Действия', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
              rows: filteredOrders.asMap().entries.map((entry) {
                final index = entry.key;
                final order = entry.value;
                return DataRow(
                  color: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (index % 2 == 0) return Colors.grey[100];
                      return null;
                    },
                  ),
                  cells: [
                    DataCell(_buildEditableCell(order.orderNumber, index, 'Номер заказа')),
                    DataCell(_buildEditableCell(order.opCode, index, 'Код ОП')),
                    DataCell(_buildEditableCell(order.shipmentNumber, index, 'Номер отгрузки')),
                    DataCell(_buildEditableCell(order.shipmentDate, index, 'Отгрузка')),
                    DataCell(_buildEditableCell(order.line, index, 'Линия')),
                    DataCell(_buildEditableCell(order.description, index, 'Описание')),
                    DataCell(_buildEditableCell(order.packageType, index, 'Тип упаковки')),
                    DataCell(_buildEditableCell(order.defaultPackages, index, 'Упаковка по умолчанию')),
                    DataCell(_buildEditableCell(order.number, index, 'Номер')),
                    DataCell(_buildEditableCell(order.fromLetters, index, 'Из букв')),
                    DataCell(_buildEditableCell(order.details, index, 'Деталей')),
                    DataCell(Text(order.createdAt)),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.status),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () => _showEditDialog(index, 'Общий статус', order.status),
                          child: Text(
                            order.status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    DataCell(_buildEditableCell(order.returnable, index, 'Возвратных')),
                    DataCell(_buildEditableCell(order.city, index, 'Город')),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (order.filePath.isEmpty)
                            IconButton(
                              icon: const Icon(Icons.upload, color: Colors.blue),
                              onPressed: () => _pickFile(index),
                              tooltip: 'Загрузить файл',
                            )
                          else
                            IconButton(
                              icon: const Icon(Icons.download, color: Colors.green),
                              onPressed: () => _downloadFile(order.filePath),
                              tooltip: 'Скачать файл',
                            ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeItem(index),
                            tooltip: 'Удалить',
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
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
    String? orderNumber,
    String? opCode,
    String? shipmentNumber,
    String? shipmentDate,
    String? line,
    String? description,
    String? packageType,
    String? defaultPackages,
    String? number,
    String? fromLetters,
    String? details,
    String? createdAt,
    String? status,
    String? returnable,
    String? city,
    String? filePath,
  }) {
    return Order(
      orderNumber: orderNumber ?? this.orderNumber,
      opCode: opCode ?? this.opCode,
      shipmentNumber: shipmentNumber ?? this.shipmentNumber,
      shipmentDate: shipmentDate ?? this.shipmentDate,
      line: line ?? this.line,
      description: description ?? this.description,
      packageType: packageType ?? this.packageType,
      defaultPackages: defaultPackages ?? this.defaultPackages,
      number: number ?? this.number,
      fromLetters: fromLetters ?? this.fromLetters,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      returnable: returnable ?? this.returnable,
      city: city ?? this.city,
      filePath: filePath ?? this.filePath,
    );
  }

  Order copyWithField(String field, String value) {
    switch (field) {
      case 'Номер заказа':
        return copyWith(orderNumber: value);
      case 'Код ОП':
        return copyWith(opCode: value);
      case 'Номер отгрузки':
        return copyWith(shipmentNumber: value);
      case 'Отгрузка':
        return copyWith(shipmentDate: value);
      case 'Линия':
        return copyWith(line: value);
      case 'Описание':
        return copyWith(description: value);
      case 'Тип упаковки':
        return copyWith(packageType: value);
      case 'Упаковка по умолчанию':
        return copyWith(defaultPackages: value);
      case 'Номер':
        return copyWith(number: value);
      case 'Из букв':
        return copyWith(fromLetters: value);
      case 'Деталей':
        return copyWith(details: value);
      case 'Создано':
        return copyWith(createdAt: value);
      case 'Общий статус':
        return copyWith(status: value);
      case 'Возвратных':
        return copyWith(returnable: value);
      case 'Город':
        return copyWith(city: value);
      default:
        return this;
    }
  }
}