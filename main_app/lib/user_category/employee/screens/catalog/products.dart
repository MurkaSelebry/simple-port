import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../common/universal_responsive_table.dart';

// Обновленная модель данных для каталога с полями, соответствующими скриншотам
class Catalog {
  String code;           // Код ОП
  String group;          // Группа
  String subgroup;       // Подгруппа
  String subgroupType;   // Тип подгруппы
  String name;           // Название
  String article;        // Артикул
  String unit;           // Ед. изм.
  String description;    // Описание
  String expirationDate; // Срок действия
  String price1;         // Цена1
  String price2;         // Цена2
  String price3;         // Цена3
  String price4;         // Цена4
  String price5;         // Цена5
  String price6;         // Цена6
  String price7;         // Цена7
  String addedBy;        // Добавил
  String addedDate;      // Дата
  String modifiedBy;     // Изменил
  String modifiedDate;   // Изменено
  String filePath;       // Путь к файлу

  Catalog({
    required this.code,
    required this.group,
    required this.subgroup,
    required this.subgroupType,
    required this.name,
    required this.article,
    required this.unit,
    required this.description,
    required this.expirationDate,
    required this.price1,
    required this.price2,
    required this.price3,
    required this.price4,
    required this.price5,
    required this.price6,
    required this.price7,
    required this.addedBy,
    required this.addedDate,
    required this.modifiedBy,
    required this.modifiedDate,
    required this.filePath,
  });

