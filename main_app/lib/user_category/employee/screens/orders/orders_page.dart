import 'package:flutter/material.dart';
import 'charts.dart';
import 'deferred_packages.dart';
import 'orders_and_packages.dart';
import 'packaging_lines.dart';
import 'packaging.dart';
import 'reports.dart';
import 'orders.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _OrdersContent(),
    );
  }
}

class _OrdersContent extends StatefulWidget {
  const _OrdersContent();

  @override
  State<_OrdersContent> createState() => _OrdersContentState();
}

class _OrdersContentState extends State<_OrdersContent> {
  int _selectedCategoryIndex = 0;

  final List<Widget> _pages = [
    const Orders(),
    Charts(),
    OrdersAndPackages(),
    PackagingLines(),
    Packaging(),
    DeferredPackages(),
    Reports(),
  ];

  final List<String> _categories = [
    'Заказы',
    'Графики',
    'Заказы и упаковки',
    'Линии упаковок',
    'Упаковки',
    'Отложенные упаковки',
    'Отчеты',
  ];

  final List<IconData> _icons = [
    Icons.shopping_cart,
    Icons.bar_chart,
    Icons.inventory,
    Icons.build,
    Icons.archive,
    Icons.schedule,
    Icons.assignment,
  ];

  final List<Color> _categoryColors = [
    Color(0xFFFFF1E9),
    Color(0xFFE3F2FD),
    Color(0xFFF1F8E9),
    Color(0xFFFFE0B2),
    Color(0xFFD1C4E9),
    Color(0xFFB2DFDB),
    Color(0xFFFFCDD2),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 255,
          color: Colors.white,
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
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                  color: _selectedCategoryIndex == index
                      ? _categoryColors[index]
                      : Colors.transparent,
                  child: Row(
                    children: [
                      Icon(_icons[index], color: Colors.black54),
                      const SizedBox(width: 10),
                      Text(
                        _categories[index],
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: _pages[_selectedCategoryIndex],
        ),
      ],
    );
  }
}



// class _OrdersContentState extends State<OrdersContent> {
//   int _selectedCategoryIndex = 0;

//   // Данные категорий и элементов
//   final List<String> _categories = [
//     'Заказы',
//     'Графики',
//     'Линии упаковок',
//     'Упаковки',
//     'Отложенные упаковки',
//     'Отчеты',
//   ];

//   final List<List<Map<String, String>>> _items = [
//     [
//       {'Название': 'Заказ 1', 'Описание': 'Описание заказа 1'},
//       {'Название': 'Заказ 2', 'Описание': 'Описание заказа 2'},
//     ],
//     [
//       {'Название': 'График 1', 'Описание': 'Описание графика 1'},
//       {'Название': 'График 2', 'Описание': 'Описание графика 2'},
//     ],
//     [
//       {'Название': 'Линия 1', 'Описание': 'Описание линии 1'},
//       {'Название': 'Линия 2', 'Описание': 'Описание линии 2'},
//     ],
//     [
//       {'Название': 'Упаковка 1', 'Описание': 'Описание упаковки 1'},
//       {'Название': 'Упаковка 2', 'Описание': 'Описание упаковки 2'},
//     ],
//     [
//       {'Название': 'Отложенная упаковка 1', 'Описание': 'Описание отложенной упаковки 1'},
//       {'Название': 'Отложенная упаковка 2', 'Описание': 'Описание отложенной упаковки 2'},
//     ],
//     [
//       {'Название': 'Отчет 1', 'Описание': 'Описание отчета 1'},
//       {'Название': 'Отчет 2', 'Описание': 'Описание отчета 2'},
//     ],
//   ];

//   // Добавление нового элемента
//   void _addItem() {
//     setState(() {
//       _items[_selectedCategoryIndex].add({
//         'Название': 'Новый элемент',
//         'Описание': 'Новое описание',
//       });
//     });
//   }

//   // Удаление элемента
//   void _removeItem(int index) {
//     setState(() {
//       _items[_selectedCategoryIndex].removeAt(index);
//     });
//   }

//   // Построение таблицы с элементами
//   Widget _buildTable() {
//     List<DataRow> rows = _items[_selectedCategoryIndex].map((item) {
//       int index = _items[_selectedCategoryIndex].indexOf(item);
//       return DataRow(
//         cells: [
//           DataCell(Text(item['Название']!)),
//           DataCell(Text(item['Описание']!)),
//           DataCell(
//             IconButton(
//               icon: const Icon(Icons.delete, color: Colors.red),
//               onPressed: () => _removeItem(index),
//             ),
//           ),
//         ],
//       );
//     }).toList();

//     return DataTable(
//       columns: const [
//         DataColumn(label: Text('Название')),
//         DataColumn(label: Text('Описание')),
//         DataColumn(label: Text('Действия')),
//       ],
//       rows: rows,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         // Список категорий
//         Container(
//           width: 220,
//           color: const Color(0xFFFFF1E9),
//           child: ListView.builder(
//             itemCount: _categories.length,
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     _selectedCategoryIndex = index;
//                   });
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
//                   color: _selectedCategoryIndex == index
//                       ? Colors.orange
//                       : Colors.transparent,
//                   child: Text(
//                     _categories[index],
//                     style: const TextStyle(
//                       fontSize: 16.0,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//         // Содержимое выбранной категории
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Divider(color: Colors.brown, thickness: 1.5),
//                 const SizedBox(height: 20),
//                 Expanded(
//                   child: SingleChildScrollView(child: _buildTable()),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: _addItem,
//                   child: const Text('Добавить элемент'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
