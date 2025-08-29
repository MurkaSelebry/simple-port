import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

// Обновленная модель данных для каталога с полями, соответствующими скриншоту
class Catalog {
  String group;         // Группа
  String subgroup;      // Подгруппа
  String name;          // Название
  String addedBy;       // Добавил
  String addedDate;     // Дата
  String modifiedBy;    // Изменил
  String modifiedDate;  // Изменено
  String description;   // Описание (дополнительно)
  String filePath;      // Путь к файлу

  Catalog({
    required this.group,
    required this.subgroup,
    required this.name,
    required this.addedBy,
    required this.addedDate,
    required this.modifiedBy,
    required this.modifiedDate,
    required this.description,
    required this.filePath,
  });

  factory Catalog.fromMap(Map<String, String> map) {
    return Catalog(
      group: map['Группа'] ?? '',
      subgroup: map['Подруппа'] ?? '',
      name: map['Название'] ?? '',
      addedBy: map['Добавил'] ?? '',
      addedDate: map['Дата'] ?? '',
      modifiedBy: map['Изменил'] ?? '',
      modifiedDate: map['Изменено'] ?? '',
      description: map['Описание'] ?? '',
      filePath: map['Путь'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'Группа': group,
      'Подруппа': subgroup,
      'Название': name,
      'Добавил': addedBy,
      'Дата': addedDate,
      'Изменил': modifiedBy,
      'Изменено': modifiedDate,
      'Описание': description,
      'Путь': filePath,
    };
  }

  Catalog copyWith({
    String? group,
    String? subgroup,
    String? name,
    String? addedBy,
    String? addedDate,
    String? modifiedBy,
    String? modifiedDate,
    String? description,
    String? filePath,
  }) {
    return Catalog(
      group: group ?? this.group,
      subgroup: subgroup ?? this.subgroup,
      name: name ?? this.name,
      addedBy: addedBy ?? this.addedBy,
      addedDate: addedDate ?? this.addedDate,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      description: description ?? this.description,
      filePath: filePath ?? this.filePath,
    );
  }

  Catalog copyWithField(String field, String value) {
    switch (field) {
      case 'Группа':
        return copyWith(group: value);
      case 'Подруппа':
        return copyWith(subgroup: value);
      case 'Название':
        return copyWith(name: value);
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
    group: 'EXT001',
    subgroup: 'Мебель',
    name: 'Каталог №1',
    addedBy: 'Иванов А.П.',
    addedDate: '12.03.2025, 08:16',
    modifiedBy: 'Петров И.С.',
    modifiedDate: '14.03.2025, 10:23',
    description: 'Фасад для кухни',
    filePath: '',
  ),
  Catalog(
    group: 'EXT002',
    subgroup: 'Интерьер',
    name: 'Каталог №2',
    addedBy: 'Смирнова Е.В.',
    addedDate: '15.03.2025, 12:49',
    modifiedBy: 'Смирнова Е.В.',
    modifiedDate: '15.03.2025, 14:30',
    description: 'Шкаф-купе для спальни',
    filePath: '',
  ),
];

class TypesOfSubgroups extends StatefulWidget {
  const TypesOfSubgroups({super.key});

  @override
  _TypesOfSubgroupsState createState() => _TypesOfSubgroupsState();
}

class _TypesOfSubgroupsState extends State<TypesOfSubgroups> {
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
              group: 'EXT${_catalogs.length + 1}'.padLeft(6, '0'),
              subgroup: 'Новая группа',
              name: fileName,
              addedBy: 'Текущий пользователь',
              addedDate: _formatDate(DateTime.now()),
              modifiedBy: 'Текущий пользователь',
              modifiedDate: _formatDate(DateTime.now()),
              description: 'Новый документ',
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
      String content = 'Внешний код;Группа;Название;Добавил;Дата;Изменил;Изменено;Описание;Путь\n';
          
      for (var catalog in _catalogs) {
        content += '${catalog.group};${catalog.subgroup};${catalog.name};${catalog.addedBy};${catalog.addedDate};'
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
        final TextEditingController codeController = TextEditingController(
          text: 'EXT${_catalogs.length + 1}'.padLeft(6, '0')
        );
        final TextEditingController groupController = TextEditingController();
        final TextEditingController nameController = TextEditingController();
        final TextEditingController descriptionController = TextEditingController();
        
        return AlertDialog(
          title: const Text('Новый документ'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: codeController,
                  decoration: const InputDecoration(
                    labelText: 'Группа',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: groupController,
                  decoration: const InputDecoration(
                    labelText: 'Подруппа',
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
                final now = DateTime.now();
                final formattedDate = _formatDate(now);
                
                setState(() {
                  _catalogs.add(Catalog(
                    group: codeController.text.isNotEmpty ? codeController.text : 'EXT${_catalogs.length + 1}',
                    subgroup: groupController.text.isNotEmpty ? groupController.text : 'Новая группа',
                    name: nameController.text.isNotEmpty ? nameController.text : 'Новый документ',
                    addedBy: 'Текущий пользователь',
                    addedDate: formattedDate,
                    modifiedBy: 'Текущий пользователь',
                    modifiedDate: formattedDate,
                    description: descriptionController.text.isNotEmpty ? descriptionController.text : '---',
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
  
  return LayoutBuilder(
    builder: (context, constraints) {
      return Scrollbar(
        controller: _verticalScrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _verticalScrollController,
          child: Scrollbar(
            controller: _horizontalScrollController,
            thumbVisibility: true,
            notificationPredicate: (notification) => notification.depth == 1,
            child: SingleChildScrollView(
              controller: _horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth, // Растягиваем на всю ширину
                ),
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
                    DataColumn(label: _buildSortableColumnHeader('Группа')),
                    DataColumn(label: _buildSortableColumnHeader('Подгруппа')),
                    DataColumn(label: _buildSortableColumnHeader('Название')),
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
                        DataCell(_buildEditableCell(catalog.group, index, 'Группа')),
                        DataCell(_buildEditableCell(catalog.subgroup, index, 'Подгруппа')),
                        DataCell(_buildEditableCell(catalog.name, index, 'Название')),
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
        ),
      );
    },
  );
}
}