  factory Catalog.fromMap(Map<String, String> map) {
    return Catalog(
      code: map['Код ОП'] ?? '',
      group: map['Группа'] ?? '',
      subgroup: map['Подгруппа'] ?? '',
      subgroupType: map['Тип подгруппы'] ?? '',
      name: map['Название'] ?? '',
      article: map['Артикул'] ?? '',
      unit: map['Ед. изм.'] ?? '',
      description: map['Описание'] ?? '',
      expirationDate: map['Срок действия'] ?? '',
      price1: map['Цена1'] ?? '',
      price2: map['Цена2'] ?? '',
      price3: map['Цена3'] ?? '',
      price4: map['Цена4'] ?? '',
      price5: map['Цена5'] ?? '',
      price6: map['Цена6'] ?? '',
      price7: map['Цена7'] ?? '',
      addedBy: map['Добавил'] ?? '',
      addedDate: map['Дата'] ?? '',
      modifiedBy: map['Изменил'] ?? '',
      modifiedDate: map['Изменено'] ?? '',
      filePath: map['Путь'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'Код ОП': code,
      'Группа': group,
      'Подгруппа': subgroup,
      'Тип подгруппы': subgroupType,
      'Название': name,
      'Артикул': article,
      'Ед. изм.': unit,
      'Описание': description,
      'Срок действия': expirationDate,
      'Цена1': price1,
      'Цена2': price2,
      'Цена3': price3,
      'Цена4': price4,
      'Цена5': price5,
      'Цена6': price6,
      'Цена7': price7,
      'Добавил': addedBy,
      'Дата': addedDate,
      'Изменил': modifiedBy,
      'Изменено': modifiedDate,
      'Путь': filePath,
    };
  }

  Catalog copyWith({
    String? code,
    String? group,
    String? subgroup,
    String? subgroupType,
    String? name,
    String? article,
    String? unit,
    String? description,
    String? expirationDate,
    String? price1,
    String? price2,
    String? price3,
    String? price4,
    String? price5,
    String? price6,
    String? price7,
    String? addedBy,
    String? addedDate,
    String? modifiedBy,
    String? modifiedDate,
    String? filePath,
  }) {
    return Catalog(
      code: code ?? this.code,
      group: group ?? this.group,
      subgroup: subgroup ?? this.subgroup,
      subgroupType: subgroupType ?? this.subgroupType,
      name: name ?? this.name,
      article: article ?? this.article,
      unit: unit ?? this.unit,
      description: description ?? this.description,
      expirationDate: expirationDate ?? this.expirationDate,
      price1: price1 ?? this.price1,
      price2: price2 ?? this.price2,
      price3: price3 ?? this.price3,
      price4: price4 ?? this.price4,
      price5: price5 ?? this.price5,
      price6: price6 ?? this.price6,
      price7: price7 ?? this.price7,
      addedBy: addedBy ?? this.addedBy,
      addedDate: addedDate ?? this.addedDate,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      filePath: filePath ?? this.filePath,
    );
  }

  Catalog copyWithField(String field, String value) {
    switch (field) {
      case 'Код ОП':
        return copyWith(code: value);
      case 'Группа':
        return copyWith(group: value);
      case 'Подгруппа':
        return copyWith(subgroup: value);
      case 'Тип подгруппы':
        return copyWith(subgroupType: value);
      case 'Название':
        return copyWith(name: value);
      case 'Артикул':
        return copyWith(article: value);
      case 'Ед. изм.':
        return copyWith(unit: value);
      case 'Описание':
        return copyWith(description: value);
      case 'Срок действия':
        return copyWith(expirationDate: value);
      case 'Цена1':
        return copyWith(price1: value);
      case 'Цена2':
        return copyWith(price2: value);
      case 'Цена3':
        return copyWith(price3: value);
      case 'Цена4':
        return copyWith(price4: value);
      case 'Цена5':
        return copyWith(price5: value);
      case 'Цена6':
        return copyWith(price6: value);
      case 'Цена7':
        return copyWith(price7: value);
      case 'Добавил':
        return copyWith(addedBy: value);
      case 'Дата':
        return copyWith(addedDate: value);
      case 'Изменил':
        return copyWith(modifiedBy: value);
      case 'Изменено':
        return copyWith(modifiedDate: value);
      case 'Путь':
        return copyWith(filePath: value);
      default:
        return this;
    }
  }
}

// Начальные данные для примера
final List<Catalog> initialCatalogs = [
  Catalog(
    code: 'OP001',
    group: 'Кухонная мебель',
    subgroup: 'Кухонные гарнитуры',
    subgroupType: 'Современные',
    name: 'Кухня "Модерн" 2.5м',
    article: 'KM-001',
    unit: 'шт',
    description: 'Современный кухонный гарнитур 2.5 метра',
    expirationDate: '2025-12-31',
    price1: '85000.00',
    price2: '76500.00',
    price3: '68000.00',
    price4: '59500.00',
    price5: '51000.00',
    price6: '42500.00',
    price7: '34000.00',
    addedBy: 'ivan.petrov',
    addedDate: '2024-01-10',
    modifiedBy: 'maria.sidorova',
    modifiedDate: '2024-01-15',
    filePath: '',
  ),
  Catalog(
    code: 'OP002',
    group: 'Кухонная мебель',
    subgroup: 'Кухонные гарнитуры',
    subgroupType: 'Классические',
    name: 'Кухня "Классика" 3.0м',
    article: 'KM-002',
    unit: 'шт',
    description: 'Классический кухонный гарнитур 3 метра',
    expirationDate: '2025-12-31',
    price1: '95000.00',
    price2: '85500.00',
    price3: '76000.00',
    price4: '66500.00',
    price5: '57000.00',
    price6: '47500.00',
    price7: '38000.00',
    addedBy: 'dmitry.kozlov',
    addedDate: '2024-01-11',
    modifiedBy: 'dmitry.kozlov',
    modifiedDate: '2024-01-16',
    filePath: '',
  ),
  Catalog(
    code: 'OP003',
    group: 'Кухонная мебель',
    subgroup: 'Кухонные гарнитуры',
    subgroupType: 'Прованс',
    name: 'Кухня "Прованс" 2.8м',
    article: 'KM-003',
    unit: 'шт',
    description: 'Кухня в стиле прованс 2.8 метра',
    expirationDate: '2025-12-31',
    price1: '78000.00',
    price2: '70200.00',
    price3: '62400.00',
    price4: '54600.00',
    price5: '46800.00',
    price6: '39000.00',
    price7: '31200.00',
    addedBy: 'maria.sidorova',
    addedDate: '2024-01-12',
    modifiedBy: 'maria.sidorova',
    modifiedDate: '2024-01-17',
    filePath: '',
  ),
  Catalog(
    code: 'OP004',
    group: 'Кухонная мебель',
    subgroup: 'Кухонные гарнитуры',
    subgroupType: 'Лофт',
    name: 'Кухня "Лофт" 3.2м',
    article: 'KM-004',
    unit: 'шт',
    description: 'Кухня в стиле лофт 3.2 метра',
    expirationDate: '2025-12-31',
    price1: '92000.00',
    price2: '82800.00',
    price3: '73600.00',
    price4: '64400.00',
    price5: '55200.00',
    price6: '46000.00',
    price7: '36800.00',
    addedBy: 'alex.kuznetsov',
    addedDate: '2024-01-13',
    modifiedBy: 'alex.kuznetsov',
    modifiedDate: '2024-01-18',
    filePath: '',
  ),
  Catalog(
    code: 'OP005',
    group: 'Кухонная мебель',
    subgroup: 'Кухонные гарнитуры',
    subgroupType: 'Минимализм',
    name: 'Кухня "Минимализм" 2.0м',
    article: 'KM-005',
    unit: 'шт',
    description: 'Минималистичная кухня 2 метра',
    expirationDate: '2025-12-31',
    price1: '65000.00',
    price2: '58500.00',
    price3: '52000.00',
    price4: '45500.00',
    price5: '39000.00',
    price6: '32500.00',
    price7: '26000.00',
    addedBy: 'anna.morozova',
    addedDate: '2024-01-14',
    modifiedBy: 'anna.morozova',
    modifiedDate: '2024-01-19',
    filePath: '',
  ),
  Catalog(
    code: 'OP006',
    group: 'Кухонная мебель',
    subgroup: 'Кухонные гарнитуры',
    subgroupType: 'Скандинавия',
    name: 'Кухня "Скандинавия" 2.7м',
    article: 'KM-006',
    unit: 'шт',
    description: 'Кухня в скандинавском стиле 2.7 метра',
    expirationDate: '2025-12-31',
    price1: '82000.00',
    price2: '73800.00',
    price3: '65600.00',
    price4: '57400.00',
    price5: '49200.00',
    price6: '41000.00',
    price7: '32800.00',
    addedBy: 'ivan.petrov',
    addedDate: '2024-01-15',
    modifiedBy: 'ivan.petrov',
    modifiedDate: '2024-01-20',
    filePath: '',
  ),
  Catalog(
    code: 'OP007',
    group: 'Кухонная мебель',
    subgroup: 'Кухонные гарнитуры',
    subgroupType: 'Хай-тек',
    name: 'Кухня "Хай-тек" 3.5м',
    article: 'KM-007',
    unit: 'шт',
    description: 'Кухня в стиле хай-тек 3.5 метра',
    expirationDate: '2025-12-31',
    price1: '120000.00',
    price2: '108000.00',
    price3: '96000.00',
    price4: '84000.00',
    price5: '72000.00',
    price6: '60000.00',
    price7: '48000.00',
    addedBy: 'dmitry.kozlov',
    addedDate: '2024-01-16',
    modifiedBy: 'dmitry.kozlov',
    modifiedDate: '2024-01-21',
    filePath: '',
  ),
  Catalog(
    code: 'OP008',
    group: 'Кухонная мебель',
    subgroup: 'Кухонные гарнитуры',
    subgroupType: 'Кантри',
    name: 'Кухня "Кантри" 2.3м',
    article: 'KM-008',
    unit: 'шт',
    description: 'Кухня в деревенском стиле 2.3 метра',
    expirationDate: '2025-12-31',
    price1: '72000.00',
    price2: '64800.00',
    price3: '57600.00',
    price4: '50400.00',
    price5: '43200.00',
    price6: '36000.00',
    price7: '28800.00',
    addedBy: 'maria.sidorova',
    addedDate: '2024-01-17',
    modifiedBy: 'maria.sidorova',
    modifiedDate: '2024-01-22',
    filePath: '',
  ),
  Catalog(
    code: 'OP009',
    group: 'Кухонная мебель',
    subgroup: 'Кухонные гарнитуры',
    subgroupType: 'Арт-деко',
    name: 'Кухня "Арт-деко" 2.8м',
    article: 'KM-009',
    unit: 'шт',
    description: 'Кухня в стиле арт-деко 2.8 метра',
    expirationDate: '2025-12-31',
    price1: '98000.00',
    price2: '88200.00',
    price3: '78400.00',
    price4: '68600.00',
    price5: '58800.00',
    price6: '49000.00',
    price7: '39200.00',
    addedBy: 'alex.kuznetsov',
    addedDate: '2024-01-18',
    modifiedBy: 'alex.kuznetsov',
    modifiedDate: '2024-01-23',
    filePath: '',
  ),
  Catalog(
    code: 'OP010',
    group: 'Кухонная мебель',
    subgroup: 'Кухонные гарнитуры',
    subgroupType: 'Неоклассика',
    name: 'Кухня "Неоклассика" 3.0м',
    article: 'KM-010',
    unit: 'шт',
    description: 'Кухня в неоклассическом стиле 3 метра',
    expirationDate: '2025-12-31',
    price1: '105000.00',
    price2: '94500.00',
    price3: '84000.00',
    price4: '73500.00',
    price5: '63000.00',
    price6: '52500.00',
    price7: '42000.00',
    addedBy: 'ivan.petrov',
    addedDate: '2024-01-19',
    modifiedBy: 'ivan.petrov',
    modifiedDate: '2024-01-24',
    filePath: '',
  ),
];

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final List<Catalog> _catalogs = [...initialCatalogs];
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
      // Заголовки CSV-файла с соответствующими полями
      String content = 'Код ОП;Группа;Подгруппа;Тип подгруппы;Название;Артикул;Ед. изм.;Описание;Срок действия;'
          'Цена1;Цена2;Цена3;Цена4;Цена5;Цена6;Цена7;Добавил;Дата;Изменил;Изменено;Путь\n';
          
