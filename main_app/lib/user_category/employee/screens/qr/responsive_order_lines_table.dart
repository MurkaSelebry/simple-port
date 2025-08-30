import 'package:flutter/material.dart';
import '../common/universal_responsive_table.dart';

class ResponsiveOrderLinesTable extends StatefulWidget {
  final List<List<String>> data;
  final Function(int, int, String)? onDataChanged;
  final Color primaryColor;

  const ResponsiveOrderLinesTable({
    super.key,
    required this.data,
    this.onDataChanged,
    this.primaryColor = Colors.blue,
  });

  @override
  _ResponsiveOrderLinesTableState createState() => _ResponsiveOrderLinesTableState();
}

class _ResponsiveOrderLinesTableState extends State<ResponsiveOrderLinesTable> {
  final List<String> _columnNames = [
    'Название',
    'Описание',
    'Тип упаковки',
    'Упаковка',
    'Номер',
    'Из букв',
    'Дата создания',
    'Общий статус',
    'Возврат',
  ];

  List<Map<String, dynamic>> _convertDataToMap() {
    return widget.data.map((row) {
      final Map<String, dynamic> rowMap = {};
      for (int i = 0; i < _columnNames.length && i < row.length; i++) {
        rowMap[_columnNames[i]] = row[i];
      }
      return rowMap;
    }).toList();
  }

  void _updateOriginalData(int index, String field, String value) {
    final columnIndex = _columnNames.indexOf(field);
    if (columnIndex != -1 && index < widget.data.length) {
      if (columnIndex < widget.data[index].length) {
        widget.data[index][columnIndex] = value;
        widget.onDataChanged?.call(index, columnIndex, value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final convertedData = _convertDataToMap();
    
    return UniversalResponsiveTable(
      data: convertedData,
      columns: _columnNames,
      columnKeys: _columnNames,
      onEdit: (index, field, value) {
        _updateOriginalData(index, field, value.toString());
      },
      onDelete: (index) {
        setState(() {
          widget.data.removeAt(index);
        });
      },
      onAdd: () {
        setState(() {
          widget.data.add(List.generate(_columnNames.length, (i) => ''));
        });
      },
      primaryColor: widget.primaryColor,
      showFileUpload: false,
      showSearch: true,
      showSort: true,
      columnTypes: {
        'Номер': 'number',
        'Дата создания': 'date',
        'Общий статус': 'status',
        'Возврат': 'status',
      },
      statusOptions: {
        'Общий статус': ['Активен', 'Закрыт', 'В процессе'],
        'Возврат': ['Да', 'Нет', 'В процессе'],
      },
    );
  }
}
