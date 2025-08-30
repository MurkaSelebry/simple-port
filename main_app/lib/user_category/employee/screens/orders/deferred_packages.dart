import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../common/universal_responsive_table.dart';

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

  Order copyWithField(String field, String value) {
    switch (field) {
      case 'Номер':
        return Order(
          orderNumber: value,
          status: this.status,
          opCode: this.opCode,
          shipmentNumber: this.shipmentNumber,
          shipmentDate: this.shipmentDate,
          city: this.city,
          plannedDelivery: this.plannedDelivery,
          packageShipmentNumber: this.packageShipmentNumber,
          packageShipmentDate: this.packageShipmentDate,
          createdAt: this.createdAt,
          packageStatus: this.packageStatus,
          changeType: this.changeType,
          name: this.name,
          description: this.description,
          packageType: this.packageType,
          lineNumber: this.lineNumber,
          fromLetters: this.fromLetters,
          details: this.details,
          generalStatus: this.generalStatus,
          filePath: this.filePath,
        );
      case 'Статус':
        return Order(
          orderNumber: this.orderNumber,
          status: value,
          opCode: this.opCode,
          shipmentNumber: this.shipmentNumber,
          shipmentDate: this.shipmentDate,
          city: this.city,
          plannedDelivery: this.plannedDelivery,
          packageShipmentNumber: this.packageShipmentNumber,
          packageShipmentDate: this.packageShipmentDate,
          createdAt: this.createdAt,
          packageStatus: this.packageStatus,
          changeType: this.changeType,
          name: this.name,
          description: this.description,
          packageType: this.packageType,
          lineNumber: this.lineNumber,
          fromLetters: this.fromLetters,
          details: this.details,
          generalStatus: this.generalStatus,
          filePath: this.filePath,
        );
      case 'Код ОП':
        return Order(
          orderNumber: this.orderNumber,
          status: this.status,
          opCode: value,
          shipmentNumber: this.shipmentNumber,
          shipmentDate: this.shipmentDate,
          city: this.city,
          plannedDelivery: this.plannedDelivery,
          packageShipmentNumber: this.packageShipmentNumber,
          packageShipmentDate: this.packageShipmentDate,
          createdAt: this.createdAt,
          packageStatus: this.packageStatus,
          changeType: this.changeType,
          name: this.name,
          description: this.description,
          packageType: this.packageType,
          lineNumber: this.lineNumber,
          fromLetters: this.fromLetters,
          details: this.details,
          generalStatus: this.generalStatus,
          filePath: this.filePath,
        );
      case 'Описание':
        return Order(
          orderNumber: this.orderNumber,
          status: this.status,
          opCode: this.opCode,
          shipmentNumber: this.shipmentNumber,
          shipmentDate: this.shipmentDate,
          city: this.city,
          plannedDelivery: this.plannedDelivery,
          packageShipmentNumber: this.packageShipmentNumber,
          packageShipmentDate: this.packageShipmentDate,
          createdAt: this.createdAt,
          packageStatus: this.packageStatus,
          changeType: this.changeType,
          name: this.name,
          description: value,
          packageType: this.packageType,
          lineNumber: this.lineNumber,
          fromLetters: this.fromLetters,
          details: this.details,
          generalStatus: this.generalStatus,
          filePath: this.filePath,
        );
      case 'Общий статус':
        return Order(
          orderNumber: this.orderNumber,
          status: this.status,
          opCode: this.opCode,
          shipmentNumber: this.shipmentNumber,
          shipmentDate: this.shipmentDate,
          city: this.city,
          plannedDelivery: this.plannedDelivery,
          packageShipmentNumber: this.packageShipmentNumber,
          packageShipmentDate: this.packageShipmentDate,
          createdAt: this.createdAt,
          packageStatus: this.packageStatus,
          changeType: this.changeType,
          name: this.name,
          description: this.description,
          packageType: this.packageType,
          lineNumber: this.lineNumber,
          fromLetters: this.fromLetters,
          details: this.details,
          generalStatus: value,
          filePath: this.filePath,
        );
      case 'Тип упаковки':
        return Order(
          orderNumber: this.orderNumber,
          status: this.status,
          opCode: this.opCode,
          shipmentNumber: this.shipmentNumber,
          shipmentDate: this.shipmentDate,
          city: this.city,
          plannedDelivery: this.plannedDelivery,
          packageShipmentNumber: this.packageShipmentNumber,
          packageShipmentDate: this.packageShipmentDate,
          createdAt: this.createdAt,
          packageStatus: this.packageStatus,
          changeType: this.changeType,
          name: this.name,
          description: this.description,
          packageType: value,
          lineNumber: this.lineNumber,
          fromLetters: this.fromLetters,
          details: this.details,
          generalStatus: this.generalStatus,
          filePath: this.filePath,
        );
      case 'Номер (Линия)':
        return Order(
          orderNumber: this.orderNumber,
          status: this.status,
          opCode: this.opCode,
          shipmentNumber: this.shipmentNumber,
          shipmentDate: this.shipmentDate,
          city: this.city,
          plannedDelivery: this.plannedDelivery,
          packageShipmentNumber: this.packageShipmentNumber,
          packageShipmentDate: this.packageShipmentDate,
          createdAt: this.createdAt,
          packageStatus: this.packageStatus,
          changeType: this.changeType,
          name: this.name,
          description: this.description,
          packageType: this.packageType,
          lineNumber: value,
          fromLetters: this.fromLetters,
          details: this.details,
          generalStatus: this.generalStatus,
          filePath: this.filePath,
        );
      case 'Из букв':
        return Order(
          orderNumber: this.orderNumber,
          status: this.status,
          opCode: this.opCode,
          shipmentNumber: this.shipmentNumber,
          shipmentDate: this.shipmentDate,
          city: this.city,
          plannedDelivery: this.plannedDelivery,
          packageShipmentNumber: this.packageShipmentNumber,
          packageShipmentDate: this.packageShipmentDate,
          createdAt: this.createdAt,
          packageStatus: this.packageStatus,
          changeType: this.changeType,
          name: this.name,
          description: this.description,
          packageType: this.packageType,
          lineNumber: this.lineNumber,
          fromLetters: value,
          details: this.details,
          generalStatus: this.generalStatus,
          filePath: this.filePath,
        );
      case 'Детали':
        return Order(
          orderNumber: this.orderNumber,
          status: this.status,
          opCode: this.opCode,
          shipmentNumber: this.shipmentNumber,
          shipmentDate: this.shipmentDate,
          city: this.city,
          plannedDelivery: this.plannedDelivery,
          packageShipmentNumber: this.packageShipmentNumber,
          packageShipmentDate: this.packageShipmentDate,
          createdAt: this.createdAt,
          packageStatus: this.packageStatus,
          changeType: this.changeType,
          name: this.name,
          description: this.description,
          packageType: this.packageType,
          lineNumber: this.lineNumber,
          fromLetters: this.fromLetters,
          details: value,
          generalStatus: this.generalStatus,
          filePath: this.filePath,
        );
      default:
        return this;
    }
  }
}

