import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class Status {
  String priority;
  String name;
  String color;
  String type;
  bool byDefault;
  bool included;
  int roles;
  int transitions;
  bool notify;

  Status({
    required this.priority,
    required this.name,
    required this.color,
    required this.type,
    required this.byDefault,
    required this.included,
    required this.roles,
    required this.transitions,
    required this.notify,
  });

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      priority: map['Очередность'] ?? '',
      name: map['Название'] ?? '',
      color: map['Цвет'] ?? '',
      type: map['Тип'] ?? '',
      byDefault: map['По умолчанию'] ?? false,
      included: map['Включен'] ?? false,
      roles: map['Ролей'] ?? 0,
      transitions: map['Переходов'] ?? 0,
      notify: map['Уведомлять'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Очередность': priority,
      'Название': name,
      'Цвет': color,
      'Тип': type,
      'По умолчанию': byDefault,
      'Включен': included,
      'Ролей': roles,
      'Переходов': transitions,
      'Уведомлять': notify,
    };
  }

  Status copyWith({
    String? priority,
    String? name,
    String? color,
    String? type,
    bool? byDefault,
    bool? included,
    int? roles,
    int? transitions,
    bool? notify,
  }) {
    return Status(
      priority: priority ?? this.priority,
      name: name ?? this.name,
      color: color ?? this.color,
      type: type ?? this.type,
      byDefault: byDefault ?? this.byDefault,
      included: included ?? this.included,
      roles: roles ?? this.roles,
      transitions: transitions ?? this.transitions,
      notify: notify ?? this.notify,
    );
  }

  Status copyWithField(String field, dynamic value) {
    switch (field) {
      case 'Очередность':
        return copyWith(priority: value);
      case 'Название':
        return copyWith(name: value);
      case 'Цвет':
        return copyWith(color: value);
      case 'Тип':
        return copyWith(type: value);
      case 'По умолчанию':
        return copyWith(byDefault: value);
      case 'Включен':
        return copyWith(included: value);
      case 'Ролей':
        return copyWith(roles: value);
      case 'Переходов':
        return copyWith(transitions: value);
      case 'Уведомлять':
        return copyWith(notify: value);
      default:
        return this;
    }
  }
}

// Available roles list for selection
final List<String> availableRoles = [
  'Администратор',
  'Пользователь',
  'Менеджер',
  'Оператор',
  'Супервизор',
  'Модератор',
];

// Начальные данные для примера
final List<Status> initialUsers = [
  Status(
    priority: '1',
    name: 'Возвратная упаковка создана',
    color: '#e3d3fw3',
    type: 'Возвратная упаковка',
    byDefault: true,
    included: true,
    roles: 2,
    transitions: 4,
    notify: true,
  ),

  Status(
    priority: '2',
    name: 'Ожидание материалов',
    color: '#g3dfg3f',
    type: 'Склад Комплектации',
    byDefault: true,
    included: true,
    roles: 2,
    transitions: 4,
    notify: true,
  ),
];

class Statuses extends StatefulWidget {
  const Statuses({super.key});

  @override
  _StatusesState createState() => _StatusesState();
}

class _StatusesState extends State<Statuses> {
  final List<Status> _statuses = [...initialUsers];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isAscending = true;
  String _sortField = 'Очередность';
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

