import 'package:flutter/material.dart';
import 'responsive_order_lines_table.dart';

class OrderLinesTable extends StatefulWidget {
  const OrderLinesTable({super.key});

  @override
  _OrderLinesTableState createState() => _OrderLinesTableState();
}

class _OrderLinesTableState extends State<OrderLinesTable> {
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

  void _onDataChanged(int rowIndex, int colIndex, String newValue) {
    setState(() {
      _data[rowIndex][colIndex] = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveOrderLinesTable(
      data: _data,
      onDataChanged: _onDataChanged,
      primaryColor: Theme.of(context).colorScheme.primary,
    );
  }
}