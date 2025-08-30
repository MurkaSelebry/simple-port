import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'app_styles.dart';

class UniversalResponsiveTable extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final List<String> columns;
  final List<String> columnKeys;
  final Function(int, String, dynamic)? onEdit;
  final Function(int)? onDelete;
  final Function()? onAdd;
  final Color? primaryColor;
  final bool showActions;
  final bool showSearch;
  final bool showSort;
  final bool showFileUpload;
  final bool showFileDownload;
  final Map<String, String>? columnTypes; // 'text', 'number', 'date', 'status', 'file'
  final Map<String, List<String>>? statusOptions; // для статусов
  final Map<String, String>? fileExtensions; // для файлов

  const UniversalResponsiveTable({
    Key? key,
    required this.data,
    required this.columns,
    required this.columnKeys,
    this.onEdit,
    this.onDelete,
    this.onAdd,
    this.primaryColor,
    this.showActions = true,
    this.showSearch = true,
    this.showSort = true,
    this.showFileUpload = false,
    this.showFileDownload = false,
    this.columnTypes,
    this.statusOptions,
    this.fileExtensions,
  }) : super(key: key);

  @override
  State<UniversalResponsiveTable> createState() => _UniversalResponsiveTableState();
}

class _UniversalResponsiveTableState extends State<UniversalResponsiveTable> {
  String _searchQuery = '';
  bool _isAscending = true;
  String _sortField = '';
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  
  // Для мобильной адаптации
  List<String> _visibleColumns = [];
  List<String> _hiddenColumns = [];
  bool _showHiddenColumns = false;

  @override
  void initState() {
    super.initState();
    if (widget.columns.isNotEmpty) {
      _sortField = widget.columns[0];
    }
    // Инициализируем все колонки как видимые по умолчанию
    _visibleColumns = List.from(widget.columns);
    _hiddenColumns = [];
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredData {
    var filtered = widget.data.where((item) {
      if (_searchQuery.isEmpty) return true;
      return item.values.any((value) => 
        value.toString().toLowerCase().contains(_searchQuery.toLowerCase())
      );
    }).toList();

    if (_sortField.isNotEmpty) {
      filtered.sort((a, b) {
        final aValue = a[_getKeyForColumn(_sortField)];
        final bValue = b[_getKeyForColumn(_sortField)];
        
        if (aValue == null && bValue == null) return 0;
        if (aValue == null) return _isAscending ? -1 : 1;
        if (bValue == null) return _isAscending ? 1 : -1;

        int comparison = 0;
        final columnType = widget.columnTypes?[_getKeyForColumn(_sortField)] ?? 'text';
        
        switch (columnType) {
          case 'number':
            final aNum = double.tryParse(aValue.toString()) ?? 0;
            final bNum = double.tryParse(bValue.toString()) ?? 0;
            comparison = aNum.compareTo(bNum);
            break;
          case 'date':
            final aDate = DateTime.tryParse(aValue.toString());
            final bDate = DateTime.tryParse(bValue.toString());
            if (aDate != null && bDate != null) {
              comparison = aDate.compareTo(bDate);
            } else {
              comparison = aValue.toString().compareTo(bValue.toString());
            }
            break;
          default:
            comparison = aValue.toString().compareTo(bValue.toString());
        }
        
        return _isAscending ? comparison : -comparison;
      });
    }

    return filtered;
  }

  String _getKeyForColumn(String columnName) {
    final index = widget.columns.indexOf(columnName);
    return index >= 0 && index < widget.columnKeys.length ? widget.columnKeys[index] : columnName;
  }

  String _formatValue(dynamic value, String columnKey) {
    if (value == null) return '';
    
    final columnType = widget.columnTypes?[columnKey] ?? 'text';
    
    switch (columnType) {
      case 'date':
        try {
          final date = DateTime.parse(value.toString());
          return DateFormat('dd.MM.yyyy').format(date);
        } catch (e) {
          return value.toString();
        }
      case 'number':
        try {
          final num = double.parse(value.toString());
          return num.toStringAsFixed(2);
        } catch (e) {
          return value.toString();
        }
      default:
        return value.toString();
    }
  }

  Widget _buildCellContent(dynamic value, String columnKey) {
    final columnType = widget.columnTypes?[columnKey] ?? 'text';
    final formattedValue = _formatValue(value, columnKey);
    
    switch (columnType) {
      case 'status':
        final statusOptions = widget.statusOptions?[columnKey] ?? [];
        final statusIndex = statusOptions.indexOf(value.toString());
        final statusColor = AppStyles.getStatusColor(value.toString());
        
        return Container(
          padding: AppStyles.chipPadding,
          decoration: AppStyles.getChipDecoration(statusColor),
          child: Text(
            formattedValue,
            style: AppStyles.getChipTextStyle(statusColor),
          ),
        );
      
      case 'file':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.attach_file, size: 16, color: widget.primaryColor),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                formattedValue,
                style: AppStyles.bodyTextStyle.copyWith(
                  color: widget.primaryColor,
                  decoration: TextDecoration.underline,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      
      default:
        return Text(
          formattedValue,
          style: AppStyles.bodyTextStyle,
          overflow: TextOverflow.ellipsis,
        );
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Файл выбран: ${result.files.first.name}'),
            backgroundColor: AppStyles.successColor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при выборе файла: $e'),
          backgroundColor: AppStyles.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        
        // Инициализируем видимость колонок на основе размера экрана
        if (isMobile && _visibleColumns.length == widget.columns.length) {
          // Показываем только самые важные колонки на мобильных
          final importantColumns = widget.columns.take(3).toList();
          _visibleColumns = importantColumns;
          _hiddenColumns = widget.columns.skip(3).toList();
        } else if (!isMobile && _visibleColumns.length != widget.columns.length) {
          // Показываем все колонки на десктопе
          _visibleColumns = List.from(widget.columns);
          _hiddenColumns = [];
        }
        
        if (isMobile) {
          return _buildMobileView();
        } else {
          return _buildDesktopView();
        }
      },
    );
  }

