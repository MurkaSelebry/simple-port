import 'package:flutter/material.dart';

class OrderLinesTable extends StatefulWidget {
  const OrderLinesTable({super.key});

  @override
  _OrderLinesTableState createState() => _OrderLinesTableState();
}

class _OrderLinesTableState extends State<OrderLinesTable> {
  bool _ascending = true;
  int? _sortColumnIndex;
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  List<List<String>> _data = List.generate(
    20,
    (index) => [
      'Пример $index',
      'Описание $index',
      'Тип $index',
      'Упаковка $index',
      '1234$index',
      'A$index',
      '2023-03-${10 + index}',
      index % 2 == 0 ? 'Активен' : 'Закрыт',
      index % 3 == 0 ? 'Нет' : (index % 3 == 1 ? 'Да' : 'В процессе')
    ],
  );

  void _sortTable(int columnIndex) {
    setState(() {
      if (_sortColumnIndex == columnIndex) {
        _ascending = !_ascending;
      } else {
        _sortColumnIndex = columnIndex;
        _ascending = true;
      }

      _data = List.of(_data);
      _data.sort((a, b) => _ascending
          ? a[columnIndex].compareTo(b[columnIndex])
          : b[columnIndex].compareTo(a[columnIndex]));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Scrollbar(
        controller: _verticalController,
        thumbVisibility: true,
        trackVisibility: true,
        child: SingleChildScrollView(
          controller: _verticalController,
          scrollDirection: Axis.vertical,
          child: Scrollbar(
            controller: _horizontalController,
            thumbVisibility: true,
            trackVisibility: true,
            notificationPredicate: (notification) =>
                notification.depth == 1,
            child: SingleChildScrollView(
              controller: _horizontalController,
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: DataTable(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _ascending,
                  columnSpacing: 24,
                  horizontalMargin: 16,
                  headingRowHeight: 56,
                  dataRowHeight: 56,
                  headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                    (states) => Colors.grey.shade50,
                  ),
                  columns: [
                    _buildDataColumn('Название', 0),
                    _buildDataColumn('Описание', 1),
                    _buildDataColumn('Тип упаковки', 2),
                    _buildDataColumn('Упаковка', 3),
                    _buildDataColumn('Номер', 4),
                    _buildDataColumn('Из букв', 5),
                    _buildDataColumn('Дата создания', 6),
                    _buildDataColumn('Общий статус', 7),
                    _buildDataColumn('Возврат', 8),
                  ],
                  rows: List<DataRow>.generate(
                    _data.length,
                    (index) => DataRow(
                      color: MaterialStateProperty.resolveWith<Color?>(
                        (states) => index.isEven
                            ? Colors.grey.shade50
                            : Colors.white,
                      ),
                      cells: List.generate(
                        9,
                        (colIndex) => DataCell(
                          Container(
                            alignment: _getAlignment(colIndex),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: _buildCellContent(index, colIndex),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCellContent(int rowIndex, int colIndex) {
    final value = _data[rowIndex][colIndex];
    final textColor = _getTextColor(value, colIndex);
    final backgroundColor = _getBackgroundColor(value, colIndex);
    
    // Для статусных колонок создаем красивые чипы
    if (colIndex == 7 || colIndex == 8) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: textColor?.withOpacity(0.3) ?? Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
    
    // Для обычных полей - редактируемые поля
    return TextFormField(
      initialValue: value,
      style: TextStyle(
        color: textColor ?? Colors.black87,
        fontWeight: _isImportantColumn(colIndex) ? FontWeight.w600 : FontWeight.normal,
      ),
      decoration: const InputDecoration(
        filled: false,
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
      onChanged: (newValue) {
        setState(() {
          _data[rowIndex][colIndex] = newValue;
        });
      },
    );
  }

  DataColumn _buildDataColumn(String label, int columnIndex) {
    final theme = Theme.of(context);
    return DataColumn(
      onSort: (columnIndex, _) => _sortTable(columnIndex),
      label: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Alignment _getAlignment(int columnIndex) {
    // Выравнивание для числовых и дата колонок
    if (columnIndex == 4 || columnIndex == 6) {
      return Alignment.centerRight;
    }
    // Для статусных колонок - по центру
    if (columnIndex == 7 || columnIndex == 8) {
      return Alignment.center;
    }
    return Alignment.centerLeft;
  }

  Color? _getTextColor(String value, int columnIndex) {
    // Цвета для статуса заказа
    switch (value) {
      case 'Активен':
        return Colors.green.shade700;
      case 'Закрыт':
        return Colors.red.shade700;
      case 'В процессе':
        return Colors.orange.shade700;
        
      // Цвета для возврата
      case 'Да':
        return Colors.green.shade700;
      case 'Нет':
        return Colors.red.shade700;
        
      // Цвет для номеров (выделяем важные данные)
      default:
        if (columnIndex == 4) { // Номер
          return Colors.blue.shade700;
        }
        if (columnIndex == 6) { // Дата
          return Colors.purple.shade600;
        }
        if (columnIndex == 0) { // Название
          return Colors.indigo.shade800;
        }
        return null;
    }
  }

  Color? _getBackgroundColor(String value, int columnIndex) {
    // Фоновые цвета для статусных чипов
    switch (value) {
      case 'Активен':
        return Colors.green.shade50;
      case 'Закрыт':
        return Colors.red.shade50;
      case 'В процессе':
        return Colors.orange.shade50;
      case 'Да':
        return Colors.green.shade50;
      case 'Нет':
        return Colors.red.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  bool _isImportantColumn(int columnIndex) {
    // Выделяем важные колонки жирным шрифтом
    return columnIndex == 0 || columnIndex == 4; // Название и Номер
  }
}