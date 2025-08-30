import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../common/universal_responsive_table.dart';

// Обновленная модель данных для заказа с правильными полями
class Order {
  String opCode;
  String city;
  String number;
  String type;
  String generalStatus;
  String returnOrders;         // Возвратных
  String shipmentNumber;       // Номер отгрузки
  String shipmentDate;         // Отгрузка
  String desiredDeliveryDate;  // Желаемая дата поставки
  String plannedDeliveryDate;  // Планируемая дата поставки
  String creator;
  String createdAt;
  String orderStatus;
  String salon;
  String designer;
  String warehouseStatus;
  String productionStatus;
  String storeStatus;
  String financeStatus;
  String paymentStatus;
  String description;
  String filePath;

  Order({
    required this.opCode,
    required this.city,
    required this.number,
    required this.type,
    required this.generalStatus,
    required this.returnOrders,
    required this.shipmentNumber,
    required this.shipmentDate,
    required this.desiredDeliveryDate,
    required this.plannedDeliveryDate,
    required this.creator,
    required this.createdAt,
    required this.orderStatus,
    required this.salon,
    required this.designer,
    required this.warehouseStatus,
    required this.productionStatus,
    required this.storeStatus,
    required this.financeStatus,
    required this.paymentStatus,
    required this.description,
    required this.filePath,
  });