      for (var catalog in _catalogs) {
        content += '${catalog.code};${catalog.group};${catalog.subgroup};${catalog.subgroupType};'
            '${catalog.name};${catalog.article};${catalog.unit};${catalog.description};${catalog.expirationDate};'
            '${catalog.price1};${catalog.price2};${catalog.price3};${catalog.price4};${catalog.price5};'
            '${catalog.price6};${catalog.price7};${catalog.addedBy};${catalog.addedDate};'
            '${catalog.modifiedBy};${catalog.modifiedDate};${catalog.filePath}\n';
      }
      
      String? directory = await FilePicker.platform.getDirectoryPath();
      if (directory != null) {
        final now = DateTime.now();
        final fileName = 'export_catalogs_${DateFormat('yyyyMMdd_HHmmss').format(now)}.csv';
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

  void _createNewProduct() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController codeController = TextEditingController();
        final TextEditingController groupController = TextEditingController();
        final TextEditingController subgroupController = TextEditingController();
        final TextEditingController nameController = TextEditingController();
        final TextEditingController articleController = TextEditingController(
          text: 'ART-${_catalogs.length + 1}'
        );
        final TextEditingController descriptionController = TextEditingController();
        
        return AlertDialog(
          title: const Text('Новый товар'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: codeController,
                  decoration: const InputDecoration(
                    labelText: 'Код ОП',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: groupController,
                  decoration: const InputDecoration(
                    labelText: 'Группа',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: subgroupController,
                  decoration: const InputDecoration(
                    labelText: 'Подгруппа',
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
                  controller: articleController,
                  decoration: const InputDecoration(
                    labelText: 'Артикул',
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
                final now = DateTime.now();
                final formattedDate = _formatDate(now);
                
                setState(() {
                  _catalogs.add(Catalog(
                    code: codeController.text,
                    group: groupController.text.isNotEmpty ? groupController.text : 'Новая группа',
                    subgroup: subgroupController.text.isNotEmpty ? subgroupController.text : 'Новая подгруппа',
                    subgroupType: '',
                    name: nameController.text.isNotEmpty ? nameController.text : 'Новый товар',
                    article: articleController.text.isNotEmpty ? articleController.text : 'ART-${_catalogs.length + 1}',
                    unit: 'шт',
                    description: descriptionController.text,
                    expirationDate: '30.12.9999',
                    price1: '',
                    price2: '',
                    price3: '',
                    price4: '',
                    price5: '',
                    price6: '',
                    price7: '',
                    addedBy: 'Текущий пользователь',
                    addedDate: formattedDate,
                    modifiedBy: 'Текущий пользователь',
                    modifiedDate: formattedDate,
                    filePath: '',
                  ));
                });
                
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Новый товар создан'),
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
                'Всего записей: ${_getFilteredCatalogs().length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Новый документ'),
                    onPressed: _createNewProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  // const SizedBox(width: 8),
                  // ElevatedButton.icon(
                  //   icon: const Icon(Icons.upload_file),
                  //   label: const Text('Загрузить файл'),
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
   List<Catalog> _getFilteredCatalogs() {
    if (_searchQuery.isEmpty) return _catalogs;
    
    final query = _searchQuery.toLowerCase();
    return _catalogs.where((catalog) {
      return catalog.toMap().values.any(
            (value) => value.toLowerCase().contains(query),
          );
    }).toList();
  }

  Widget _buildDataTableView() {
    final filteredCatalogs = _getFilteredCatalogs();
    
    if (filteredCatalogs.isEmpty) {
      return const Center(
        child: Text(
          'Нет записей для отображения',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
    
    final List<Map<String, dynamic>> catalogsData = filteredCatalogs.map((catalog) => catalog.toMap()).toList();
    
    return UniversalResponsiveTable(
      data: catalogsData,
              columns: [
        'Код ОП', 'Группа', 'Подгруппа', 'Тип подгруппы', 'Название', 'Артикул', 
        'Ед. изм.', 'Описание', 'Срок действия', 'Цена1', 'Цена2', 'Цена3', 
        'Цена4', 'Цена5', 'Цена6', 'Цена7', 'Добавил', 'Дата', 'Изменил', 'Изменено'
      ],
      columnKeys: [
        'Код ОП', 'Группа', 'Подгруппа', 'Тип подгруппы', 'Название', 'Артикул', 
        'Ед. изм.', 'Описание', 'Срок действия', 'Цена1', 'Цена2', 'Цена3', 
        'Цена4', 'Цена5', 'Цена6', 'Цена7', 'Добавил', 'Дата', 'Изменил', 'Изменено'
      ],
      onEdit: (index, field, value) {
        final catalog = filteredCatalogs[index];
        final updatedCatalog = catalog.copyWithField(field, value.toString());
        setState(() {
          _catalogs[_catalogs.indexOf(catalog)] = updatedCatalog;
        });
      },
      onDelete: (index) {
        setState(() {
          _catalogs.removeAt(index);
        });
      },
      onAdd: () {
        _createNewProduct();
      },
      primaryColor: Theme.of(context).colorScheme.primary,
      showFileUpload: true,
      columnTypes: {
        'Цена1': 'number',
        'Цена2': 'number',
        'Цена3': 'number',
        'Цена4': 'number',
        'Цена5': 'number',
        'Цена6': 'number',
        'Цена7': 'number',
        'Срок действия': 'date',
        'Дата': 'date',
        'Изменено': 'date',
      },
    );
  }
}