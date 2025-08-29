import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

// Модель данных для заказа
class Order {
  String orderNumber;
  String status;
  String opCode;
  String shipmentNumber;
  String shipmentDate;
  String city;
  String plannedDelivery;
  String packageShipmentNumber;
  String packageShipmentDate;
  String createdAt;
  String packageStatus;
  String changeType;
  String name;
  String description;
  String packageType;
  String lineNumber;
  String fromLetters;
  String details;
  String generalStatus;
  String filePath;

  Order({
    required this.orderNumber,
    required this.status,
    required this.opCode,
    required this.shipmentNumber,
    required this.shipmentDate,
    required this.city,
    required this.plannedDelivery,
    required this.packageShipmentNumber,
    required this.packageShipmentDate,
    required this.createdAt,
    required this.packageStatus,
    required this.changeType,
    required this.name,
    required this.description,
    required this.packageType,
    required this.lineNumber,
    required this.fromLetters,
    required this.details,
    required this.generalStatus,
    required this.filePath,
  });

  factory Order.fromMap(Map<String, String> map) {
    return Order(
      orderNumber: map['Номер'] ?? '',
      status: map['Статус'] ?? '',
      opCode: map['Код ОП'] ?? '',
      shipmentNumber: map['№ отгрузки'] ?? '',
      shipmentDate: map['Отгрузка'] ?? '',
      city: map['Город'] ?? '',
      plannedDelivery: map['Планируемая поставка'] ?? '',
      packageShipmentNumber: map['№ отгрузки (Упаковка)'] ?? '',
      packageShipmentDate: map['Отгрузка (Упаковка)'] ?? '',
      createdAt: map['Создано'] ?? '',
      packageStatus: map['Статус (Упаковка)'] ?? '',
      changeType: map['Тип изменения'] ?? '',
      name: map['Название'] ?? '',
      description: map['Описание'] ?? '',
      packageType: map['Тип упаковки'] ?? '',
      lineNumber: map['Номер (Линия)'] ?? '',
      fromLetters: map['Из букв'] ?? '',
      details: map['Детали'] ?? '',
      generalStatus: map['Общий статус'] ?? '',
      filePath: map['Путь'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'Номер': orderNumber,
      'Статус': status,
      'Код ОП': opCode,
      '№ отгрузки': shipmentNumber,
      'Отгрузка': shipmentDate,
      'Город': city,
      'Планируемая поставка': plannedDelivery,
      '№ отгрузки (Упаковка)': packageShipmentNumber,
      'Отгрузка (Упаковка)': packageShipmentDate,
      'Создано': createdAt,
      'Статус (Упаковка)': packageStatus,
      'Тип изменения': changeType,
      'Название': name,
      'Описание': description,
      'Тип упаковки': packageType,
      'Номер (Линия)': lineNumber,
      'Из букв': fromLetters,
      'Детали': details,
      'Общий статус': generalStatus,
      'Путь': filePath,
    };
  }
}

final List<Order> initialOrders = [
  Order(
    orderNumber: '105',
    status: 'Активен',
    opCode: 'ОфГр',
    shipmentNumber: '2943',
    shipmentDate: '06.06.2024',
    city: 'Москва',
    plannedDelivery: '10.06.2024',
    packageShipmentNumber: '2943-A',
    packageShipmentDate: '08.06.2024',
    createdAt: '21.05.2024, 13:27',
    packageStatus: 'В обработке',
    changeType: 'Обновление',
    name: 'ШНК800',
    description: 'Прислали горизонтальные...',
    packageType: 'Коробка',
    lineNumber: '105',
    fromLetters: 'АБВ',
    details: '5',
    generalStatus: 'В план на отгрузку',
    filePath: '',
  ),
];

class Packaging extends StatefulWidget {
  const Packaging({Key? key}) : super(key: key);

