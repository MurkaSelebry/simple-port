import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

// Обновленная модель данных для пользователей с множественными ролями
class User {
  String username;      // Имя пользователя
  String email;         // Email
  List<String> roles;   // Роли (теперь множественные)
  int groupsCount;      // Количество групп
  bool isActive;        // Активирован
  String addedBy;       // Добавил
  String addedDate;     // Дата добавления

  User({
    required this.username,
    required this.email,
    required this.roles,
    required this.groupsCount,
    required this.isActive,
    required this.addedBy,
    required this.addedDate,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['Имя пользователя'] ?? '',
      email: map['Почта'] ?? '',
      roles: List<String>.from(map['Роли'] ?? []),
      groupsCount: map['Количество групп'] ?? 0,
      isActive: map['Активирован'] ?? false,
      addedBy: map['Добавил'] ?? '',
      addedDate: map['Дата добавления'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Имя пользователя': username,
      'Почта': email,
      'Количество ролей': roles.length,
      'Роли': roles,
      'Количество групп': groupsCount,
      'Активирован': isActive,
      'Добавил': addedBy,
      'Дата добавления': addedDate,
    };
  }

  User copyWith({
    String? username,
    String? email,
    List<String>? roles,
    int? groupsCount,
    bool? isActive,
    String? addedBy,
    String? addedDate,
  }) {
    return User(
      username: username ?? this.username,
      email: email ?? this.email,
      roles: roles ?? this.roles,
      groupsCount: groupsCount ?? this.groupsCount,
      isActive: isActive ?? this.isActive,
      addedBy: addedBy ?? this.addedBy,
      addedDate: addedDate ?? this.addedDate,
    );
  }

  User copyWithField(String field, dynamic value) {
    switch (field) {
      case 'Имя пользователя':
        return copyWith(username: value);
      case 'Почта':
        return copyWith(email: value);
      case 'Роли':
        return copyWith(roles: value);
      case 'Количество групп':
        return copyWith(groupsCount: value);
      case 'Активирован':
        return copyWith(isActive: value);
      case 'Добавил':
        return copyWith(addedBy: value);
      case 'Дата добавления':
        return copyWith(addedDate: value);
      default:
        return this;
    }
  }
}

// Доступные роли для выбора
final List<String> availableRoles = [
  'Администратор',
  'Менеджер',
  'Пользователь',
  'Оператор',
  'Гость',
  'Аналитик',
  'Супервизор',
  'Техник',
  'Консультант',
  'Аудитор',
];

// Начальные данные для примера
final List<User> initialUsers = [
  User(
    username: 'admin',
    email: 'admin@example.com',
    roles: ['Администратор', 'Супервизор'],
    groupsCount: 3,
    isActive: true,
    addedBy: 'Система',
    addedDate: '10.01.2025, 00:00',
  ),
  User(
    username: 'manager',
    email: 'manager@example.com',
    roles: ['Менеджер', 'Оператор'],
    groupsCount: 2,
    isActive: true,
    addedBy: 'admin',
    addedDate: '15.01.2025, 10:15',
  ),
  User(
    username: 'user1',
    email: 'user1@example.com',
    roles: ['Пользователь'],
    groupsCount: 1,
    isActive: false,
    addedBy: 'manager',
    addedDate: '20.01.2025, 14:30',
  ),
];

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final List<User> _users = [...initialUsers];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isAscending = true;
  String _sortField = 'Имя пользователя';
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
          content: Text('Вы уверены, что хотите удалить пользователя "${_users[index].username}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _users.removeAt(index);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Пользователь удален'),
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