  factory Order.fromMap(Map<String, String> map) {
    return Order(
      opCode: map['Код ОП'] ?? '',
      city: map['Город'] ?? '',
      number: map['Номер'] ?? '',
      type: map['Тип'] ?? '',
      generalStatus: map['Общий статус'] ?? '',
      returnOrders: map['Возвратных'] ?? '',
      shipmentNumber: map['Номер отгрузки'] ?? '',
      shipmentDate: map['Отгрузка'] ?? '',
      desiredDeliveryDate: map['Желаемая дата поставки'] ?? '',
      plannedDeliveryDate: map['Планируемая дата поставки'] ?? '',
      creator: map['Создал'] ?? '',
      createdAt: map['Создано'] ?? '',
      orderStatus: map['Заказ'] ?? '',
      salon: map['Салон'] ?? '',
      designer: map['Конструктор'] ?? '',
      warehouseStatus: map['Склад комплектации'] ?? '',
      productionStatus: map['Производство'] ?? '',
      storeStatus: map['Склад ГП'] ?? '',
      financeStatus: map['Финансы'] ?? '',
      paymentStatus: map['Оплата'] ?? '',
      description: map['Описание'] ?? '',
      filePath: map['Путь'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'Код ОП': opCode,
      'Город': city,
      'Номер': number,
      'Тип': type,
      'Общий статус': generalStatus,
      'Возвратных': returnOrders,
      'Номер отгрузки': shipmentNumber,
      'Отгрузка': shipmentDate,
      'Желаемая дата поставки': desiredDeliveryDate,
      'Планируемая дата поставки': plannedDeliveryDate,
      'Создал': creator,
      'Создано': createdAt,
      'Заказ': orderStatus,
      'Салон': salon,
      'Конструктор': designer,
      'Склад комплектации': warehouseStatus,
      'Производство': productionStatus,
      'Склад ГП': storeStatus,
      'Финансы': financeStatus,
      'Оплата': paymentStatus,
      'Описание': description,
      'Путь': filePath,
    };
  }

  Order copyWith({
    String? opCode,
    String? city,
    String? number,
    String? type,
    String? generalStatus,
    String? returnOrders,
    String? shipmentNumber,
    String? shipmentDate,
    String? desiredDeliveryDate,
    String? plannedDeliveryDate,
    String? creator,
    String? createdAt,
    String? orderStatus,
    String? salon,
    String? designer,
    String? warehouseStatus,
    String? productionStatus,
    String? storeStatus,
    String? financeStatus,
    String? paymentStatus,
    String? description,
    String? filePath,
  }) {
    return Order(
      opCode: opCode ?? this.opCode,
      city: city ?? this.city,
      number: number ?? this.number,
      type: type ?? this.type,
      generalStatus: generalStatus ?? this.generalStatus,
      returnOrders: returnOrders ?? this.returnOrders,
      shipmentNumber: shipmentNumber ?? this.shipmentNumber,
      shipmentDate: shipmentDate ?? this.shipmentDate,
      desiredDeliveryDate: desiredDeliveryDate ?? this.desiredDeliveryDate,
      plannedDeliveryDate: plannedDeliveryDate ?? this.plannedDeliveryDate,
      creator: creator ?? this.creator,
      createdAt: createdAt ?? this.createdAt,
      orderStatus: orderStatus ?? this.orderStatus,
      salon: salon ?? this.salon,
      designer: designer ?? this.designer,
      warehouseStatus: warehouseStatus ?? this.warehouseStatus,
      productionStatus: productionStatus ?? this.productionStatus,
      storeStatus: storeStatus ?? this.storeStatus,
      financeStatus: financeStatus ?? this.financeStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      description: description ?? this.description,
      filePath: filePath ?? this.filePath,
    );
  }

  Order copyWithField(String field, String value) {
    switch (field) {
      case 'Код ОП':
        return copyWith(opCode: value);
      case 'Город':
        return copyWith(city: value);
      case 'Номер':
        return copyWith(number: value);
      case 'Тип':
        return copyWith(type: value);
      case 'Общий статус':
        return copyWith(generalStatus: value);
      case 'Возвратных':
        return copyWith(returnOrders: value);
      case 'Номер отгрузки':
        return copyWith(shipmentNumber: value);
      case 'Отгрузка':
        return copyWith(shipmentDate: value);
      case 'Желаемая дата поставки':
        return copyWith(desiredDeliveryDate: value);
      case 'Планируемая дата поставки':
        return copyWith(plannedDeliveryDate: value);
      case 'Создал':
        return copyWith(creator: value);
      case 'Создано':
        return copyWith(createdAt: value);
      case 'Заказ':
        return copyWith(orderStatus: value);
      case 'Салон':
        return copyWith(salon: value);
      case 'Конструктор':
        return copyWith(designer: value);
      case 'Склад комплектации':
        return copyWith(warehouseStatus: value);
      case 'Производство':
        return copyWith(productionStatus: value);
      case 'Склад ГП':
        return copyWith(storeStatus: value);
      case 'Финансы':
        return copyWith(financeStatus: value);
      case 'Оплата':
        return copyWith(paymentStatus: value);
      case 'Описание':
        return copyWith(description: value);
      case 'Путь':
        return copyWith(filePath: value);
      default:
        return this;
    }
  }
}

final List<Order> initialOrders = [
  Order(
    opCode: 'OP001',
    city: 'Москва',
    number: 'ORD-2024-001',
    type: 'Заказ',
    generalStatus: 'активен',
    returnOrders: '0',
    shipmentNumber: 'SH-2024-001',
    shipmentDate: '2024-01-15',
    desiredDeliveryDate: '2024-01-20',
    plannedDeliveryDate: '2024-01-20',
    creator: 'ivan.petrov',
    createdAt: '2024-01-10',
    orderStatus: 'В обработке',
    salon: 'Салон "Модерн"',
    designer: 'maria.sidorova',
    warehouseStatus: 'Готов',
    productionStatus: 'В производстве',
    storeStatus: 'В наличии',
    financeStatus: 'Оплачено',
    paymentStatus: 'Оплачено',
    description: 'Кухня "Модерн" - современный кухонный гарнитур',
    filePath: '/files/order1.pdf',
  ),
  Order(
    opCode: 'OP002',
    city: 'Санкт-Петербург',
    number: 'ORD-2024-002',
    type: 'Заказ',
    generalStatus: 'завершен',
    returnOrders: '0',
    shipmentNumber: 'SH-2024-002',
    shipmentDate: '2024-01-16',
    desiredDeliveryDate: '2024-01-22',
    plannedDeliveryDate: '2024-01-22',
    creator: 'dmitry.kozlov',
    createdAt: '2024-01-11',
    orderStatus: 'Отгружено на фабрике',
    salon: 'Салон "Классика"',
    designer: 'alex.kuznetsov',
    warehouseStatus: 'Отгружено',
    productionStatus: 'Завершено',
    storeStatus: 'Доставлено',
    financeStatus: 'Оплачено',
    paymentStatus: 'Оплачено',
    description: 'Кухня "Классика" - классический кухонный гарнитур',
    filePath: '/files/order2.pdf',
  ),
  Order(
    opCode: 'OP003',
    city: 'Екатеринбург',
    number: 'ORD-2024-003',
    type: 'Заказ',
    generalStatus: 'активен',
    returnOrders: '0',
    shipmentNumber: 'SH-2024-003',
    shipmentDate: '2024-01-17',
    desiredDeliveryDate: '2024-01-25',
    plannedDeliveryDate: '2024-01-25',
    creator: 'maria.sidorova',
    createdAt: '2024-01-12',
    orderStatus: 'Новый',
    salon: 'Салон "Прованс"',
    designer: 'anna.morozova',
    warehouseStatus: 'В ожидании',
    productionStatus: 'Планируется',
    storeStatus: 'Заказано',
    financeStatus: 'Частично оплачено',
    paymentStatus: 'Частично оплачено',
    description: 'Кухня "Прованс" - кухня в стиле прованс',
    filePath: '/files/order3.pdf',
  ),
  Order(
    opCode: 'OP004',
    city: 'Новосибирск',
    number: 'ORD-2024-004',
    type: 'Заказ',
    generalStatus: 'активен',
    returnOrders: '0',
    shipmentNumber: 'SH-2024-004',
    shipmentDate: '2024-01-18',
    desiredDeliveryDate: '2024-01-28',
    plannedDeliveryDate: '2024-01-28',
    creator: 'alex.kuznetsov',
    createdAt: '2024-01-13',
    orderStatus: 'В обработке',
    salon: 'Салон "Лофт"',
    designer: 'ivan.petrov',
    warehouseStatus: 'Готов',
    productionStatus: 'В производстве',
    storeStatus: 'В наличии',
    financeStatus: 'Оплачено',
    paymentStatus: 'Оплачено',
    description: 'Кухня "Лофт" - кухня в стиле лофт',
    filePath: '/files/order4.pdf',
  ),
  Order(
    opCode: 'OP005',
    city: 'Казань',
    number: 'ORD-2024-005',
    type: 'Заказ',
    generalStatus: 'завершен',
    returnOrders: '0',
    shipmentNumber: 'SH-2024-005',
    shipmentDate: '2024-01-19',
    desiredDeliveryDate: '2024-01-30',
    plannedDeliveryDate: '2024-01-30',
    creator: 'anna.morozova',
    createdAt: '2024-01-14',
    orderStatus: 'Отгружено на фабрике',
    salon: 'Салон "Минимализм"',
    designer: 'dmitry.kozlov',
    warehouseStatus: 'Отгружено',
    productionStatus: 'Завершено',
    storeStatus: 'Доставлено',
    financeStatus: 'Оплачено',
    paymentStatus: 'Оплачено',
    description: 'Кухня "Минимализм" - минималистичная кухня',
    filePath: '/files/order5.pdf',
  ),
  Order(
    opCode: 'OP006',
    city: 'Нижний Новгород',
    number: 'ORD-2024-006',
    type: 'Заказ',
    generalStatus: 'активен',
    returnOrders: '0',
    shipmentNumber: 'SH-2024-006',
    shipmentDate: '2024-01-20',
    desiredDeliveryDate: '2024-02-02',
    plannedDeliveryDate: '2024-02-02',
    creator: 'ivan.petrov',
    createdAt: '2024-01-15',
    orderStatus: 'В обработке',
    salon: 'Салон "Скандинавия"',
    designer: 'maria.sidorova',
    warehouseStatus: 'Готов',
    productionStatus: 'В производстве',
    storeStatus: 'В наличии',
    financeStatus: 'Оплачено',
    paymentStatus: 'Оплачено',
    description: 'Кухня "Скандинавия" - кухня в скандинавском стиле',
    filePath: '/files/order6.pdf',
  ),
  Order(
    opCode: 'OP007',
    city: 'Ростов-на-Дону',
    number: 'ORD-2024-007',
    type: 'Заказ',
    generalStatus: 'активен',
    returnOrders: '0',
    shipmentNumber: 'SH-2024-007',
    shipmentDate: '2024-01-21',
    desiredDeliveryDate: '2024-02-05',
    plannedDeliveryDate: '2024-02-05',
    creator: 'dmitry.kozlov',
    createdAt: '2024-01-16',
    orderStatus: 'Новый',
    salon: 'Салон "Хай-тек"',
    designer: 'alex.kuznetsov',
    warehouseStatus: 'В ожидании',
    productionStatus: 'Планируется',
    storeStatus: 'Заказано',
    financeStatus: 'Ожидает оплаты',
    paymentStatus: 'Ожидает оплаты',
    description: 'Кухня "Хай-тек" - кухня в стиле хай-тек',
    filePath: '/files/order7.pdf',
  ),
  Order(
    opCode: 'OP008',
    city: 'Уфа',
    number: 'ORD-2024-008',
    type: 'Заказ',
    generalStatus: 'активен',
    returnOrders: '0',
    shipmentNumber: 'SH-2024-008',
    shipmentDate: '2024-01-22',
    desiredDeliveryDate: '2024-02-08',
    plannedDeliveryDate: '2024-02-08',
    creator: 'maria.sidorova',
    createdAt: '2024-01-17',
    orderStatus: 'В обработке',
    salon: 'Салон "Кантри"',
    designer: 'anna.morozova',
    warehouseStatus: 'Готов',
    productionStatus: 'В производстве',
    storeStatus: 'В наличии',
    financeStatus: 'Оплачено',
    paymentStatus: 'Оплачено',
    description: 'Кухня "Кантри" - кухня в деревенском стиле',
    filePath: '/files/order8.pdf',
  ),
  Order(
    opCode: 'OP009',
    city: 'Волгоград',
    number: 'ORD-2024-009',
    type: 'Заказ',
    generalStatus: 'завершен',
    returnOrders: '0',
    shipmentNumber: 'SH-2024-009',
    shipmentDate: '2024-01-23',
    desiredDeliveryDate: '2024-02-10',
    plannedDeliveryDate: '2024-02-10',
    creator: 'alex.kuznetsov',
    createdAt: '2024-01-18',
    orderStatus: 'Отгружено на фабрике',
    salon: 'Салон "Арт-деко"',
    designer: 'ivan.petrov',
    warehouseStatus: 'Отгружено',
    productionStatus: 'Завершено',
    storeStatus: 'Доставлено',
    financeStatus: 'Оплачено',
    paymentStatus: 'Оплачено',
    description: 'Кухня "Арт-деко" - кухня в стиле арт-деко',
    filePath: '/files/order9.pdf',
  ),
  Order(
    opCode: 'OP010',
    city: 'Пермь',
    number: 'ORD-2024-010',
    type: 'Заказ',
    generalStatus: 'активен',
    returnOrders: '0',
    shipmentNumber: 'SH-2024-010',
    shipmentDate: '2024-01-24',
    desiredDeliveryDate: '2024-02-12',
    plannedDeliveryDate: '2024-02-12',
    creator: 'ivan.petrov',
    createdAt: '2024-01-19',
    orderStatus: 'Новый',
    salon: 'Салон "Неоклассика"',
    designer: 'maria.sidorova',
    warehouseStatus: 'В ожидании',
    productionStatus: 'Планируется',
    storeStatus: 'Заказано',
    financeStatus: 'Частично оплачено',
    paymentStatus: 'Частично оплачено',
    description: 'Кухня "Неоклассика" - кухня в неоклассическом стиле',
    filePath: '/files/order10.pdf',
  ),
];

class OrdersAndPackages extends StatefulWidget {
  const OrdersAndPackages({super.key});

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<OrdersAndPackages> {
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
    'Отгружено на фабрике',
    'Готов',
    'Отменен'
  ];
  