  @override
  _PackagingState createState() => _PackagingState();
}

class _PackagingState extends State<Packaging> {
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
    'Отменен',
    'Активен'
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
            // Обновляем существующую запись
            _orders[index] = Order(
              orderNumber: _orders[index].orderNumber,
              status: _orders[index].status,
              opCode: _orders[index].opCode,
              shipmentNumber: _orders[index].shipmentNumber,
              shipmentDate: _orders[index].shipmentDate,
              city: _orders[index].city,
              plannedDelivery: _orders[index].plannedDelivery,
              packageShipmentNumber: _orders[index].packageShipmentNumber,
              packageShipmentDate: _orders[index].packageShipmentDate,
              createdAt: _orders[index].createdAt,
              packageStatus: _orders[index].packageStatus,
              changeType: _orders[index].changeType,
              name: fileName,
              description: _orders[index].description,
              packageType: _orders[index].packageType,
              lineNumber: _orders[index].lineNumber,
              fromLetters: _orders[index].fromLetters,
              details: _orders[index].details,
              generalStatus: _orders[index].generalStatus,
              filePath: file.path,
            );
          } else {
            // Добавляем новую запись
            _orders.add(Order(
              orderNumber: '---',
              status: 'Новый',
              opCode: '---',
              shipmentNumber: '---',
              shipmentDate: '---',
              city: '---',
              plannedDelivery: '---',
              packageShipmentNumber: '---',
              packageShipmentDate: '---',
              createdAt: _formatDate(DateTime.now()),
              packageStatus: 'Новый',
              changeType: '---',
              name: fileName,
              description: '---',
              packageType: 'Коробка',
              lineNumber: '---',
              fromLetters: '---',
              details: '---',
              generalStatus: 'Новый',
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
    );
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
    if (field == 'Общий статус' || field == 'Статус' || field == 'Статус (Упаковка)' || field == 'Тип упаковки') {
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
                final updatedOrder = _updateOrderField(index, field, controller.text);
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
    
    if (field == 'Общий статус' || field == 'Статус' || field == 'Статус (Упаковка)') {
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
                    final updatedOrder = _updateOrderField(index, field, selectedValue);
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

  Order _updateOrderField(int index, String field, String value) {
    Order order = _orders[index];
    
    switch (field) {
      case 'Номер':
        return Order(
          orderNumber: value,
          status: order.status,
          opCode: order.opCode,
          shipmentNumber: order.shipmentNumber,
          shipmentDate: order.shipmentDate,
          city: order.city,
          plannedDelivery: order.plannedDelivery,
          packageShipmentNumber: order.packageShipmentNumber,
          packageShipmentDate: order.packageShipmentDate,
          createdAt: order.createdAt,
          packageStatus: order.packageStatus,
          changeType: order.changeType,
          name: order.name,
          description: order.description,
          packageType: order.packageType,
          lineNumber: order.lineNumber,
          fromLetters: order.fromLetters,
          details: order.details,
          generalStatus: order.generalStatus,
          filePath: order.filePath,
        );
      case 'Статус':
        return Order(
          orderNumber: order.orderNumber,
          status: value,
          opCode: order.opCode,
          shipmentNumber: order.shipmentNumber,
          shipmentDate: order.shipmentDate,
          city: order.city,
          plannedDelivery: order.plannedDelivery,
          packageShipmentNumber: order.packageShipmentNumber,
          packageShipmentDate: order.packageShipmentDate,
          createdAt: order.createdAt,
          packageStatus: order.packageStatus,
          changeType: order.changeType,
          name: order.name,
          description: order.description,
          packageType: order.packageType,
          lineNumber: order.lineNumber,
          fromLetters: order.fromLetters,
          details: order.details,
          generalStatus: order.generalStatus,
          filePath: order.filePath,
        );
      // Добавьте аналогичные кейсы для всех остальных полей
      case 'Код ОП':
        return Order(
          orderNumber: order.orderNumber,
          status: order.status,
          opCode: value,
          shipmentNumber: order.shipmentNumber,
          shipmentDate: order.shipmentDate,
          city: order.city,
          plannedDelivery: order.plannedDelivery,
          packageShipmentNumber: order.packageShipmentNumber,
          packageShipmentDate: order.packageShipmentDate,
          createdAt: order.createdAt,
          packageStatus: order.packageStatus,
          changeType: order.changeType,
          name: order.name,
          description: order.description,
          packageType: order.packageType,
          lineNumber: order.lineNumber,
          fromLetters: order.fromLetters,
          details: order.details,
          generalStatus: order.generalStatus,
          filePath: order.filePath,
        );
      case 'Описание':
        return Order(
          orderNumber: order.orderNumber,
          status: order.status,
          opCode: order.opCode,
          shipmentNumber: order.shipmentNumber,
          shipmentDate: order.shipmentDate,
          city: order.city,
          plannedDelivery: order.plannedDelivery,
          packageShipmentNumber: order.packageShipmentNumber,
          packageShipmentDate: order.packageShipmentDate,
          createdAt: order.createdAt,
          packageStatus: order.packageStatus,
          changeType: order.changeType,
          name: order.name,
          description: value,
          packageType: order.packageType,
          lineNumber: order.lineNumber,
          fromLetters: order.fromLetters,
          details: order.details,
          generalStatus: order.generalStatus,
          filePath: order.filePath,
        );
      case 'Общий статус':
        return Order(
          orderNumber: order.orderNumber,
          status: order.status,
          opCode: order.opCode,
          shipmentNumber: order.shipmentNumber,
          shipmentDate: order.shipmentDate,
          city: order.city,
          plannedDelivery: order.plannedDelivery,
          packageShipmentNumber: order.packageShipmentNumber,
          packageShipmentDate: order.packageShipmentDate,
          createdAt: order.createdAt,
          packageStatus: order.packageStatus,
          changeType: order.changeType,
          name: order.name,
          description: order.description,
          packageType: order.packageType,
          lineNumber: order.lineNumber,
          fromLetters: order.fromLetters,
          details: order.details,
          generalStatus: value,
          filePath: order.filePath,
        );
      // Добавьте остальные поля по аналогии
      default:
        return order;
    }
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
      // Заголовки
      String content = 'Номер;Статус;Код ОП;№ отгрузки;Отгрузка;Город;Планируемая поставка;'
          '№ отгрузки (Упаковка);Отгрузка (Упаковка);Создано;Статус (Упаковка);Тип изменения;'
          'Название;Описание;Тип упаковки;Номер (Линия);Из букв;Детали;Общий статус;Путь\n';
          
      // Данные
      for (var order in _orders) {
        content += '${order.orderNumber};${order.status};${order.opCode};'
            '${order.shipmentNumber};${order.shipmentDate};${order.city};${order.plannedDelivery};'
            '${order.packageShipmentNumber};${order.packageShipmentDate};${order.createdAt};'
            '${order.packageStatus};${order.changeType};${order.name};${order.description};'
            '${order.packageType};${order.lineNumber};${order.fromLetters};${order.details};'
            '${order.generalStatus};${order.filePath}\n';
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
        final TextEditingController nameController = TextEditingController();
        
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
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Название',
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
                    status: 'Новый',
                    opCode: opCodeController.text.isNotEmpty ? opCodeController.text : '---',
                    shipmentNumber: '---',
                    shipmentDate: '---',
                    city: '---',
                    plannedDelivery: '---',
                    packageShipmentNumber: '---',
                    packageShipmentDate: '---',
                    createdAt: _formatDate(DateTime.now()),
                    packageStatus: 'Новый',
                    changeType: '---',
                    name: nameController.text.isNotEmpty ? nameController.text : '---',
                    description: descriptionController.text.isNotEmpty ? descriptionController.text : '---',
                    packageType: 'Коробка',
                    lineNumber: '---',
                    fromLetters: '---',
                    details: '---',
                    generalStatus: 'Новый',
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
        style: TextStyle(fontSize: 18, color: Colors.grey),
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
              // Группа "Заказ"
              DataColumn(
                label: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Заказ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                    ),
                  ),
                ),
              DataColumn(label: _buildSortableColumnHeader('Номер')),
              DataColumn(label: _buildSortableColumnHeader('Статус')),
              DataColumn(label: _buildSortableColumnHeader('Код ОП')),
              
              // Группа "Линия"
              DataColumn(
                label: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Линия',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                    ),
                  ),
                ),
              DataColumn(label: _buildSortableColumnHeader('№ отгрузки')),
              DataColumn(label: _buildSortableColumnHeader('Отгрузка')),
              DataColumn(label: _buildSortableColumnHeader('Город')),
              DataColumn(label: _buildSortableColumnHeader('Планируемая поставка')),
              
              // Группа "Упаковка"
              DataColumn(
                label: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Упаковка',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                    ),
                  ),
                ),
              DataColumn(label: _buildSortableColumnHeader('№ отгрузки (Упаковка)')),
              DataColumn(label: _buildSortableColumnHeader('Отгрузка (Упаковка)')),
              DataColumn(label: _buildSortableColumnHeader('Создано')),
              DataColumn(label: _buildSortableColumnHeader('Статус (Упаковка)')),
              DataColumn(label: _buildSortableColumnHeader('Тип изменения')),
              DataColumn(label: _buildSortableColumnHeader('Название')),
              DataColumn(label: _buildSortableColumnHeader('Описание')),
              DataColumn(label: _buildSortableColumnHeader('Тип упаковки')),
              DataColumn(label: _buildSortableColumnHeader('Номер (Линия)')),
              DataColumn(label: _buildSortableColumnHeader('Из букв')),
              DataColumn(label: _buildSortableColumnHeader('Детали')),
              DataColumn(label: _buildSortableColumnHeader('Общий статус')),
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
                  // Пустая ячейка для группы "Заказ"
                  const DataCell(SizedBox.shrink()),
                  DataCell(_buildEditableCell(order.orderNumber, index, 'Номер')),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () => _showEditDialog(index, 'Статус', order.status),
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
                  DataCell(_buildEditableCell(order.opCode, index, 'Код ОП')),
                  
                  // Пустая ячейка для группы "Линия"
                  const DataCell(SizedBox.shrink()),
                  DataCell(_buildEditableCell(order.shipmentNumber, index, '№ отгрузки')),
                  DataCell(_buildEditableCell(order.shipmentDate, index, 'Отгрузка')),
                  DataCell(_buildEditableCell(order.city, index, 'Город')),
                  DataCell(_buildEditableCell(order.plannedDelivery, index, 'Планируемая поставка')),
                  
                  // Пустая ячейка для группы "Упаковка"
                  const DataCell(SizedBox.shrink()),
                  DataCell(_buildEditableCell(order.packageShipmentNumber, index, '№ отгрузки (Упаковка)')),
                  DataCell(_buildEditableCell(order.packageShipmentDate, index, 'Отгрузка (Упаковка)')),
                  DataCell(Text(order.createdAt)),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.packageStatus),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () => _showEditDialog(index, 'Статус (Упаковка)', order.packageStatus),
                        child: Text(
                          order.packageStatus,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  DataCell(_buildEditableCell(order.changeType, index, 'Тип изменения')),
                  DataCell(_buildEditableCell(order.name, index, 'Название')),
                  DataCell(_buildEditableCell(order.description, index, 'Описание')),
                  DataCell(_buildEditableCell(order.packageType, index, 'Тип упаковки')),
                  DataCell(_buildEditableCell(order.lineNumber, index, 'Номер (Линия)')),
                  DataCell(_buildEditableCell(order.fromLetters, index, 'Из букв')),
                  DataCell(_buildEditableCell(order.details, index, 'Детали')),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.generalStatus),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () => _showEditDialog(index, 'Общий статус', order.generalStatus),
                        child: Text(
                          order.generalStatus,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
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
          ),)))
        );
      }

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'новый':
      return Colors.blue;
    case 'в обработке':
    case 'активен':
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