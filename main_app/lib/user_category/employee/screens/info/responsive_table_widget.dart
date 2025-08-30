import 'package:flutter/material.dart';
import '../common/universal_responsive_table.dart';

class ResponsiveTableWidget extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final List<String> columns;
  final Function(int, String, String) onEdit;
  final Function(int)? onDelete;
  final Color color;
  final bool showActions;

  const ResponsiveTableWidget({
    super.key,
    required this.items,
    required this.columns,
    required this.onEdit,
    this.onDelete,
    required this.color,
    this.showActions = true,
  });

  @override
  _ResponsiveTableWidgetState createState() => _ResponsiveTableWidgetState();
}

class _ResponsiveTableWidgetState extends State<ResponsiveTableWidget> {
  @override
  Widget build(BuildContext context) {
    return UniversalResponsiveTable(
      data: widget.items,
      columns: widget.columns,
      columnKeys: widget.columns,
      onEdit: (index, field, value) {
        widget.onEdit(index, field, value.toString());
      },
      onDelete: widget.onDelete ?? (index) {
        // Handle delete if needed
      },
      onAdd: () {
        // Handle add if needed
      },
      primaryColor: widget.color,
      showFileUpload: false,
      showSearch: true,
      showSort: true,
    );
  }
}