final List<Order> initialOrders = [
  Order(
    orderNumber: 'ORD-2024-001',
    status: 'в обработке',
    opCode: 'OP001',
    shipmentNumber: 'SH-2024-001',
    shipmentDate: '2024-01-15',
    city: 'Москва',
    plannedDelivery: '2024-01-20',
    packageShipmentNumber: 'PSH-2024-001',
    packageShipmentDate: '2024-01-18',
    createdAt: '2024-01-10',
    packageStatus: 'готов',
    changeType: 'новый',
    name: 'Кухня "Модерн"',
    description: 'Кухонный гарнитур в современном стиле',
    packageType: 'коробка',
    lineNumber: '1',
    fromLetters: 'А',
    details: 'Детали заказа',
    generalStatus: 'активен',
    filePath: '/files/order1.pdf',
  ),
  Order(
    orderNumber: 'ORD-2024-002',
    status: 'отменен',
    opCode: 'OP002',
    shipmentNumber: 'SH-2024-002',
    shipmentDate: '2024-01-16',
    city: 'Санкт-Петербург',
    plannedDelivery: '2024-01-22',
    packageShipmentNumber: 'PSH-2024-002',
    packageShipmentDate: '2024-01-19',
    createdAt: '2024-01-11',
    packageStatus: 'в план на отгрузку',
    changeType: 'изменение',
    name: 'Кухня "Классика"',
    description: 'Классический кухонный гарнитур',
    packageType: 'паллета',
    lineNumber: '2',
    fromLetters: 'Б',
    details: 'Детали заказа',
    generalStatus: 'завершен',
    filePath: '/files/order2.pdf',
  ),
  Order(
    orderNumber: 'ORD-2024-003',
    status: 'новый',
    opCode: 'OP003',
    shipmentNumber: 'SH-2024-003',
    shipmentDate: '2024-01-17',
    city: 'Екатеринбург',
    plannedDelivery: '2024-01-25',
    packageShipmentNumber: 'PSH-2024-003',
    packageShipmentDate: '2024-01-20',
    createdAt: '2024-01-12',
    packageStatus: 'готов',
    changeType: 'новый',
    name: 'Кухня "Прованс"',
    description: 'Кухня в стиле прованс',
    packageType: 'мешок',
    lineNumber: '3',
    fromLetters: 'В',
    details: 'Детали заказа',
    generalStatus: 'активен',
    filePath: '/files/order3.pdf',
  ),
  Order(
    orderNumber: 'ORD-2024-004',
    status: 'в обработке',
    opCode: 'OP004',
    shipmentNumber: 'SH-2024-004',
    shipmentDate: '2024-01-18',
    city: 'Новосибирск',
    plannedDelivery: '2024-01-28',
    packageShipmentNumber: 'PSH-2024-004',
    packageShipmentDate: '2024-01-21',
    createdAt: '2024-01-13',
    packageStatus: 'в план на отгрузку',
    changeType: 'изменение',
    name: 'Кухня "Лофт"',
    description: 'Кухня в стиле лофт',
    packageType: 'ящик',
    lineNumber: '4',
    fromLetters: 'Г',
    details: 'Детали заказа',
    generalStatus: 'активен',
    filePath: '/files/order4.pdf',
  ),
  Order(
    orderNumber: 'ORD-2024-005',
    status: 'завершен',
    opCode: 'OP005',
    shipmentNumber: 'SH-2024-005',
    shipmentDate: '2024-01-19',
    city: 'Казань',
    plannedDelivery: '2024-01-30',
    packageShipmentNumber: 'PSH-2024-005',
    packageShipmentDate: '2024-01-22',
    createdAt: '2024-01-14',
    packageStatus: 'готов',
    changeType: 'новый',
    name: 'Кухня "Минимализм"',
    description: 'Минималистичная кухня',
    packageType: 'коробка',
    lineNumber: '5',
    fromLetters: 'Д',
    details: 'Детали заказа',
    generalStatus: 'завершен',
    filePath: '/files/order5.pdf',
  ),
  Order(
    orderNumber: 'ORD-2024-006',
    status: 'в обработке',
    opCode: 'OP006',
    shipmentNumber: 'SH-2024-006',
    shipmentDate: '2024-01-20',
    city: 'Нижний Новгород',
    plannedDelivery: '2024-02-02',
    packageShipmentNumber: 'PSH-2024-006',
    packageShipmentDate: '2024-01-23',
    createdAt: '2024-01-15',
    packageStatus: 'готов',
    changeType: 'новый',
    name: 'Кухня "Скандинавия"',
    description: 'Кухня в скандинавском стиле',
    packageType: 'паллета',
    lineNumber: '6',
    fromLetters: 'Е',
    details: 'Детали заказа',
    generalStatus: 'активен',
    filePath: '/files/order6.pdf',
  ),
  Order(
    orderNumber: 'ORD-2024-007',
    status: 'новый',
    opCode: 'OP007',
    shipmentNumber: 'SH-2024-007',
    shipmentDate: '2024-01-21',
    city: 'Ростов-на-Дону',
    plannedDelivery: '2024-02-05',
    packageShipmentNumber: 'PSH-2024-007',
    packageShipmentDate: '2024-01-24',
    createdAt: '2024-01-16',
    packageStatus: 'в план на отгрузку',
    changeType: 'изменение',
    name: 'Кухня "Хай-тек"',
    description: 'Кухня в стиле хай-тек',
    packageType: 'ящик',
    lineNumber: '7',
    fromLetters: 'Ж',
    details: 'Детали заказа',
    generalStatus: 'активен',
    filePath: '/files/order7.pdf',
  ),
  Order(
    orderNumber: 'ORD-2024-008',
    status: 'в обработке',
    opCode: 'OP008',
    shipmentNumber: 'SH-2024-008',
    shipmentDate: '2024-01-22',
    city: 'Уфа',
    plannedDelivery: '2024-02-08',
    packageShipmentNumber: 'PSH-2024-008',
    packageShipmentDate: '2024-01-25',
    createdAt: '2024-01-17',
    packageStatus: 'готов',
    changeType: 'новый',
    name: 'Кухня "Кантри"',
    description: 'Кухня в деревенском стиле',
    packageType: 'коробка',
    lineNumber: '8',
    fromLetters: 'З',
    details: 'Детали заказа',
    generalStatus: 'активен',
    filePath: '/files/order8.pdf',
  ),
  Order(
    orderNumber: 'ORD-2024-009',
    status: 'завершен',
    opCode: 'OP009',
    shipmentNumber: 'SH-2024-009',
    shipmentDate: '2024-01-23',
    city: 'Волгоград',
    plannedDelivery: '2024-02-10',
    packageShipmentNumber: 'PSH-2024-009',
    packageShipmentDate: '2024-01-26',
    createdAt: '2024-01-18',
    packageStatus: 'готов',
    changeType: 'новый',
    name: 'Кухня "Арт-деко"',
    description: 'Кухня в стиле арт-деко',
    packageType: 'паллета',
    lineNumber: '9',
    fromLetters: 'И',
    details: 'Детали заказа',
    generalStatus: 'завершен',
    filePath: '/files/order9.pdf',
  ),
  Order(
    orderNumber: 'ORD-2024-010',
    status: 'новый',
    opCode: 'OP010',
    shipmentNumber: 'SH-2024-010',
    shipmentDate: '2024-01-24',
    city: 'Пермь',
    plannedDelivery: '2024-02-12',
    packageShipmentNumber: 'PSH-2024-010',
    packageShipmentDate: '2024-01-27',
    createdAt: '2024-01-19',
    packageStatus: 'в план на отгрузку',
    changeType: 'изменение',
    name: 'Кухня "Неоклассика"',
    description: 'Кухня в неоклассическом стиле',
    packageType: 'ящик',
    lineNumber: '10',
    fromLetters: 'К',
    details: 'Детали заказа',
    generalStatus: 'активен',
    filePath: '/files/order10.pdf',
  ),
];

