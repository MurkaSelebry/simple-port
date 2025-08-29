import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class Group {
  String headName;      // Название головного
  String headCode;      // Код головного (Вес)
  String name;         // Название
  String code;         // Код
  String city;         // Город
  String address;      // Адрес
  String phone;        // Телефон
  String users;        // Пользователей
  String subsidiaries;      // Допустим

  Group({
    required this.headName,
    required this.headCode,
    required this.name,
    required this.code,
    required this.city,
    required this.address,
    required this.phone,
    required this.users,
    required this.subsidiaries,
  });

  factory Group.fromMap(Map<String, String> map) {
    return Group(
      headName: map['Название головного'] ?? '',
      headCode: map['Код головного'] ?? '',
      name: map['Название'] ?? '',
      code: map['Код'] ?? '',
      city: map['Город'] ?? '',
      address: map['Адрес'] ?? '',
      phone: map['Телефон'] ?? '',
      users: map['Пользователей'] ?? '',
      subsidiaries: map['Дочерних'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'Название головного': headName,
      'Код головного': headCode,
      'Название': name,
      'Код': code,
      'Город': city,
      'Адрес': address,
      'Телефон': phone,
      'Пользователей': users,
      'Дочерних': subsidiaries,
    };
  }
}

// Начальные данные для примера
final List<Group> initialGroups = [
  Group(
    headName: 'Группа 1',
    headCode: '001',
    name: 'Подгруппа 1',
    code: '001-1',
    city: 'Москва',
    address: 'ул. Ленина, 1',
    phone: '+7 (495) 111-11-11',
    users: '5',
    subsidiaries: 'Да',
  ),
  Group(
    headName: 'Группа 1',
    headCode: '001',
    name: 'Подгруппа 2',
    code: '001-2',
    city: 'Москва',
    address: 'ул. Ленина, 2',
    phone: '+7 (495) 222-22-22',
    users: '3',
    subsidiaries: 'Да',
  ),
  Group(
    headName: 'Группа 2',
    headCode: '002',
    name: 'Подгруппа 1',
    code: '002-1',
    city: 'Санкт-Петербург',
    address: 'Невский пр., 10',
    phone: '+7 (812) 333-33-33',
    users: '7',
    subsidiaries: 'Нет',
  ),
];

class StructureOfSalesDepartments extends StatefulWidget {
  const StructureOfSalesDepartments({super.key});

  @override
  _StructureOfSalesDepartmentsState createState() => _StructureOfSalesDepartmentsState();
}

class _StructureOfSalesDepartmentsState extends State<StructureOfSalesDepartments> {
  final List<Group> _groups = [...initialGroups];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isAscending = true;
  String _sortField = 'Название головного';
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

  void _toggleSort(String field) {
    setState(() {
      _isAscending = _sortField == field ? !_isAscending : true;
      _sortField = field;

      _groups.sort((a, b) {
        final valueA = a.toMap()[field] ?? '';
        final valueB = b.toMap()[field] ?? '';
        return _isAscending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
      });
    });
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

  Widget _buildEditableCell(String value, int index, String field) {
    return InkWell(
      onTap: () => _showEditDialog(index, field, value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
            maxLines: 1,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedGroup = _updateGroupField(_groups[index], field, controller.text);
                setState(() {
                  _groups[index] = updatedGroup;
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

  Group _updateGroupField(Group group, String field, String value) {
    switch (field) {
      case 'Название головного':
        return group.copyWith(headName: value);
      case 'Код головного':
        return group.copyWith(headCode: value);
      case 'Название':
        return group.copyWith(name: value);
      case 'Код':
        return group.copyWith(code: value);
      case 'Город':
        return group.copyWith(city: value);
      case 'Адрес':
        return group.copyWith(address: value);
      case 'Телефон':
        return group.copyWith(phone: value);
      case 'Пользователей':
        return group.copyWith(users: value);
      case 'Дочерних':
        return group.copyWith(subsidiaries: value);
      default:
        return group;
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
                  _groups.removeAt(index);
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

  void _createNewGroup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController = TextEditingController();
        
        return AlertDialog(
          title: const Text('Новая структура'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Название структуры',
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
                  _groups.add(Group(
                    headName: nameController.text.isNotEmpty ? nameController.text : 'Новая группа',
                    headCode: (_groups.length + 1).toString().padLeft(3, '0'),
                    name: 'Подгруппа 1',
                    code: '${_groups.length + 1}-1',
                    city: '',
                    address: '',
                    phone: '',
                    users: '0',
                    subsidiaries: 'Да',
                  ));
                });
                
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Новая структура создана'),
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

  void _exportToCsv() async {
    // try {
    //   String content = 'Имя пользователя;Почта;Количество ролей;Роли;Количество групп;Активирован;Добавил;Дата добавления\n';
          
    //   for (var user in _groups) {
    //     content += '${user.username};${user.email};${user.roles.length};${user.roles.join(", ")};${user.groupsCount};'
    //         '${user.isActive ? "Да" : "Нет"};${user.addedBy};${user.addedDate}\n';
    //   }
      
    //   String? directory = await FilePicker.platform.getDirectoryPath();
    //   if (directory != null) {
    //     final now = DateTime.now();
    //     final fileName = 'export_users_${DateFormat('yyyyMMdd_HHmmss').format(now)}.csv';
    //     final file = File('$directory/$fileName');
    //     await file.writeAsString(content);
        
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text('Файл сохранен как $fileName'),
    //         backgroundColor: Colors.green,
    //         duration: const Duration(seconds: 3),
    //       ),
    //     );
    //   }
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Ошибка при экспорте: ${e.toString()}'),
    //       backgroundColor: Colors.red,
    //       duration: const Duration(seconds: 3),
    //     ),
    //   );
    // }
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
                'Всего записей: ${_getFilteredGroups().length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Новая структура'),
                    onPressed: _createNewGroup,
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

  List<Group> _getFilteredGroups() {
    if (_searchQuery.isEmpty) return _groups;
    
    final query = _searchQuery.toLowerCase();
    return _groups.where((group) {
      return group.toMap().values.any(
            (value) => value.toLowerCase().contains(query),
          );
    }).toList();
  }

  Widget _buildDataTableView() {
    final filteredGroups = _getFilteredGroups();
    
    if (filteredGroups.isEmpty) {
      return const Center(
        child: Text(
          'Нет записей для отображения',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
    
  return LayoutBuilder(
    builder: (context, constraints) {
      final availableWidth = constraints.maxWidth;
      
    return Scrollbar(
      controller: _verticalScrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _horizontalScrollController,
        child: Container(
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Вычисляем ширину для каждой колонки
              final totalWidth = constraints.maxWidth;
              final actionWidth = 350.0;
              final remainingWidth = totalWidth - actionWidth;
              
              final descriptionWidth = remainingWidth * 0.35;
              final fileNameWidth = remainingWidth * 0.25;
              final addedByWidth = remainingWidth * 0.2;
              final dateWidth = remainingWidth * 0.1;
              final statusWidth = remainingWidth * 0.1;

            return DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.blue[50]),
              dataRowMinHeight: 60,
              dataRowMaxHeight: 80,
              columnSpacing: 20, 
              horizontalMargin: 16,
              dividerThickness: 1,
              showCheckboxColumn: false,
              columns: [
                DataColumn(label: _buildSortableColumnHeader('Название головного')),
                DataColumn(label: _buildSortableColumnHeader('Код головного')),
                DataColumn(label: _buildSortableColumnHeader('Название')),
                DataColumn(label: _buildSortableColumnHeader('Код')),
                DataColumn(label: _buildSortableColumnHeader('Город')),
                DataColumn(label: _buildSortableColumnHeader('Адрес')),
                DataColumn(label: _buildSortableColumnHeader('Телефон')),
                DataColumn(label: _buildSortableColumnHeader('Пользователей')),
                DataColumn(label: _buildSortableColumnHeader('Дочерних')),
                const DataColumn(
                  label: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Действия', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
              rows: filteredGroups.asMap().entries.map((entry) {
                final index = entry.key;
                final group = entry.value;
                return DataRow(
                  color: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (index % 2 == 0) return Colors.grey[100];
                      return null;
                    },
                  ),
                  cells: [
                    DataCell(_buildEditableCell(group.headName, index, 'Название головного')),
                    DataCell(_buildEditableCell(group.headCode, index, 'Код головного')),
                    DataCell(_buildEditableCell(group.name, index, 'Название')),
                    DataCell(_buildEditableCell(group.code, index, 'Код')),
                    DataCell(_buildEditableCell(group.city, index, 'Город')),
                    DataCell(_buildEditableCell(group.address, index, 'Адрес')),
                    DataCell(_buildEditableCell(group.phone, index, 'Телефон')),
                    DataCell(_buildEditableCell(group.users, index, 'Пользователей')),
                    DataCell(_buildEditableCell(group.subsidiaries, index, 'Дочерних')),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
            );
            }
          ),
        ),
        ),
      );
    }
    );
  }
}

extension GroupCopyWith on Group {
  Group copyWith({
    String? headName,
    String? headCode,
    String? name,
    String? code,
    String? city,
    String? address,
    String? phone,
    String? users,
    String? subsidiaries,
  }) {
    return Group(
      headName: headName ?? this.headName,
      headCode: headCode ?? this.headCode,
      name: name ?? this.name,
      code: code ?? this.code,
      city: city ?? this.city,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      users: users ?? this.users,
      subsidiaries: subsidiaries ?? this.subsidiaries,
    );
  }
}