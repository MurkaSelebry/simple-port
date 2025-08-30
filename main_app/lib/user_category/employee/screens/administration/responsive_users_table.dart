import 'package:flutter/material.dart';
import '../common/universal_responsive_table.dart';

class ResponsiveUsersTable extends StatefulWidget {
  final List<Map<String, dynamic>> users;
  final Function(int, String, String) onEdit;
  final Function(int) onDelete;
  final Color primaryColor;

  const ResponsiveUsersTable({
    super.key,
    required this.users,
    required this.onEdit,
    required this.onDelete,
    this.primaryColor = Colors.blue,
  });

  @override
  _ResponsiveUsersTableState createState() => _ResponsiveUsersTableState();
}

class _ResponsiveUsersTableState extends State<ResponsiveUsersTable> {
  final List<String> _columnNames = [
    'Имя пользователя',
    'Почта',
    'Количество ролей',
    'Роли',
    'Количество групп',
    'Активирован',
    'Добавил',
    'Дата добавления',
  ];

  @override
  Widget build(BuildContext context) {
    return UniversalResponsiveTable(
      data: widget.users,
      columns: _columnNames,
      columnKeys: _columnNames,
      onEdit: (index, field, value) {
        widget.onEdit(index, field, value.toString());
      },
      onDelete: (index) {
        widget.onDelete(index);
      },
      onAdd: () {
        // Handle add if needed
      },
      primaryColor: widget.primaryColor,
      showFileUpload: false,
      showSearch: true,
      showSort: true,
      columnTypes: {
        'Количество ролей': 'number',
        'Количество групп': 'number',
        'Активирован': 'status',
        'Дата добавления': 'date',
      },
      statusOptions: {
        'Активирован': ['Да', 'Нет'],
      },
    );
  }
}
