import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdminContent(),
    );
  }
}

class AdminContent extends StatefulWidget {
  @override
  _AdminContentState createState() => _AdminContentState();
}

class _AdminContentState extends State<AdminContent> {
  int _selectedCategoryIndex = 0;

  // Данные категорий и элементов
  final List<String> _categories = [
    'Пользователи',
    'Статусы',
    'Структура отделов продаж',
    'Отделы продаж',
  ];

  final List<List<Map<String, String>>> _items = [
    [
      {'Название': 'Пользователь 1', 'Описание': 'Описание пользователя 1'},
      {'Название': 'Пользователь 2', 'Описание': 'Описание пользователя 2'},
    ],
    [
      {'Название': 'Статус 1', 'Описание': 'Описание статуса 1'},
      {'Название': 'Статус 2', 'Описание': 'Описание статуса 2'},
    ],
    [
      {'Название': 'Отдел 1', 'Описание': 'Описание отдела 1'},
      {'Название': 'Отдел 2', 'Описание': 'Описание отдела 2'},
    ],
    [
      {'Название': 'Продажа 1', 'Описание': 'Описание продажи 1'},
      {'Название': 'Продажа 2', 'Описание': 'Описание продажи 2'},
    ],
  ];

  // Добавление нового элемента
  void _addItem() {
    setState(() {
      _items[_selectedCategoryIndex].add({
        'Название': 'Новый элемент',
        'Описание': 'Новое описание',
      });
    });
  }

  // Удаление элемента
  void _removeItem(int index) {
    setState(() {
      _items[_selectedCategoryIndex].removeAt(index);
    });
  }

  // Построение таблицы с элементами
  Widget _buildTable() {
    List<DataRow> rows = _items[_selectedCategoryIndex].map((item) {
      int index = _items[_selectedCategoryIndex].indexOf(item);
      return DataRow(
        cells: [
          DataCell(Text(item['Название']!)),
          DataCell(Text(item['Описание']!)),
          //DataCell(Text(item['Описание1']!)),
          DataCell(
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeItem(index),
            ),
          ),
        ],
      );
    }).toList();

    return DataTable(
      columns: const [
        DataColumn(label: Text('Название')),
        DataColumn(label: Text('Описание')),
        //DataColumn(label: Text('Описание1')),
        DataColumn(label: Text('Действия')),
      ],
      rows: rows,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Список категорий
        Container(
          width: 220,
          color: Color(0xFFFFF1E9),
          child: ListView.builder(
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                  color: _selectedCategoryIndex == index
                      ? Colors.orange
                      : Colors.transparent,
                  child: Text(
                    _categories[index],
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Содержимое выбранной категории
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(color: Colors.black, thickness: 1.5),
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(child: _buildTable()),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addItem,
                  child: Text('Добавить элемент'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
