import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../common/universal_responsive_table.dart';

// Обновленная модель данных для каталога с полями, соответствующими новому скриншоту
class Catalog {
  String codeOP;        // Код ОП
  String name;          // Название
  String group;         // Группа
  String subgroup;      // Подгруппа
  bool isHidden;        // Скрытое
  bool isExportable;    // Экспортируемое
  String externalCode;  // Внешний код
  String externalDesc;  // Внешний код описание
  String addedBy;       // Добавил
  String addedDate;     // Дата
  String modifiedBy;    // Изменил
  String modifiedDate;  // Изменено
  String description;   // Описание (дополнительно)
  String filePath;      // Путь к файлу

  Catalog({
    required this.codeOP,
    required this.name,
    required this.group,
    required this.subgroup,
    required this.isHidden,
    required this.isExportable,
    required this.externalCode,
    required this.externalDesc,
    required this.addedBy,
    required this.addedDate,
    required this.modifiedBy,
    required this.modifiedDate,
    required this.description,
    required this.filePath,
  });

  factory Catalog.fromMap(Map<String, dynamic> map) {
    return Catalog(
      codeOP: map['Код ОП'] ?? '',
      name: map['Название'] ?? '',
      group: map['Группа'] ?? '',
      subgroup: map['Подгруппа'] ?? '',
      isHidden: map['Скрытое'] == true || map['Скрытое'] == 'true',
      isExportable: map['Экспортируемое'] == true || map['Экспортируемое'] == 'true',
      externalCode: map['Внешний код'] ?? '',
      externalDesc: map['Внешний код описание'] ?? '',
      addedBy: map['Добавил'] ?? '',
      addedDate: map['Дата'] ?? '',
      modifiedBy: map['Изменил'] ?? '',
      modifiedDate: map['Изменено'] ?? '',
      description: map['Описание'] ?? '',
      filePath: map['Путь'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Код ОП': codeOP,
      'Название': name,
      'Группа': group,
      'Подгруппа': subgroup,
      'Скрытое': isHidden,
      'Экспортируемое': isExportable,
      'Внешний код': externalCode,
      'Внешний код описание': externalDesc,
      'Добавил': addedBy,
      'Дата': addedDate,
      'Изменил': modifiedBy,
      'Изменено': modifiedDate,
      'Описание': description,
      'Путь': filePath,
    };
  }

  Catalog copyWith({
    String? codeOP,
    String? name,
    String? group,
    String? subgroup,
    bool? isHidden,
    bool? isExportable,
    String? externalCode,
    String? externalDesc,
    String? addedBy,
    String? addedDate,
    String? modifiedBy,
    String? modifiedDate,
    String? description,
    String? filePath,
  }) {
    return Catalog(
      codeOP: codeOP ?? this.codeOP,
      name: name ?? this.name,
      group: group ?? this.group,
      subgroup: subgroup ?? this.subgroup,
      isHidden: isHidden ?? this.isHidden,
      isExportable: isExportable ?? this.isExportable,
      externalCode: externalCode ?? this.externalCode,
      externalDesc: externalDesc ?? this.externalDesc,
      addedBy: addedBy ?? this.addedBy,
      addedDate: addedDate ?? this.addedDate,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      description: description ?? this.description,
      filePath: filePath ?? this.filePath,
    );
  }

  // Метод для обновления одного поля по его названию
  Catalog copyWithField(String field, dynamic value) {
    switch (field) {
      case 'Код ОП':
        return copyWith(codeOP: value);
      case 'Название':
        return copyWith(name: value);
      case 'Группа':
        return copyWith(group: value);
      case 'Подгруппа':
        return copyWith(subgroup: value);
      case 'Скрытое':
        return copyWith(isHidden: value is bool ? value : (value == 'true'));
      case 'Экспортируемое':
        return copyWith(isExportable: value is bool ? value : (value == 'true'));
      case 'Внешний код':
        return copyWith(externalCode: value);
      case 'Внешний код описание':
        return copyWith(externalDesc: value);
      case 'Добавил':
        return copyWith(addedBy: value);
      case 'Дата':
        return copyWith(addedDate: value);
      case 'Изменил':
        return copyWith(modifiedBy: value);
      case 'Изменено':
        return copyWith(modifiedDate: value);
      case 'Описание':
        return copyWith(description: value);
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
    codeOP: 'DP001',
    name: 'Материал фасада',
    group: 'Кухонная мебель',
    subgroup: 'Кухонные гарнитуры',
    isHidden: false,
    isExportable: true,
    externalCode: 'MF-001',
    externalDesc: 'Материал фасада кухонного гарнитура',
    addedBy: 'ivan.petrov',
    addedDate: '2024-01-10',
    modifiedBy: 'maria.sidorova',
    modifiedDate: '2024-01-15',
    description: 'Материал фасада кухонного гарнитура',
    filePath: '',
  ),
  Catalog(
    codeOP: 'DP002',
    name: 'Цвет фасада',
    group: 'Кухонная мебель',
    subgroup: 'Кухонные гарнитуры',
    isHidden: false,
    isExportable: true,
    externalCode: 'CF-001',
    externalDesc: 'Цвет фасада кухонного гарнитура',
    addedBy: 'dmitry.kozlov',
    addedDate: '2024-01-11',
    modifiedBy: 'dmitry.kozlov',
    modifiedDate: '2024-01-16',
    description: 'Цвет фасада кухонного гарнитура',
    filePath: '',
  ),
  Catalog(
    codeOP: 'DP003',
    name: 'Материал столешницы',
    group: 'Кухонная мебель',
    subgroup: 'Кухонные гарнитуры',
    isHidden: false,
    isExportable: true,
    externalCode: 'MS-001',
    externalDesc: 'Материал столешницы кухонного гарнитура',
    addedBy: 'maria.sidorova',
    addedDate: '2024-01-12',
    modifiedBy: 'maria.sidorova',
    modifiedDate: '2024-01-17',
    description: 'Материал столешницы кухонного гарнитура',
    filePath: '',
  ),
  Catalog(
    codeOP: 'DP004',
    name: 'Фурнитура',
    group: 'Кухонная мебель',
    subgroup: 'Кухонные гарнитуры',
    isHidden: false,
    isExportable: true,
    externalCode: 'FU-001',
    externalDesc: 'Фурнитура для кухонного гарнитура',
    addedBy: 'alex.kuznetsov',
    addedDate: '2024-01-13',
    modifiedBy: 'alex.kuznetsov',
    modifiedDate: '2024-01-18',
    description: 'Фурнитура для кухонного гарнитура',
    filePath: '',
  ),
  Catalog(
    codeOP: 'DP005',
    name: 'Размеры',
    group: 'Кухонная мебель',
    subgroup: 'Кухонные гарнитуры',
    isHidden: false,
    isExportable: true,
    externalCode: 'SZ-001',
    externalDesc: 'Размеры кухонного гарнитура',
    addedBy: 'anna.morozova',
    addedDate: '2024-01-14',
    modifiedBy: 'anna.morozova',
    modifiedDate: '2024-01-19',
    description: 'Размеры кухонного гарнитура',
    filePath: '',
  ),
  Catalog(
    codeOP: 'DP006',
    name: 'Тип открывания',
    group: 'Кухонная мебель',
    subgroup: 'Кухонные гарнитуры',
    isHidden: false,
    isExportable: true,
    externalCode: 'TO-001',
    externalDesc: 'Тип открывания дверей кухонного гарнитура',
    addedBy: 'ivan.petrov',
    addedDate: '2024-01-15',
    modifiedBy: 'ivan.petrov',
    modifiedDate: '2024-01-20',
    description: 'Тип открывания дверей кухонного гарнитура',
    filePath: '',
  ),
  Catalog(
    codeOP: 'DP007',
    name: 'Подсветка',
    group: 'Кухонная мебель',
    subgroup: 'Кухонные гарнитуры',
    isHidden: false,
    isExportable: true,
    externalCode: 'PL-001',
    externalDesc: 'Подсветка кухонного гарнитура',
    addedBy: 'dmitry.kozlov',
    addedDate: '2024-01-16',
    modifiedBy: 'dmitry.kozlov',
    modifiedDate: '2024-01-21',
    description: 'Подсветка кухонного гарнитура',
    filePath: '',
  ),
  Catalog(
    codeOP: 'DP008',
    name: 'Декор',
    group: 'Кухонная мебель',
    subgroup: 'Кухонные гарнитуры',
    isHidden: false,
    isExportable: true,
    externalCode: 'DC-001',
    externalDesc: 'Декоративные элементы кухонного гарнитура',
    addedBy: 'maria.sidorova',
    addedDate: '2024-01-17',
    modifiedBy: 'maria.sidorova',
    modifiedDate: '2024-01-22',
    description: 'Декоративные элементы кухонного гарнитура',
    filePath: '',
  ),
  Catalog(
    codeOP: 'DP009',
    name: 'Покрытие',
    group: 'Кухонная мебель',
    subgroup: 'Кухонные гарнитуры',
    isHidden: false,
    isExportable: true,
    externalCode: 'PC-001',
    externalDesc: 'Покрытие кухонного гарнитура',
    addedBy: 'alex.kuznetsov',
    addedDate: '2024-01-18',
    modifiedBy: 'alex.kuznetsov',
    modifiedDate: '2024-01-23',
    description: 'Покрытие кухонного гарнитура',
    filePath: '',
  ),
  Catalog(
    codeOP: 'DP010',
    name: 'Стиль',
    group: 'Кухонная мебель',
    subgroup: 'Кухонные гарнитуры',
    isHidden: false,
    isExportable: true,
    externalCode: 'ST-001',
    externalDesc: 'Стиль кухонного гарнитура',
    addedBy: 'ivan.petrov',
    addedDate: '2024-01-19',
    modifiedBy: 'ivan.petrov',
    modifiedDate: '2024-01-24',
    description: 'Стиль кухонного гарнитура',
    filePath: '',
  ),
];

class DynamicProperties extends StatefulWidget {
  const DynamicProperties({super.key});

  @override
  _DynamicPropertiesState createState() => _DynamicPropertiesState();
}

class _DynamicPropertiesState extends State<DynamicProperties> {
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
    return DateFormat('dd.MM.yyyy, HH:mm').format(date);
  }





  void _exportToCsv() async {
    try {
      String content = 'Код ОП;Название;Группа;Подгруппа;Скрытое;Экспортируемое;'
          'Внешний код;Внешний код описание;Добавил;Дата;Изменил;Изменено;Описание;Путь\n';
          
      for (var catalog in _catalogs) {
        content += '${catalog.codeOP};${catalog.name};${catalog.group};${catalog.subgroup};'
            '${catalog.isHidden ? "Да" : "Нет"};${catalog.isExportable ? "Да" : "Нет"};'
            '${catalog.externalCode};${catalog.externalDesc};${catalog.addedBy};${catalog.addedDate};'
            '${catalog.modifiedBy};${catalog.modifiedDate};${catalog.description};${catalog.filePath}\n';
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

  void _createNewCatalog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController codeOPController = TextEditingController(
          text: 'OP${_catalogs.length + 1}'.padLeft(5, '0')
        );
        final TextEditingController nameController = TextEditingController();
        final TextEditingController groupController = TextEditingController();
        final TextEditingController subgroupController = TextEditingController();
        final TextEditingController externalCodeController = TextEditingController(
          text: 'EXT${_catalogs.length + 1}'.padLeft(5, '0')
        );
        final TextEditingController externalDescController = TextEditingController();
        
        bool isHidden = false;
        bool isExportable = true;
        
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Новый документ'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: codeOPController,
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
                    Row(
                      children: [
                        const Text('Скрытое:'),
                        Switch(
                          value: isHidden,
                          onChanged: (value) {
                            setState(() {
                              isHidden = value;
                            });
                          },
                        ),
                        Text(isHidden ? 'Да' : 'Нет'),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Экспортируемое:'),
                        Switch(
                          value: isExportable,
                          onChanged: (value) {
                            setState(() {
                              isExportable = value;
                            });
                          },
                        ),
                        Text(isExportable ? 'Да' : 'Нет'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: externalCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Внешний код',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: externalDescController,
                      decoration: const InputDecoration(
                        labelText: 'Внешний код описание',
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
                    
                    this.setState(() {
                      _catalogs.add(Catalog(
                        codeOP: codeOPController.text.isNotEmpty ? codeOPController.text : 'OP${_catalogs.length + 1}',
                        name: nameController.text.isNotEmpty ? nameController.text : 'Новый документ',
                        group: groupController.text.isNotEmpty ? groupController.text : 'Новая группа',
                        subgroup: subgroupController.text.isNotEmpty ? subgroupController.text : 'Новая подгруппа',
                        isHidden: isHidden,
                        isExportable: isExportable,
                        externalCode: externalCodeController.text.isNotEmpty ? externalCodeController.text : 'EXT${_catalogs.length + 1}',
                        externalDesc: externalDescController.text.isNotEmpty ? externalDescController.text : '---',
                        addedBy: 'Текущий пользователь',
                        addedDate: formattedDate,
                        modifiedBy: 'Текущий пользователь',
                        modifiedDate: formattedDate,
                        description: '---',
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
          }
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
                    onPressed: _createNewCatalog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),

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
      columns: ['Код ОП', 'Название', 'Группа', 'Подгруппа', 'Скрытое', 'Экспортируемое', 'Внешний код', 'Внешний код описание', 'Добавил', 'Дата', 'Изменил', 'Изменено', 'Описание'],
      columnKeys: ['Код ОП', 'Название', 'Группа', 'Подгруппа', 'Скрытое', 'Экспортируемое', 'Внешний код', 'Внешний код описание', 'Добавил', 'Дата', 'Изменил', 'Изменено', 'Описание'],
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
        _createNewCatalog();
      },
      primaryColor: Theme.of(context).colorScheme.primary,
      showFileUpload: true,
      columnTypes: {
        'Дата': 'date',
        'Изменено': 'date',
      },
    );
  }
}
