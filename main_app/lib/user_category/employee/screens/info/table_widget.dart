import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart'; // For date formatting

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
  String _searchQuery = '';
  bool _isAscending = true;
  String _sortField = 'Название';

  // Format the date in dd:MM:yyyy hh:mm format
  String _formatDate(dynamic date) {
    if (date == null) return 'Нет данных'; // Handle null values
    if (date is String) {
      try {
        // Try to parse the string to DateTime
        DateTime parsedDate = DateTime.parse(date);
        return DateFormat('dd:MM:yyyy HH:mm').format(parsedDate); // Format the DateTime
      } catch (e) {
        return date; // Return as is if the string can't be parsed
      }
    } else if (date is DateTime) {
      return DateFormat('dd:MM:yyyy HH:mm').format(date); // If it's already a DateTime
    }
    return date.toString(); // In case of any other unexpected data type
  }

  // Filter items by search query (search across all fields)
  List<Map<String, dynamic>> get _filteredItems {
    return widget.items.where((item) {
      return widget.columns.any((col) =>
          item[col]?.toString().toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
    }).toList()
      ..sort((a, b) {
        final valueA = a[_sortField]?.toString() ?? '';
        final valueB = b[_sortField]?.toString() ?? '';
        return _isAscending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
      });
  }

  // File picker
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final file = File(result.files.single.path!);
      final fileName = result.files.single.name;

      widget.onAdd(fileName, file.path);
    }
  }

  // File download
  Future<void> _downloadFile(String? filePath) async {
    if (filePath == null || filePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Файл не найден')),
      );
      return;
    }

    final file = File(filePath);
    if (await file.exists()) {
      String? directory = await FilePicker.platform.getDirectoryPath();
      if (directory != null) {
        final downloadPath = '$directory/${file.uri.pathSegments.last}';
        await file.copy(downloadPath);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Файл сохранен: $downloadPath')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Файл не найден')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search field
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Поиск...',
              border: OutlineInputBorder(),
            ),
            onChanged: (query) => setState(() => _searchQuery = query),
          ),
        ),

        // File upload button (always visible)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton.icon(
            onPressed: _pickFile,
            icon: const Icon(Icons.upload_file),
            label: const Text("Загрузить файл"),
          ),
        ),

        // Data table
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                columnSpacing: 20,
                columns: widget.columns.map((col) {
                  return DataColumn(
                    label: InkWell(
                      onTap: () {
                        setState(() {
                          _isAscending = _sortField == col ? !_isAscending : true;
                          _sortField = col;
                        });
                      },
                      child: Row(
                        children: [
                          Text(col),
                          if (_sortField == col)
                            Icon(
                              _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                              size: 16,
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList()
                  ..add(const DataColumn(label: Text('Действия'))), // Add "Actions" column

                rows: _filteredItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  return DataRow(
                    cells: widget.columns.map((col) {
                      final isEditable = col != 'Кем добавлено' && col != 'Дата добавления';
                      return DataCell(
                        isEditable
                            ? TextFormField(
                                initialValue: item[col],
                                decoration: const InputDecoration(border: InputBorder.none),
                                onChanged: (newValue) => widget.onEdit(index, col, newValue),
                              )
                            : (col == 'Дата добавления'
                                ? Text(_formatDate(item[col])) // Format date
                                : Text(item[col] ?? '')),
                      );
                    }).toList()
                      ..add(
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.download, color: Colors.green),
                                onPressed: () => _downloadFile(item['Путь']),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => widget.onRemove(index),
                              ),
                            ],
                          ),
                        ),
                      ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