  void _removeUser(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение удаления'),
          content: Text('Вы уверены, что хотите удалить "${_statuses[index].name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _statuses.removeAt(index);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Удалено'),
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

  
  void _showEditNumberDialog(int index, String field, int initialValue) {
    final TextEditingController controller = TextEditingController(text: initialValue.toString());
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
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLines: 1,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _statuses[index] = _statuses[index].copyWithField(
                    field, 
                    int.tryParse(controller.text) ?? initialValue
                  );
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

  void _toggleSort(String field) {
    setState(() {
      _isAscending = _sortField == field ? !_isAscending : true;
      _sortField = field;

      _statuses.sort((a, b) {
        final valueA = a.toMap()[field] ?? '';
        final valueB = b.toMap()[field] ?? '';
        return _isAscending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
      });
    });
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
                setState(() {
                  _statuses[index] = _statuses[index].copyWithField(field, controller.text);
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
      String content = 'Очередность;Название;Цвет;Тип;По умолчанию;Включен;Ролей;Переходов;Уведомлять\n';
          
      for (var status in _statuses) {
        content += '${status.priority};${status.name};${status.color};${status.type};${status.byDefault ? "Да" : "Нет"};'
            '${status.included ? "Да" : "Нет"};${status.roles};${status.transitions};${status.notify ? "Да" : "Нет"}\n';
      }
      
      String? directory = await FilePicker.platform.getDirectoryPath();
      if (directory != null) {
        final now = DateTime.now();
        final fileName = 'export_statuses_${DateFormat('yyyyMMdd_HHmmss').format(now)}.csv';
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

  void _createNewStatus() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController priorityController = TextEditingController();
        final TextEditingController nameController = TextEditingController();
        final TextEditingController colorController = TextEditingController(text: '#FFFFFF');
        final TextEditingController typeController = TextEditingController();
        bool byDefault = true;
        bool included = true;
        final TextEditingController rolesController = TextEditingController(text: '0');
        final TextEditingController transitionsController = TextEditingController(text: '0');
        bool notify = true;
        
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Новый статус'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: priorityController,
                      decoration: const InputDecoration(
                        labelText: 'Очередность',
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
                      controller: colorController,
                      decoration: const InputDecoration(
                        labelText: 'Цвет',
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
                    SwitchListTile(
                      title: const Text('По умолчанию'),
                      value: byDefault,
                      onChanged: (value) {
                        setState(() {
                          byDefault = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      title: const Text('Включен'),
                      value: included,
                      onChanged: (value) {
                        setState(() {
                          included = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: rolesController,
                      decoration: const InputDecoration(
                        labelText: 'Ролей',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: transitionsController,
                      decoration: const InputDecoration(
                        labelText: 'Переходов',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      title: const Text('Уведомлять'),
                      value: notify,
                      onChanged: (value) {
                        setState(() {
                          notify = value;
                        });
                      },
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
                    if (priorityController.text.isEmpty || nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Заполните обязательные поля'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    
                    this.setState(() {
                      _statuses.add(Status(
                        priority: priorityController.text,
                        name: nameController.text,
                        color: colorController.text,
                        type: typeController.text,
                        byDefault: byDefault,
                        included: included,
                        roles: int.tryParse(rolesController.text) ?? 0,
                        transitions: int.tryParse(transitionsController.text) ?? 0,
                        notify: notify,
                      ));
                    });
                    
                    Navigator.of(context).pop();
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Новый статус создан'),
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

  Widget _buildEditableCell(dynamic value, int index, String field) {
    if (field == 'Очередность' || field == 'Название' || field == 'Цвет' || field == 'Тип') {
      return GestureDetector(
        onTap: () => _showEditDialog(index, field, value.toString()),
        child: Text(value.toString()),
      );
    } else if (field == 'Ролей' || field == 'Переходов') {
      return GestureDetector(
        onTap: () => _showEditNumberDialog(index, field, value as int),
        child: Text(value.toString()),
      );
    } else if (field == 'По умолчанию' || field == 'Включен' || field == 'Уведомлять') {
      return Switch(
        value: value as bool,
        onChanged: (newValue) {
          setState(() {
            _statuses[index] = _statuses[index].copyWithField(field, newValue);
          });
        },
      );
    } else {
      return Text(value.toString());
    }
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
                'Всего статусов: ${_getFilteredUsers().length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Новый статус'),
                    onPressed: _createNewStatus,
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

  List<Status> _getFilteredUsers() {
    if (_searchQuery.isEmpty) return _statuses;
    
    final query = _searchQuery.toLowerCase();
    return _statuses.where((status) {
      return status.priority.toLowerCase().contains(query) ||
             status.name.toLowerCase().contains(query) ||
             status.type.toLowerCase().contains(query) ||
             status.color.toLowerCase().contains(query);
    }).toList();
  }

 Widget _buildDataTableView() {
    final filteredStatuses = _getFilteredUsers();
    
    if (filteredStatuses.isEmpty) {
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
              decoration: BoxDecoration(color: Colors.white),
              headingRowColor: MaterialStateProperty.all(Colors.blue[50]),
              dataRowMinHeight: 60,
              dataRowMaxHeight: 80,
              columnSpacing: 20, 
              horizontalMargin: 16,
              dividerThickness: 1,
              showCheckboxColumn: false,
              columns: [
                DataColumn(
                  label: _buildSortableColumnHeader('Очередность'),
                ),
                DataColumn(
                  label: _buildSortableColumnHeader('Название'),
                ),
                DataColumn(
                  label: _buildSortableColumnHeader('Цвет'),
                ),
                DataColumn(
                  label: _buildSortableColumnHeader('Тип'),
                ),
                DataColumn(
                  label: _buildSortableColumnHeader('По умолчанию'),
                ),
                DataColumn(
                  label: _buildSortableColumnHeader('Включен'),
                ),
                DataColumn(
                  label: _buildSortableColumnHeader('Ролей'),
                ),
                DataColumn(
                  label: _buildSortableColumnHeader('Переходов'),
                ),
                DataColumn(
                  label: _buildSortableColumnHeader('Уведомлять'),
                ),
                const DataColumn(
                  label: Text('Действия'),
                ),
              ],
              rows: List<DataRow>.generate(
                filteredStatuses.length,
                (index) {
                  final status = filteredStatuses[index];
                  return DataRow(
                    cells: [
                      DataCell(_buildEditableCell(status.priority, index, 'Очередность')),
                      DataCell(_buildEditableCell(status.name, index, 'Название')),
                      DataCell(_buildEditableCell(status.color, index, 'Цвет')),
                      DataCell(_buildEditableCell(status.type, index, 'Тип')),
                      DataCell(_buildEditableCell(status.byDefault, index, 'По умолчанию')),
                      DataCell(_buildEditableCell(status.included, index, 'Включен')),
                      DataCell(_buildEditableCell(status.roles, index, 'Ролей')),
                      DataCell(_buildEditableCell(status.transitions, index, 'Переходов')),
                      DataCell(_buildEditableCell(status.notify, index, 'Уведомлять')),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              tooltip: 'Редактировать',
                              onPressed: () => _showEditStatusDialog(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: 'Удалить',
                              onPressed: () => _removeUser(index),
                              ),
                            ],
                          ),
                        ),
                    ]
                      );
                }).toList(),
              );
            }
            ),
          ),
        ),
      );
    },
  );
}

  void _showEditStatusDialog(int index) {
    final status = _statuses[index];
    final TextEditingController priorityController = TextEditingController(text: status.priority);
    final TextEditingController nameController = TextEditingController(text: status.name);
    final TextEditingController colorController = TextEditingController(text: status.color);
    final TextEditingController typeController = TextEditingController(text: status.type);
    final TextEditingController rolesController = TextEditingController(text: status.roles.toString());
    final TextEditingController transitionsController = TextEditingController(text: status.transitions.toString());
    bool byDefault = status.byDefault;
    bool included = status.included;
    bool notify = status.notify;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Редактировать статус'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: priorityController,
                      decoration: const InputDecoration(
                        labelText: 'Очередность',
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
                      controller: colorController,
                      decoration: const InputDecoration(
                        labelText: 'Цвет',
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
                    SwitchListTile(
                      title: const Text('По умолчанию'),
                      value: byDefault,
                      onChanged: (value) {
                        setState(() {
                          byDefault = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      title: const Text('Включен'),
                      value: included,
                      onChanged: (value) {
                        setState(() {
                          included = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: rolesController,
                      decoration: const InputDecoration(
                        labelText: 'Ролей',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: transitionsController,
                      decoration: const InputDecoration(
                        labelText: 'Переходов',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      title: const Text('Уведомлять'),
                      value: notify,
                      onChanged: (value) {
                        setState(() {
                          notify = value;
                        });
                      },
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
                    if (priorityController.text.isEmpty || nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Заполните обязательные поля'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    
                    this.setState(() {
                      _statuses[index] = Status(
                        priority: priorityController.text,
                        name: nameController.text,
                        color: colorController.text,
                        type: typeController.text,
                        byDefault: byDefault,
                        included: included,
                        roles: int.tryParse(rolesController.text) ?? 0,
                        transitions: int.tryParse(transitionsController.text) ?? 0,
                        notify: notify,
                      );
                    });
                    
                    Navigator.of(context).pop();
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Статус обновлен'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text('Сохранить'),
                ),
              ],
            );
          }
        );
      },
    );
  }
}