import 'package:flutter/material.dart';
import '../common/universal_responsive_table.dart';

class ResponsiveSalesStructureTable extends StatefulWidget {
  final List<Map<String, dynamic>> groups;
  final Function(int, String, String) onEdit;
  final Function(int) onDelete;
  final Color primaryColor;

  const ResponsiveSalesStructureTable({
    super.key,
    required this.groups,
    required this.onEdit,
    required this.onDelete,
    this.primaryColor = Colors.blue,
  });

  @override
  _ResponsiveSalesStructureTableState createState() => _ResponsiveSalesStructureTableState();
}

class _ResponsiveSalesStructureTableState extends State<ResponsiveSalesStructureTable> {
  final List<String> _columnNames = [
    'Название головного',
    'Код головного',
    'Название',
    'Код',
    'Город',
    'Адрес',
    'Телефон',
    'Пользователей',
    'Дочерних',
  ];

  @override
  Widget build(BuildContext context) {
    return UniversalResponsiveTable(
      data: widget.groups,
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
        'Пользователей': 'number',
        'Дочерних': 'number',
      },
    );
  }
}
