import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class Document {
  String description;   // Описание
  String fileName;      // Имя файла
  String addedBy;       // Кем добавлено
  String addedDate;     // Дата добавления
  String readStatus;    // Статус прочтения
  String filePath;      // Путь к файлу

  Document({
    required this.description,
    required this.fileName,
    required this.addedBy,
    required this.addedDate,
    required this.readStatus,
    required this.filePath,
  });

  factory Document.fromMap(Map<String, String> map) {
    return Document(
      description: map['Описание'] ?? '',
      fileName: map['Имя файла'] ?? '',
      addedBy: map['Кем добавлено'] ?? '',
      addedDate: map['Дата добавления'] ?? '',
      readStatus: map['Прочитан'] ?? '',
      filePath: map['Путь'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'Описание': description,
      'Имя файла': fileName,
      'Кем добавлено': addedBy,
      'Дата добавления': addedDate,
      'Прочитан': readStatus,
      'Путь': filePath,
    };
  }

  Document copyWith({
    String? description,
    String? fileName,
    String? addedBy,
    String? addedDate,
    String? readStatus,
    String? filePath,
  }) {
    return Document(
      description: description ?? this.description,
      fileName: fileName ?? this.fileName,
      addedBy: addedBy ?? this.addedBy,
      addedDate: addedDate ?? this.addedDate,
      readStatus: readStatus ?? this.readStatus,
      filePath: filePath ?? this.filePath,
    );
  }

  Document copyWithField(String field, String value) {
    switch (field) {
      case 'Описание':
        return copyWith(description: value);
      case 'Имя файла':
        return copyWith(fileName: value);
      case 'Кем добавлено':
        return copyWith(addedBy: value);
      case 'Дата добавления':
        return copyWith(addedDate: value);
      case 'Прочитан':
        return copyWith(readStatus: value);
      case 'Путь':
        return copyWith(filePath: value);
      default:
        return this;
    }
  }
}

final List<Document> initialOrders = [
  Document(
    description: 'Прайс-лист на ЛДСП (апрель 2025)',
    fileName: 'Прайс_ЛДСП_апрель_2025.xlsx',
    addedBy: 'Отдел закупок',
    addedDate: '01.04.2025',
    readStatus: '',
    filePath: '',
  ),
  Document(
    description: 'Актуальные цены на фурнитуру Blum, Hettich',
    fileName: 'Прайс_фурнитура_2025.pdf',
    addedBy: 'Менеджер по снабжению',
    addedDate: '05.04.2025',
    readStatus: '',
    filePath: '',
  ),
  Document(
    description: 'Стоимость услуг покраски МДФ',
    fileName: 'Прайс_МДФ_покраска.docx',
    addedBy: 'Производство',
    addedDate: '10.04.2025',
    readStatus: '',
    filePath: '',
  ),
];

class Prices extends StatefulWidget {
  const Prices({super.key});

  @override
  _PricesState createState() => _PricesState();
}

class _PricesState extends State<Prices> {
  final List<Document> _orders = [...initialOrders];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isAscending = true;
  String _sortField = 'Описание';
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
    return DateFormat('dd.MM.yyyy').format(date);
  }

  Future<void> _pickFile(int? index) async {
    setState(() {
      _isLoading = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        final fileName = result.files.single.name;

        setState(() {
          if (index != null) {
            _orders[index] = _orders[index].copyWith(
              fileName: fileName,
              filePath: file.path,
              addedBy: 'Текущий пользователь',
              addedDate: _formatDate(DateTime.now()),
            );
          } else {
            _orders.add(Document(
              description: 'Новый документ',
              fileName: fileName,
              addedBy: 'Текущий пользователь',
              addedDate: _formatDate(DateTime.now()),
              readStatus: '',
              filePath: file.path,
            ));
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Файл "$fileName" успешно ${index != null ? 'обновлен' : 'добавлен'}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _removeItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение удаления'),
          content: const Text('Вы уверены, что хотите удалить этот элемент?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _orders.removeAt(index);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Элемент удален'),
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

  Future<void> _downloadFile(int index) async {
    final filePath = _orders[index].filePath;
    if (filePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Нет файла для скачивания'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final file = File(filePath);
      if (await file.exists()) {
        String? directory = await FilePicker.platform.getDirectoryPath();

        if (directory != null) {
          final fileName = file.uri.pathSegments.last;
          final downloadPath = '$directory/$fileName';
          await file.copy(downloadPath);

          // Обновляем статус на "Прочитано" с текущей датой
          setState(() {
            _orders[index] = _orders[index].copyWith(
              readStatus: _formatDate(DateTime.now()),
            );
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Файл сохранен в: $downloadPath'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Файл не найден: $filePath'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleSort(String field) {
    setState(() {
      _isAscending = _sortField == field ? !_isAscending : true;
      _sortField = field;

      _orders.sort((a, b) {
        final valueA = a.toMap()[field] ?? '';
        final valueB = b.toMap()[field] ?? '';
        return _isAscending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
      });
    });
  }

  Widget _buildEditableCell(dynamic value, int index, String field) {
    String displayValue;
    
    if (value is bool) {
      displayValue = value ? 'Да' : 'Нет';
    } else {
      displayValue = (value?.toString() ?? '').isEmpty ? '---' : value.toString();
    }
    
    return InkWell(
      onTap: () => _showEditDialog(index, field, value),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          displayValue,
          style: TextStyle(
            color: displayValue == '---' ? Colors.grey : Colors.black87,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
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
            maxLines: field == 'Описание' ? 3 : 1,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedOrder = _orders[index].copyWithField(field, controller.text);
                setState(() {
                  _orders[index] = updatedOrder;
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
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(
                fieldName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
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
      String content = 'Описание;Имя файла;Кем добавлено;Дата добавления;Прочитан;Путь\n';
          
      for (var order in _orders) {
        content += '${order.description};${order.fileName};${order.addedBy};'
            '${order.addedDate};${order.readStatus};${order.filePath}\n';
      }
      
      String? directory = await FilePicker.platform.getDirectoryPath();
      if (directory != null) {
        final now = DateTime.now();
        final fileName = 'export_orders_${DateFormat('yyyyMMdd_HHmmss').format(now)}.csv';
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

  void _createNewOrder() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController descriptionController = TextEditingController();
        
        return AlertDialog(
          title: const Text('Новый документ'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Описание',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
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
                final now = DateTime.now();
                final formattedDate = _formatDate(now);
                
                setState(() {
                  _orders.add(Document(
                    description: descriptionController.text.isNotEmpty ? descriptionController.text : 'Новый документ',
                    fileName: '',
                    addedBy: 'Текущий пользователь',
                    addedDate: formattedDate,
                    readStatus: 'Не прочитан',
                    filePath: '',
                  ));
                });
                
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Новый документ создан'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Создать'),
            ),
          ],
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
      padding: const EdgeInsets.all(12.0),
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Всего записей: ${_getFilteredOrders().length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
                ),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Новый документ', style: TextStyle(fontSize: 13)),
                    onPressed: _createNewOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.file_download, size: 18),
                    label: const Text('Экспорт CSV', style: TextStyle(fontSize: 13)),
                    onPressed: _exportToCsv,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

  List<Document> _getFilteredOrders() {
    if (_searchQuery.isEmpty) return _orders;
    
    final query = _searchQuery.toLowerCase();
    return _orders.where((order) {
      return order.toMap().values.any(
            (value) => value.toLowerCase().contains(query),
          );
    }).toList();
  }

  Widget _buildDataTableView() {
    final filteredOrders = _getFilteredOrders();
    
    if (filteredOrders.isEmpty) {
      return const Center(
        child: Text(
          'Нет записей для отображения',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
    
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
              final actionWidth = 250.0;
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
                    label: Container(
                      width: descriptionWidth,
                      child: _buildSortableColumnHeader('Описание'),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      width: fileNameWidth,
                      child: _buildSortableColumnHeader('Имя файла'),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      width: addedByWidth,
                      child: _buildSortableColumnHeader('Кем добавлено'),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      width: dateWidth,
                      child: _buildSortableColumnHeader('Дата добавления'),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      width: statusWidth,
                      child: _buildSortableColumnHeader('Прочитан'),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      width: actionWidth,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Действия', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
                rows: filteredOrders.asMap().entries.map((entry) {
                  final index = entry.key;
                  final order = entry.value;
                  return DataRow(
                    color: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (index % 2 == 0) return Colors.grey[100];
                        return null;
                      },
                    ),
                    cells: [
                      DataCell(
                        Container(
                          width: descriptionWidth,
                          child: _buildEditableCell(order.description, index, 'Описание'),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: fileNameWidth,
                          child: _buildEditableCell(order.fileName, index, 'Имя файла'),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: addedByWidth,
                          child: Text(order.addedBy),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: dateWidth,
                          child: Text(order.addedDate),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: statusWidth,
                          child: Text(order.readStatus),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: actionWidth,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (order.filePath.isEmpty)
                                IconButton(
                                  icon: const Icon(Icons.upload, color: Colors.blue),
                                  onPressed: () => _pickFile(index),
                                  tooltip: 'Загрузить файл',
                                )
                              else
                                IconButton(
                                  icon: const Icon(Icons.download, color: Colors.green),
                                  onPressed: () => _downloadFile(index),
                                  tooltip: 'Скачать файл',
                                ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeItem(index),
                                tooltip: 'Удалить',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}