import 'package:flutter/material.dart';
import 'responsive_table_widget.dart';

class TableWidget extends StatefulWidget {
  final List<Map<String, dynamic>> items; // Use dynamic for flexibility
  final Function(String, String) onAdd;
  final Function(int) onRemove;
  final Function(int, String, String) onEdit;
  final List<String> columns;
  final Color color;

  const TableWidget({
    super.key,
    required this.items,
    required this.onAdd,
    required this.onRemove,
    required this.onEdit,
    required this.columns,
    required this.color,
  });

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveTableWidget(
      items: widget.items,
      onAdd: widget.onAdd,
      onRemove: widget.onRemove,
      onEdit: widget.onEdit,
      columns: widget.columns,
      color: widget.color,
    );
  }
}
