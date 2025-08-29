import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// Данные для каждой категории
final List<Map<String, String>> generalDocuments = [
  {'Название': 'Документ 1', 'Описание': 'Описание документа 1'},
  {'Название': 'Документ 2', 'Описание': 'Описание документа 2'},
];

final List<Map<String, String>> advertisingMaterials = [
  {'Название': 'Материал 1', 'Описание': 'Описание материала 1'},
  {'Название': 'Материал 2', 'Описание': 'Описание материала 2'},
];

final List<Map<String, String>> prices = [
  {'Название': 'Прайс 1', 'Описание': 'Описание прайса 1'},
  {'Название': 'Прайс 2', 'Описание': 'Описание прайса 2'},
];

// Универсальный виджет для таблицы с поиском и сортировкой
Widget buildFilteredTable({
  required List<Map<String, String>> items,
  required Function addItem,
  required Function removeItem,
  required Color color,
  required String searchQuery,
  required bool isAscending,
}) {
  final filteredItems = items.where((item) {
    final title = item['Название']!.toLowerCase();
    final description = item['Описание']!.toLowerCase();
    return title.contains(searchQuery.toLowerCase()) ||
        description.contains(searchQuery.toLowerCase());
  }).toList();

  // Сортировка по алфавиту
  filteredItems.sort((a, b) {
    final titleA = a['Название']!;
    final titleB = b['Название']!;
    return isAscending
        ? titleA.compareTo(titleB)
        : titleB.compareTo(titleA);
  });

  return DataTable(
    columns: const [
      DataColumn(label: Text('Название')),
      DataColumn(label: Text('Описание')),
      DataColumn(label: Text('Действия')),
    ],
    rows: filteredItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return DataRow(cells: [
        DataCell(Text(item['Название']!)),
        DataCell(Text(item['Описание']!)),
        DataCell(
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => removeItem(index),
          ),
        ),
      ]);
    }).toList(),
  );
}