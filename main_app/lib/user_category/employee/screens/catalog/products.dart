import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

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
    code: '',
    group: 'Прочее',
    subgroup: 'Базис-прочее',
    subgroupType: 'Комплектующие-Базис',
    name: 'Прочее',
    article: 'F-R-Pro',
    unit: 'шт',
    description: '',
    expirationDate: '01.01.1',
    price1: '',
    price2: '',
    price3: '',
    price4: '',
    price5: '',
    price6: '',
    price7: '',
    addedBy: 'Anton',
    addedDate: '31.08.2022',
    modifiedBy: 'Anton',
    modifiedDate: '31.08.2022',
    filePath: '',
  ),
  Catalog(
    code: '',
    group: 'Комплектующие: Метизы',
    subgroup: 'Метизы',
    subgroupType: '',
    name: 'Стяжка эксцентриковая двойная 15х34',
    article: 'F-M-EKS-15x34-2',
    unit: 'шт',
    description: '',
    expirationDate: '30.12.9999',
    price1: '',
    price2: '',
    price3: '',
    price4: '',
    price5: '',
    price6: '',
    price7: '',
    addedBy: 'N.Kamakin',
    addedDate: '31.08.2022',
    modifiedBy: 's.evstratova',
    modifiedDate: '23.06.2023',
    filePath: '',
  ),
  Catalog(
    code: '',
    group: 'Комплектующие: Метизы',
    subgroup: 'Полкодержатели',
    subgroupType: '',
    name: 'Полкодержатель KDS-090 под саморез',
    article: 'F-M-KDS090-SMR',
    unit: 'шт',
    description: 'Полкодержатель для стеклянных полок толщиной',
    expirationDate: '30.12.9999',
    price1: '',
    price2: '',
    price3: '',
    price4: '',
    price5: '',
    price6: '',
    price7: '',
    addedBy: 'N.Kamakin',
    addedDate: '31.08.2022',
    modifiedBy: 's.evstratova',
    modifiedDate: '23.06.2023',
    filePath: '',
  ),
  Catalog(
    code: '',
    group: 'Комплектующие: Петли',
    subgroup: 'Петли Blum',
    subgroupType: '',
    name: 'Петля CLIP top фальшпанель 6/пружины вклад',
    article: 'F-P-BL-CT-FP90-BP-VKL',
    unit: 'компл',
    description: '',
    expirationDate: '',
    price1: '',
    price2: '',
    price3: '',
    price4: '',
    price5: '',
    price6: '',
    price7: '',
    addedBy: '',
    addedDate: '',
    modifiedBy: '',
    modifiedDate: '',
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
  bool _isAscending = true;
  String _sortField = 'Название';
  bool _isLoading = false;
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

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
    return DateFormat('dd.MM.yyyy').format(date);
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
            // Обновляем существующий каталог
            _catalogs[index] = _catalogs[index].copyWith(
              description: fileName,
              filePath: file.path,
              modifiedBy: 'Текущий пользователь',
              modifiedDate: _formatDate(DateTime.now()),
            );
          } else {
            // Добавляем новый каталог
            _catalogs.add(Catalog(
              code: '',
              group: 'Новая группа',
              subgroup: 'Новая подгруппа',
              subgroupType: '',
              name: fileName,
              article: 'ART-${_catalogs.length + 1}',
              unit: 'шт',
              description: 'Новый документ',
              expirationDate: '30.12.9999',
              price1: '',
              price2: '',
              price3: '',
              price4: '',
              price5: '',
              price6: '',
              price7: '',
              addedBy: 'Текущий пользователь',
              addedDate: _formatDate(DateTime.now()),
              modifiedBy: 'Текущий пользователь',
              modifiedDate: _formatDate(DateTime.now()),
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
                  _catalogs.removeAt(index);
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

      _catalogs.sort((a, b) {
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
                final updatedCatalog = _catalogs[index].copyWithField(field, controller.text);
                // Обновляем поля модификации
                final modifiedCatalog = updatedCatalog.copyWith(
                  modifiedBy: 'Текущий пользователь',
                  modifiedDate: _formatDate(DateTime.now()),
                );
                setState(() {
                  _catalogs[index] = modifiedCatalog;
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
                // Столбцы как на предоставленном изображении
                DataColumn(label: _buildSortableColumnHeader('Код ОП')),
                DataColumn(label: _buildSortableColumnHeader('Группа')),
                DataColumn(label: _buildSortableColumnHeader('Подгруппа')),
                DataColumn(label: _buildSortableColumnHeader('Тип подгруппы')),
                DataColumn(label: _buildSortableColumnHeader('Название')),
                DataColumn(label: _buildSortableColumnHeader('Артикул')),
                DataColumn(label: _buildSortableColumnHeader('Ед. изм.')),
                DataColumn(label: _buildSortableColumnHeader('Описание')),
                DataColumn(label: _buildSortableColumnHeader('Срок действия')),
                DataColumn(label: _buildSortableColumnHeader('Цена1')),
                DataColumn(label: _buildSortableColumnHeader('Цена2')),
                DataColumn(label: _buildSortableColumnHeader('Цена3')),
                DataColumn(label: _buildSortableColumnHeader('Цена4')),
                DataColumn(label: _buildSortableColumnHeader('Цена5')),
                DataColumn(label: _buildSortableColumnHeader('Цена6')),
                DataColumn(label: _buildSortableColumnHeader('Цена7')),
                DataColumn(label: _buildSortableColumnHeader('Добавил')),
                DataColumn(label: _buildSortableColumnHeader('Дата')),
                DataColumn(label: _buildSortableColumnHeader('Изменил')),
                DataColumn(label: _buildSortableColumnHeader('Изменено')),
                const DataColumn(
                  label: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Действия', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
              rows: filteredCatalogs.asMap().entries.map((entry) {
                final index = entry.key;
                final catalog = entry.value;
                return DataRow(
                  color: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (index % 2 == 0) return Colors.grey[100];
                      return null;
                    },
                  ),
                  cells: [
                    DataCell(_buildEditableCell(catalog.code, index, 'Код ОП')),
                    DataCell(_buildEditableCell(catalog.group, index, 'Группа')),
                    DataCell(_buildEditableCell(catalog.subgroup, index, 'Подгруппа')),
                    DataCell(_buildEditableCell(catalog.subgroupType, index, 'Тип подгруппы')),
                    DataCell(_buildEditableCell(catalog.name, index, 'Название')),
                    DataCell(_buildEditableCell(catalog.article, index, 'Артикул')),
                    DataCell(_buildEditableCell(catalog.unit, index, 'Ед. изм.')),
                    DataCell(_buildEditableCell(catalog.description, index, 'Описание')),
                    DataCell(_buildEditableCell(catalog.expirationDate, index, 'Срок действия')),
                    DataCell(_buildEditableCell(catalog.price1, index, 'Цена1')),
                    DataCell(_buildEditableCell(catalog.price2, index, 'Цена2')),
                    DataCell(_buildEditableCell(catalog.price3, index, 'Цена3')),
                    DataCell(_buildEditableCell(catalog.price4, index, 'Цена4')),
                    DataCell(_buildEditableCell(catalog.price5, index, 'Цена5')),
                    DataCell(_buildEditableCell(catalog.price6, index, 'Цена6')),
                    DataCell(_buildEditableCell(catalog.price7, index, 'Цена7')),
                    DataCell(Text(catalog.addedBy)),
                    DataCell(Text(catalog.addedDate)),
                    DataCell(Text(catalog.modifiedBy)),
                    DataCell(Text(catalog.modifiedDate)),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (catalog.filePath.isEmpty)
                            IconButton(
                              icon: const Icon(Icons.upload, color: Colors.blue),
                              onPressed: () => _pickFile(index),
                              tooltip: 'Загрузить файл',
                            )
                          else
                            IconButton(
                              icon: const Icon(Icons.download, color: Colors.green),
                              onPressed: () => _downloadFile(catalog.filePath),
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
}