  void _toggleUserStatus(int index) {
    setState(() {
      _users[index] = _users[index].copyWith(
        isActive: !_users[index].isActive,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Пользователь ${_users[index].username} ${_users[index].isActive ? 'активирован' : 'деактивирован'}'),
        backgroundColor: _users[index].isActive ? Colors.green : Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleSort(String field) {
    setState(() {
      _isAscending = _sortField == field ? !_isAscending : true;
      _sortField = field;

      _users.sort((a, b) {
        dynamic valueA, valueB;

        // Особые случаи для полей с множественными значениями
        if (field == 'Роли') {
          valueA = a.roles.join(', ');
          valueB = b.roles.join(', ');
        } else if (field == 'Количество ролей') {
          valueA = a.roles.length;
          valueB = b.roles.length;
        } else {
          valueA = a.toMap()[field];
          valueB = b.toMap()[field];
        }

        if (valueA is bool && valueB is bool) {
          return _isAscending ? valueA.toString().compareTo(valueB.toString()) : valueB.toString().compareTo(valueA.toString());
        } else if (valueA is int && valueB is int) {
          return _isAscending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
        } else {
          final strA = valueA?.toString() ?? '';
          final strB = valueB?.toString() ?? '';
          return _isAscending ? strA.compareTo(strB) : strB.compareTo(strA);
        }
      });
    });
  }

  Widget _buildEditableCell(dynamic value, int index, String field) {
  if (field == 'Активирован') {
    final bool isActive = value as bool;
    return InkWell(
      onTap: () => _toggleUserStatus(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? Icons.check_circle : Icons.cancel,
              color: isActive ? Colors.green : Colors.red,
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(child: Text(isActive ? 'Да' : 'Нет')),
          ],
        ),
      ),
    );
  } else if (field == 'Роли') {
  final List<String> roles = value as List<String>;
      final String displayRoles = roles.length <= 2 
          ? roles.join(', ') 
          : '${roles.take(2).join(', ')}...';
          
      return InkWell(
        onTap: () => _showRolesDialog(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  displayRoles,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.more_horiz, size: 16),
            ],
          ),
        ),
      );
  } else if (field == 'Количество групп') {
    return InkWell(
      onTap: () => _showEditNumberDialog(index, field, value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(value.toString()),
      ),
    );
  } else {
    return InkWell(
      onTap: () => _showEditDialog(index, field, value.toString()),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Flexible(
          child: Text(
            value.toString().isEmpty ? '---' : value.toString(),
            style: TextStyle(
              color: value.toString().isEmpty ? Colors.grey : Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
  void _showRolesDialog(int index) {
    List<String> selectedRoles = List.from(_users[index].roles);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Управление ролями'),
              content: SizedBox(
                width: 400,
                height: 400,
                child: Column(
                  children: [
                    Text('Выбрано ролей: ${selectedRoles.length}'),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: availableRoles.length,
                        itemBuilder: (context, i) {
                          final role = availableRoles[i];
                          final isSelected = selectedRoles.contains(role);
                          
                          return CheckboxListTile(
                            title: Text(role),
                            value: isSelected,
                            onChanged: (value) {
                              setDialogState(() {
                                if (value == true) {
                                  if (!selectedRoles.contains(role)) {
                                    selectedRoles.add(role);
                                  }
                                } else {
                                  selectedRoles.remove(role);
                                }
                              });
                            },
                          );
                        },
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
                      _users[index] = _users[index].copyWith(roles: selectedRoles);
                    });
                    Navigator.of(context).pop();
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
                  _users[index] = _users[index].copyWithField(
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
                  _users[index] = _users[index].copyWithField(field, controller.text);
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
      String content = 'Имя пользователя;Почта;Количество ролей;Роли;Количество групп;Активирован;Добавил;Дата добавления\n';
          
      for (var user in _users) {
        content += '${user.username};${user.email};${user.roles.length};${user.roles.join(", ")};${user.groupsCount};'
            '${user.isActive ? "Да" : "Нет"};${user.addedBy};${user.addedDate}\n';
      }
      
      String? directory = await FilePicker.platform.getDirectoryPath();
      if (directory != null) {
        final now = DateTime.now();
        final fileName = 'export_users_${DateFormat('yyyyMMdd_HHmmss').format(now)}.csv';
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

  void _createNewUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController usernameController = TextEditingController();
        final TextEditingController emailController = TextEditingController();
        final TextEditingController groupsController = TextEditingController(text: '0');
        List<String> selectedRoles = ['Пользователь'];
        bool isActive = true;
        
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Новый пользователь'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Имя пользователя',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Почта',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            List<String> tempSelectedRoles = List.from(selectedRoles);
                            
                            return StatefulBuilder(
                              builder: (context, setInnerState) {
                                return AlertDialog(
                                  title: const Text('Выберите роли'),
                                  content: SizedBox(
                                    width: 300,
                                    height: 300,
                                    child: Column(
                                      children: [
                                        Text('Выбрано ролей: ${tempSelectedRoles.length}'),
                                        const SizedBox(height: 8),
                                        Expanded(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: availableRoles.length,
                                            itemBuilder: (context, i) {
                                              final role = availableRoles[i];
                                              final isSelected = tempSelectedRoles.contains(role);
                                              
                                              return CheckboxListTile(
                                                title: Text(role),
                                                value: isSelected,
                                                onChanged: (value) {
                                                  setInnerState(() {
                                                    if (value == true) {
                                                      if (!tempSelectedRoles.contains(role)) {
                                                        tempSelectedRoles.add(role);
                                                      }
                                                    } else {
                                                      tempSelectedRoles.remove(role);
                                                    }
                                                  });
                                                },
                                              );
                                            },
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
                                          selectedRoles = tempSelectedRoles;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Применить'),
                                    ),
                                  ],
                                );
                              }
                            );
                          },
                        );
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Роли',
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                selectedRoles.join(', '),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: groupsController,
                      decoration: const InputDecoration(
                        labelText: 'Количество групп',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      title: const Text('Активирован'),
                      value: isActive,
                      onChanged: (value) {
                        setState(() {
                          isActive = value;
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
                    if (usernameController.text.isEmpty || emailController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Заполните обязательные поля'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    
                    final now = DateTime.now();
                    final formattedDate = _formatDate(now);
                    
                    this.setState(() {
                      _users.add(User(
                        username: usernameController.text,
                        email: emailController.text,
                        roles: selectedRoles,
                        groupsCount: int.tryParse(groupsController.text) ?? 0,
                        isActive: isActive,
                        addedBy: 'Текущий пользователь',
                        addedDate: formattedDate,
                      ));
                    });
                    
                    Navigator.of(context).pop();
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Новый пользователь создан'),
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
                'Всего пользователей: ${_getFilteredUsers().length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.person_add),
                    label: const Text('Новый пользователь'),
                    onPressed: _createNewUser,
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

  List<User> _getFilteredUsers() {
    if (_searchQuery.isEmpty) return _users;
    
    final query = _searchQuery.toLowerCase();
    return _users.where((user) {
      return user.username.toLowerCase().contains(query) ||
             user.email.toLowerCase().contains(query) ||
             user.roles.any((role) => role.toLowerCase().contains(query)) ||
             user.addedBy.toLowerCase().contains(query);
    }).toList();
  }

  Widget _buildDataTableView() {
    final filteredUsers = _getFilteredUsers();
    
    if (filteredUsers.isEmpty) {
      return const Center(
        child: Text(
          'Нет пользователей для отображения',
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
                  label: _buildSortableColumnHeader('Имя пользователя'),
                ),
                DataColumn(
                  label: _buildSortableColumnHeader('Почта'),
                ),
                DataColumn(
                  label: _buildSortableColumnHeader('Количество ролей'),
                ),
                DataColumn(
                  label: _buildSortableColumnHeader('Роли'),
                ),
                DataColumn(
                  label: _buildSortableColumnHeader('Количество групп'),
                ),
                DataColumn(
                  label: _buildSortableColumnHeader('Активирован'),
                ),
                DataColumn(
                  label: _buildSortableColumnHeader('Добавил'),
                ),
                DataColumn(
                  label: _buildSortableColumnHeader('Дата добавления'),
                ),
                const DataColumn(
                  label: Text('Действия'),
                ),
              ],
              rows: List<DataRow>.generate(
                filteredUsers.length,
                (index) {
                  final user = filteredUsers[index];
                  return DataRow(
                    cells: [
                      DataCell(_buildEditableCell(user.username, index, 'Имя пользователя')),
                      DataCell(_buildEditableCell(user.email, index, 'Почта')),
                      DataCell(Text(user.roles.length.toString())),
                      DataCell(_buildEditableCell(user.roles, index, 'Роли')),
                      DataCell(_buildEditableCell(user.groupsCount, index, 'Количество групп')),
                      DataCell(_buildEditableCell(user.isActive, index, 'Активирован')),
                      DataCell(_buildEditableCell(user.addedBy, index, 'Добавил')),
                      DataCell(_buildEditableCell(user.addedDate, index, 'Дата добавления')),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              tooltip: 'Редактировать',
                              onPressed: () => _showEditUserDialog(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: 'Удалить',
                              onPressed: () => _removeUser(index),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              )
              );
            }
            ),
          ),
        ),
      );
    }
    );
  }

  void _showEditUserDialog(int index) {
    final user = _users[index];
    final TextEditingController usernameController = TextEditingController(text: user.username);
    final TextEditingController emailController = TextEditingController(text: user.email);
    final TextEditingController groupsController = TextEditingController(text: user.groupsCount.toString());
    List<String> selectedRoles = List.from(user.roles);
    bool isActive = user.isActive;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Редактировать пользователя'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Имя пользователя',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Почта',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            List<String> tempSelectedRoles = List.from(selectedRoles);
                            
                            return StatefulBuilder(
                              builder: (context, setInnerState) {
                                return AlertDialog(
                                  title: const Text('Выберите роли'),
                                  content: SizedBox(
                                    width: 300,
                                    height: 300,
                                    child: Column(
                                      children: [
                                        Text('Выбрано ролей: ${tempSelectedRoles.length}'),
                                        const SizedBox(height: 8),
                                        Expanded(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: availableRoles.length,
                                            itemBuilder: (context, i) {
                                              final role = availableRoles[i];
                                              final isSelected = tempSelectedRoles.contains(role);
                                              
                                              return CheckboxListTile(
                                                title: Text(role),
                                                value: isSelected,
                                                onChanged: (value) {
                                                  setInnerState(() {
                                                    if (value == true) {
                                                      if (!tempSelectedRoles.contains(role)) {
                                                        tempSelectedRoles.add(role);
                                                      }
                                                    } else {
                                                      tempSelectedRoles.remove(role);
                                                    }
                                                  });
                                                },
                                              );
                                            },
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
                                          selectedRoles = tempSelectedRoles;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Применить'),
                                    ),
                                  ],
                                );
                              }
                            );
                          },
                        );
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Роли',
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                selectedRoles.join(', '),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: groupsController,
                      decoration: const InputDecoration(
                        labelText: 'Количество групп',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      title: const Text('Активирован'),
                      value: isActive,
                      onChanged: (value) {
                        setState(() {
                          isActive = value;
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
                    if (usernameController.text.isEmpty || emailController.text.isEmpty) {
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
                      _users[index] = User(
                        username: usernameController.text,
                        email: emailController.text,
                        roles: selectedRoles,
                        groupsCount: int.tryParse(groupsController.text) ?? 0,
                        isActive: isActive,
                        addedBy: user.addedBy,
                        addedDate: user.addedDate,
                      );
                    });
                    
                    Navigator.of(context).pop();
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Пользователь обновлен'),
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