class DeferredPackages extends StatefulWidget {
  const DeferredPackages({Key? key}) : super(key: key);

  @override
  _DeferredPackagesState createState() => _DeferredPackagesState();
}

class _DeferredPackagesState extends State<DeferredPackages> {
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

  final List<Map<String, dynamic>> ordersData = filteredOrders.map((order) => order.toMap()).toList();
  
  return UniversalResponsiveTable(
    data: ordersData,
    columns: [
      'Номер', 'Статус', 'Код ОП', '№ отгрузки', 'Отгрузка', 'Город', 
      'Планируемая поставка', '№ отгрузки (Упаковка)', 'Отгрузка (Упаковка)', 
      'Создано', 'Статус (Упаковка)', 'Тип изменения', 'Название', 'Описание', 
      'Тип упаковки', 'Номер (Линия)', 'Из букв', 'Детали', 'Общий статус'
    ],
    columnKeys: [
      'Номер', 'Статус', 'Код ОП', '№ отгрузки', 'Отгрузка', 'Город', 
      'Планируемая поставка', '№ отгрузки (Упаковка)', 'Отгрузка (Упаковка)', 
      'Создано', 'Статус (Упаковка)', 'Тип изменения', 'Название', 'Описание', 
      'Тип упаковки', 'Номер (Линия)', 'Из букв', 'Детали', 'Общий статус'
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
      'Планируемая поставка': 'date',
      'Отгрузка (Упаковка)': 'date',
      'Создано': 'date',
      'Статус': 'status',
      'Статус (Упаковка)': 'status',
      'Общий статус': 'status',
    },
    statusOptions: {
      'Статус': ['Новый', 'В обработке', 'В производстве', 'Отгружен', 'Завершен'],
      'Статус (Упаковка)': ['Новый', 'В обработке', 'В производстве', 'Отгружен', 'Завершен'],
      'Общий статус': ['Новый', 'В обработке', 'В производстве', 'Отгружен', 'Завершен'],
    },
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