  Widget _buildMobileView() {
    return Column(
      children: [
        // Поиск
        if (widget.showSearch) ...[
          Container(
            margin: AppStyles.cardMargin,
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: AppStyles.searchInputDecoration.copyWith(
                hintText: 'Поиск...',
              ),
            ),
          ),
        ],
        
        // Кнопки действий
        if (widget.showActions || widget.showFileUpload) ...[
          Container(
            margin: AppStyles.cardMargin,
            child: Row(
              children: [
                if (widget.onAdd != null) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: widget.onAdd,
                      icon: const Icon(Icons.add),
                      label: const Text('Добавить'),
                      style: AppStyles.primaryButtonStyle,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (widget.showFileUpload) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickFile,
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Загрузить'),
                      style: AppStyles.secondaryButtonStyle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
        
        // Список карточек
        Expanded(
          child: _filteredData.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: AppStyles.listPadding,
                  itemCount: _filteredData.length,
                  itemBuilder: (context, index) {
                    final item = _filteredData[index];
                    return _buildMobileCard(item, index);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildMobileCard(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppStyles.cardDecoration,
      child: ExpansionTile(
        title: Text(
          _formatValue(item[widget.columnKeys.first], widget.columnKeys.first),
          style: AppStyles.titleTextStyle,
        ),
        subtitle: Text(
          'Запись ${index + 1}',
          style: AppStyles.captionTextStyle,
        ),
        children: [
          Padding(
            padding: AppStyles.cardPadding,
            child: Column(
              children: [
                // Показываем видимые колонки
                ..._visibleColumns.asMap().entries.map((entry) {
                  final columnIndex = entry.key;
                  final columnName = entry.value;
                  final columnKey = widget.columnKeys[columnIndex];
                  final value = item[columnKey];
                  
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            columnName,
                            style: AppStyles.labelTextStyle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildCellContent(value, columnKey),
                        ),
                        if (widget.onEdit != null) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 16),
                            onPressed: () => _showEditDialog(item, columnKey, columnName),
                            style: AppStyles.iconButtonStyle,
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
                
                // Показываем скрытые колонки в выпадающем списке
                if (_hiddenColumns.isNotEmpty) ...[
                  const Divider(),
                  ExpansionTile(
                    title: Text(
                      'Дополнительные поля (${_hiddenColumns.length})',
                      style: AppStyles.labelTextStyle.copyWith(
                        color: widget.primaryColor ?? AppStyles.primaryColor,
                      ),
                    ),
                    children: [
                      ..._hiddenColumns.asMap().entries.map((entry) {
                        final columnIndex = widget.columns.indexOf(entry.value);
                        final columnName = entry.value;
                        final columnKey = widget.columnKeys[columnIndex];
                        final value = item[columnKey];
                        
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100,
                                child: Text(
                                  columnName,
                                  style: AppStyles.labelTextStyle.copyWith(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildCellContent(value, columnKey),
                              ),
                              if (widget.onEdit != null) ...[
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 14),
                                  onPressed: () => _showEditDialog(item, columnKey, columnName),
                                  style: AppStyles.iconButtonStyle,
                                ),
                              ],
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ],
                
                if (widget.onDelete != null) ...[
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => _showDeleteDialog(index),
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text('Удалить', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopView() {
    return Column(
      children: [
        // Панель инструментов
        Container(
          margin: AppStyles.cardMargin,
          child: Row(
            children: [
              if (widget.showSearch) ...[
                Expanded(
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: AppStyles.searchInputDecoration.copyWith(
                      hintText: 'Поиск...',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
              if (widget.onAdd != null) ...[
                ElevatedButton.icon(
                  onPressed: widget.onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text('Добавить'),
                  style: AppStyles.primaryButtonStyle,
                ),
                const SizedBox(width: 8),
              ],
              if (widget.showFileUpload) ...[
                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Загрузить'),
                  style: AppStyles.secondaryButtonStyle,
                ),
              ],
            ],
          ),
        ),
        
        // Таблица с горизонтальной прокруткой
        Expanded(
          child: _filteredData.isEmpty
              ? _buildEmptyState()
              : Container(
                  decoration: AppStyles.tableDecoration,
                  child: Scrollbar(
                    controller: _verticalScrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _verticalScrollController,
                      child: Scrollbar(
                        controller: _horizontalScrollController,
                        thumbVisibility: true,
                        notificationPredicate: (notification) => notification.depth == 1,
                        child: SingleChildScrollView(
                          controller: _horizontalScrollController,
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width - 32,
                            ),
                            child: DataTable(
                              headingRowColor: MaterialStateProperty.all(
                                widget.primaryColor?.withOpacity(0.1) ?? AppStyles.primaryColor.withOpacity(0.1)
                              ),
                              dataRowMinHeight: 60,
                              dataRowMaxHeight: 80,
                              columnSpacing: 20,
                              horizontalMargin: 16,
                              dividerThickness: 1,
                              showCheckboxColumn: false,
                              columns: widget.columns.map((column) {
                                return DataColumn(
                                  label: Container(
                                    constraints: const BoxConstraints(minWidth: 120),
                                    child: widget.showSort ? _buildSortableHeader(column) : Text(column),
                                  ),
                                );
                              }).toList(),
                              rows: _filteredData.asMap().entries.map((entry) {
                                final index = entry.key;
                                final item = entry.value;
                                
                                return DataRow(
                                  cells: widget.columnKeys.map((key) {
                                    final value = item[key];
                                    return DataCell(
                                      Container(
                                        constraints: const BoxConstraints(minWidth: 120),
                                        child: _buildCellContent(value, key),
                                      ),
                                      onTap: widget.onEdit != null ? () => _showEditDialog(item, key, widget.columns[widget.columnKeys.indexOf(key)]) : null,
                                    );
                                  }).toList(),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildSortableHeader(String column) {
    final isSorted = _sortField == column;
    return InkWell(
      onTap: () {
        setState(() {
          if (_sortField == column) {
            _isAscending = !_isAscending;
          } else {
            _sortField = column;
            _isAscending = true;
          }
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(column, style: AppStyles.headerTextStyle),
          ),
          const SizedBox(width: 4),
          Icon(
            isSorted
                ? (_isAscending ? Icons.arrow_upward : Icons.arrow_downward)
                : Icons.arrow_upward,
            size: 16,
            color: isSorted ? (widget.primaryColor ?? AppStyles.primaryColor) : Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.table_chart,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Нет данных для отображения',
            style: AppStyles.titleTextStyle.copyWith(color: Colors.grey[600]),
          ),
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Попробуйте изменить поисковый запрос',
              style: AppStyles.bodyTextStyle.copyWith(color: Colors.grey[500]),
            ),
          ],
        ],
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> item, String key, String columnName) {
    final currentValue = item[key];
    final columnType = widget.columnTypes?[key] ?? 'text';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Редактировать $columnName'),
        content: _buildEditField(currentValue, columnType, key),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              // Здесь будет логика сохранения
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Поле $columnName обновлено'),
                  backgroundColor: AppStyles.successColor,
                ),
              );
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  Widget _buildEditField(dynamic currentValue, String columnType, String key) {
    switch (columnType) {
      case 'status':
        final statusOptions = widget.statusOptions?[key] ?? [];
        return DropdownButtonFormField<String>(
          value: currentValue?.toString(),
          items: statusOptions.map((status) => DropdownMenuItem(
            value: status,
            child: Text(status),
          )).toList(),
          onChanged: (value) {
            // Обновление значения
          },
          decoration: const InputDecoration(labelText: 'Статус'),
        );
      
      case 'number':
        return TextFormField(
          initialValue: currentValue?.toString() ?? '',
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Число'),
          onChanged: (value) {
            // Обновление значения
          },
        );
      
      case 'date':
        return TextFormField(
          initialValue: currentValue?.toString() ?? '',
          decoration: const InputDecoration(labelText: 'Дата (ГГГГ-ММ-ДД)'),
          onChanged: (value) {
            // Обновление значения
          },
        );
      
      default:
        return TextFormField(
          initialValue: currentValue?.toString() ?? '',
          decoration: const InputDecoration(labelText: 'Текст'),
          onChanged: (value) {
            // Обновление значения
          },
        );
    }
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Подтверждение удаления'),
        content: const Text('Вы уверены, что хотите удалить эту запись?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onDelete?.call(index);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Запись удалена'),
                  backgroundColor: AppStyles.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
}
