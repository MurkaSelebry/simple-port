import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InfoContent(),
    );
  }
}

class InfoContent extends StatefulWidget {
  @override
  _InfoContentState createState() => _InfoContentState();
}

class _InfoContentState extends State<InfoContent> {
  int _selectedCategoryIndex = 0;
  String nameDoc = "dsd";
    
      // Данные категорий и элементов
  final List<String> _categories = [
    'Общие документы',
    'Рекламные материалы',
    'Прайсы',
  ];

  final List<List<Map<String, String>>> _items = [
    [
      {'Название': "Document 1", 'Путь': 'doc1.docx'},
      {'Название': "Document 2", 'Путь': 'doc2.docx'},
      {'Название': "Document 3", 'Путь': 'doc3.pdf'},
      {'Название': "Document 4", 'Путь': 'doc4.png'},
      {'Название': "Document 5", 'Путь': 'doc2.xlsx'},
    ],
    [
      {'Название': 'Материал 1', 'Путь': 'Путь материала 1'},
      {'Название': 'Материал 2', 'Путь': 'Путь материала 2'},
    ],
    [
      {'Название': 'Прайс 1', 'Путь': 'Путь прайса 1'},
      {'Название': 'Прайс 2', 'Путь': 'Путь прайса 2'},
    ],
  ];

  // Добавление нового элемента
  void _addItem() {
    setState(() {
      _items[_selectedCategoryIndex].add({
        'Название': 'Новый элемент',
        'Путь': 'Новое Путь',
      });
    });
  }
  Future<void> _getInfo() async {
      String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjMiLCJleHAiOjE3Mjg2MTY3MTJ9.3cx6NXwHIhHcZnjcmX534sV2JV_SnYDeV7oFPxdl1qE";
      var url = "http://192.168.56.1:3000/api/auth/profile";

    final response = await http.get(Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print(response);
    setState(() {
      _items[_selectedCategoryIndex].add({
        'Название': response.body,
        'Путь': 'Новое Путь',
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
          DataCell(Text(item['Путь']!)),
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
        DataColumn(label: Text('Путь')),
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
                  onPressed: _getInfo,
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