  final List<String> _typeOptions = [
    'Фасад',
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
              city: '---',
              number: '---',
              type: '---',
              generalStatus: '---',
              returnOrders: '---',
              shipmentNumber: '---',
              shipmentDate: '---',
              desiredDeliveryDate: '---',
              plannedDeliveryDate: '---',
              creator: 'Пользователь',
              createdAt: _formatDate(DateTime.now()),
              orderStatus: 'Новый',
              salon: '---',
              designer: '---',
              warehouseStatus: '---',
              productionStatus: '---',
              storeStatus: '---',
              financeStatus: '---',
              paymentStatus: '---',
              description: fileName,
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
    if (field == 'Заказ' || field == 'Тип' || field == 'Оплата') {
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
    
    if (field == 'Заказ') {
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
      String content = 'Код ОП;Город;Номер;Тип;Общий статус;Возвратных;Номер отгрузки;Отгрузка;'
          'Желаемая дата поставки;Планируемая дата поставки;Создал;Создано;Заказ;Салон;Конструктор;'
          'Склад комплектации;Производство;Склад ГП;Финансы;Оплата;Описание;Путь\n';
          
      for (var order in _orders) {
        content += '${order.opCode};${order.city};${order.number};${order.type};'
            '${order.generalStatus};${order.returnOrders};${order.shipmentNumber};${order.shipmentDate};'
            '${order.desiredDeliveryDate};${order.plannedDeliveryDate};${order.creator};'
            '${order.createdAt};${order.orderStatus};${order.salon};${order.designer};'
            '${order.warehouseStatus};${order.productionStatus};${order.storeStatus};'
            '${order.financeStatus};${order.paymentStatus};${order.description};${order.filePath}\n';
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
        final TextEditingController cityController = TextEditingController();
        final TextEditingController numberController = TextEditingController();
        final TextEditingController typeController = TextEditingController();
        
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
                  controller: cityController,
                  decoration: const InputDecoration(
                    labelText: 'Город',
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
                    city: cityController.text.isNotEmpty ? cityController.text : '---',
                    number: numberController.text.isNotEmpty ? numberController.text : '---',
                    type: typeController.text.isNotEmpty ? typeController.text : '---',
                    generalStatus: '---',
                    returnOrders: '---',
                    shipmentNumber: '---',
                    shipmentDate: '---',
                    desiredDeliveryDate: '---',
                    plannedDeliveryDate: '---',
                    creator: 'Пользователь',
                    createdAt: _formatDate(DateTime.now()),
                    orderStatus: 'Новый',
                    salon: '---',
                    designer: '---',
                    warehouseStatus: '---',
                    productionStatus: '---',
                    storeStatus: '---',
                    financeStatus: '---',
                    paymentStatus: '---',
                    description: '---',
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
        'Код ОП', 'Город', 'Номер', 'Тип', 'Общий статус', 'Возвратных',
        'Номер отгрузки', 'Отгрузка', 'Желаемая дата поставки', 'Планируемая дата поставки',
        'Создал', 'Создано', 'Заказ', 'Салон', 'Конструктор', 'Склад комплектации',
        'Производство', 'Склад ГП', 'Финансы', 'Оплата', 'Описание'
      ],
      columnKeys: [
        'Код ОП', 'Город', 'Номер', 'Тип', 'Общий статус', 'Возвратных',
        'Номер отгрузки', 'Отгрузка', 'Желаемая дата поставки', 'Планируемая дата поставки',
        'Создал', 'Создано', 'Заказ', 'Салон', 'Конструктор', 'Склад комплектации',
        'Производство', 'Склад ГП', 'Финансы', 'Оплата', 'Описание'
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
        'Желаемая дата поставки': 'date',
        'Планируемая дата поставки': 'date',
        'Создано': 'date',
        'Общий статус': 'status',
        'Заказ': 'status',
      },
      statusOptions: {
        'Общий статус': ['Новый', 'В обработке', 'В производстве', 'Отгружен', 'Завершен'],
        'Заказ': ['Новый', 'В обработке', 'В производстве', 'Отгружен', 'Завершен'],
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
      case 'отгружено на фабрике':
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
