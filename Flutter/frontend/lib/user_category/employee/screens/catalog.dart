import 'package:flutter/material.dart';

class CatalogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CatalogContent(),
    );
  }
}

class CatalogContent extends StatefulWidget {
  @override
  _CatalogContentState createState() => _CatalogContentState();
}

class _CatalogContentState extends State<CatalogContent> {
  int _selectedCategoryIndex = 0;

  // Данные категорий и элементов
  final List<String> _categories = [
    'Продукты',
    'Группы',
    'Подгруппы',
    'Типы подгрупп',
    'Динамические свойства',
    'Коды продуктов',
  ];

  final List<List<Map<String, String>>> _items = [
    [
      {'Код продукта': '"OP001"', 'Группа': '1','Подгруппа':'1','Название':'Pruduct 1','Артикул':"ART001"},
      {'Код продукта': '"OP001"', 'Группа': '2','Подгруппа':'2','Название':'Pruduct 2','Артикул':"ART002"},
      {'Код продукта': '"OP001"', 'Группа': '3','Подгруппа':'3','Название':'Pruduct 3','Артикул':"ART003"},
      {'Код продукта': '"OP001"', 'Группа': '4','Подгруппа':'4','Название':'Pruduct 4','Артикул':"ART004"},
      {'Код продукта': '"OP001"', 'Группа': '5','Подгруппа':'5','Название':'Pruduct 5','Артикул':"ART005"},
    ],
    [
      {'Название': 'Группа 1', 'Описание': 'Описание группы 1'},
      {'Название': 'Группа 2', 'Описание': 'Описание группы 2'},
    ],
    [
      {'Название': 'Подгруппа 1', 'Описание': 'Описание подгруппы 1'},
      {'Название': 'Подгруппа 2', 'Описание': 'Описание подгруппы 2'},
    ],
    [
      {'Название': 'Тип подгруппы 1', 'Описание': 'Описание типа подгруппы 1'},
      {'Название': 'Тип подгруппы 2', 'Описание': 'Описание типа подгруппы 2'},
    ],
    [
      {'Название': 'Свойство 1', 'Описание': 'Описание свойства 1'},
      {'Название': 'Свойство 2', 'Описание': 'Описание свойства 2'},
    ],
    [
      {'Название': 'Код продукта 1', 'Описание': 'Описание кода продукта 1'},
      {'Название': 'Код продукта 2', 'Описание': 'Описание кода продукта 2'},
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
          DataCell(Text(item['Код продукта']!)),
          DataCell(Text(item['Группа']!)),
          DataCell(Text(item['Подгруппа']!)),
          DataCell(Text(item['Название']!)),
          DataCell(Text(item['Артикул']!)),
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
        DataColumn(label: Text('Код продукта')),
        DataColumn(label: Text('Группа')),
        DataColumn(label: Text('Подгруппа')),
        DataColumn(label: Text('Название')),
        DataColumn(label: Text('Артикул')),
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
                Divider(color: Colors.brown, thickness: 1.5),
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
