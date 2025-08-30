
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrdersContent(),
    );
  }
}

class OrdersContent extends StatefulWidget {
  @override
  _OrdersContentState createState() => _OrdersContentState();
}

class _OrdersContentState extends State<OrdersContent> {
  int _selectedCategoryIndex = 0;

  // Данные категорий
  final List<String> _categories = [
    'Заказы',
    'Графики',
    'Линии упаковок',
    'Упаковки',
    'Отложенные упаковки',
    'Отчеты',
  ];

  // Список заказов
  //List<Map<String, dynamic>> _orders = [];
  List<List<Map<String, dynamic>>> _items = [[],[],[],[]];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  // Функция для получения заказов с сервера
  Future<void> _fetchOrders() async {
    setState(() {
      _isLoading = true;
    });
    String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjMiLCJleHAiOjE3Mjg2MTY3MTJ9.3cx6NXwHIhHcZnjcmX534sV2JV_SnYDeV7oFPxdl1qE";
    if (_selectedCategoryIndex == 0) {
    var url = "http://192.168.56.1:3000/api/orders";

    final response = await http.get(Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _items[0] = data.map((order) => {
          'id': order['ID'], // Важно сохранять ID для дальнейших обновлений
          'Название': order['op_code'],
          'Описание': order['description'],
          'Тип': order['type'],
          'Номер отгрузки': order['shipment_number'],
          'Дата доставки': order['delivery_date'],
        }).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Ошибка при загрузке заказов');
    }
    }
    else if (_selectedCategoryIndex == 2) {
    var url = "http://192.168.56.1:3000/api/packaging_lines";

    final response = await http.get(Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _items[2] = data.map((order) => {
          'id': order['ID'], // Важно сохранять ID для дальнейших обновлений
          'Название': order['op_code'],
          'Номер отгрузки': order['shipment_number'],
          'Дата отгрузки': order['shipment_date'],
          'Линия': order['line'],
          'Описание': order['description'],
          'Тип упаковки': order['packaging_type'],
          'Упаковок по умолчанию': order['default_packaging'],
          'Номера упаковок': order['packaging_numbers'],
          'Буквенное обозначение упаковок': order['packaging_letters'],
          'Деталей': order['details'],
        }).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Ошибка при загрузке заказов');
    }
    }
  }

  // Функция для добавления нового элемента
  void _addNewOrder() {
    setState(() {
      if (_selectedCategoryIndex == 0) {
      _items[0].add({
        'id': null, // Новый элемент еще не имеет ID
        'Название': '',
        'Описание': '',
        'Тип': '',
        'Номер отгрузки': '',
        'Дата доставки': '',
      });
      }
      else if (_selectedCategoryIndex == 2) {
      _items[1].add({
        'id': null, // Важно сохранять ID для дальнейших обновлений
          'Название': '',
          'Номер отгрузки': '',
          'Дата отгрузки': '',
          'Линия': '',
          'Описание': '',
          'Тип упаковки':'',
          'Упаковок по умолчанию': 0,
          'Номера упаковок': '',
          'Буквенное обозначение упаковок': '',
          'Деталей': '',
      });
      }

    });
  }

  // Функция для удаления элемента
  Future<void> _deleteOrder(int index) async {
    setState(() {
      _isLoading = true;
    });

    String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjMiLCJleHAiOjE3Mjg2MTY3MTJ9.3cx6NXwHIhHcZnjcmX534sV2JV_SnYDeV7oFPxdl1qE";
    if (_selectedCategoryIndex == 0) {

    var order = _items[0][index];

    if (order['id'] != null) {
      var url = "http://192.168.56.1:3000/api/orders/${order['id']}";

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _items[0].removeAt(index);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Ошибка при удалении заказа с ID ${order['id']}'),
        ));
      }
    } else {
      setState(() {
        _items[0].removeAt(index);
      });
    }
    }
    else if (_selectedCategoryIndex == 2) {
          var order = _items[2][index];

    if (order['id'] != null) {
      var url = "http://192.168.56.1:3000/api/packaging_lines/${order['id']}";

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _items[1].removeAt(index);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Ошибка при удалении заказа с ID ${order['id']}'),
        ));
      }
    } else {
      setState(() {
        _items[2].removeAt(index);
      });
    }
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Построение таблицы с заказами (редактируемая)
  Widget _buildTable() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (_selectedCategoryIndex == 0) {
    List<DataRow> rows = _items[0].map((order) {
      int index = _items[0].indexOf(order);
      return DataRow(
        cells: [
          DataCell(
            TextFormField(
              initialValue: order['Название'],
              onChanged: (value) {
                setState(() {
                  order['Название'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: order['Описание'],
              onChanged: (value) {
                setState(() {
                  order['Описание'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: order['Тип'],
              onChanged: (value) {
                setState(() {
                  order['Тип'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: order['Номер отгрузки'],
              onChanged: (value) {
                setState(() {
                  order['Номер отгрузки'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: order['Дата доставки'],
              onChanged: (value) {
                setState(() {
                  order['Дата доставки'] = value;
                });
              },
            ),
          ),
          DataCell(
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteOrder(index),
            ),
          ),
        ],
      );
    }).toList();

    return DataTable(
      columns: const [
        DataColumn(label: Text('Название')),
        DataColumn(label: Text('Описание')),
        DataColumn(label: Text('Тип')),
        DataColumn(label: Text('Номер отгрузки')),
        DataColumn(label: Text('Дата доставки')),
        DataColumn(label: Text('Действия')),
      ],
      rows: rows,
    );
    }
    else if (_selectedCategoryIndex == 2) {
      List<DataRow> rows = _items[2].map((order) {
      int index = _items[2].indexOf(order);
      return DataRow(
        cells: [
          DataCell(
            TextFormField(
              initialValue: order['Название'],
              onChanged: (value) {
                setState(() {
                  order['Название'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: order['Номер отгрузки'],
              onChanged: (value) {
                setState(() {
                  order['Номер отгрузки'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: order['Дата отгрузки'],
              onChanged: (value) {
                setState(() {
                  order['Дата отгрузки'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: order['Линия'],
              onChanged: (value) {
                setState(() {
                  order['Линия'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: order['Описание'],
              onChanged: (value) {
                setState(() {
                  order['Описание'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: order['Тип упаковки'],
              onChanged: (value) {
                setState(() {
                  order['Тип упаковки'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: order['Упаковок по умолчанию'].toString(),
              onChanged: (value) {
                setState(() {
                  order['Упаковок по умолчанию'] = value.toString();
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: order['Номера упаковок'],
              onChanged: (value) {
                setState(() {
                  order['Номера упаковок'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: order['Буквенное обозначение упаковок'],
              onChanged: (value) {
                setState(() {
                  order['Буквенное обозначение упаковок'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: order['Деталей'],
              onChanged: (value) {
                setState(() {
                  order['Деталей'] = value;
                });
              },
            ),
          ),
          DataCell(
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteOrder(index),
            ),
          ),
        ],
      );
    }).toList();
    return DataTable(
      columns: const [
        DataColumn(label: Text('Название')),
        DataColumn(label: Text('Номер отгрузки')),
        DataColumn(label: Text('Дата отгрузки')),
        DataColumn(label: Text('Линия')),
        DataColumn(label: Text('Описание')),
        DataColumn(label: Text('Тип упаковки')),
        DataColumn(label: Text('Упаковок по умолчанию')),
        DataColumn(label: Text('Номера упаковок')),
        DataColumn(label: Text('Буквенное обозначение упаковок')),
        DataColumn(label: Text('Деталей')),
        DataColumn(label: Text('Действия')),
      ],
      rows: rows,
    );
    }
     List<DataRow> rows = _items[0].map((order) {
      int index = _items[0].indexOf(order);
      return DataRow(
        cells: [
          DataCell(
            TextFormField(
              initialValue: order['Название'],
              onChanged: (value) {
                setState(() {
                  order['Название'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: order['Описание'],
              onChanged: (value) {
                setState(() {
                  order['Описание'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: order['Тип'],
              onChanged: (value) {
                setState(() {
                  order['Тип'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: order['Номер отгрузки'],
              onChanged: (value) {
                setState(() {
                  order['Номер отгрузки'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: order['Дата доставки'],
              onChanged: (value) {
                setState(() {
                  order['Дата доставки'] = value;
                });
              },
            ),
          ),
          DataCell(
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteOrder(index),
            ),
          ),
        ],
      );
    }).toList();

    return DataTable(
      columns: const [
        DataColumn(label: Text('Название')),
        DataColumn(label: Text('Описание')),
        DataColumn(label: Text('Тип')),
        DataColumn(label: Text('Номер отгрузки')),
        DataColumn(label: Text('Дата доставки')),
        DataColumn(label: Text('Действия')),
      ],
      rows: rows,
    );

  }

  // Функция для последовательного сохранения изменений
  Future<void> _saveChanges() async {
    _fetchOrders();
    setState(() {
      _isLoading = true;
    });

    String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjMiLCJleHAiOjE3Mjg2MTY3MTJ9.3cx6NXwHIhHcZnjcmX534sV2JV_SnYDeV7oFPxdl1qE";
    if (_selectedCategoryIndex == 0) {

    // Перебираем заказы и отправляем PUT-запросы для каждого заказа
    for (var order in _items[0]) {
      if (order['id'] != null) {
        var url = "http://192.168.56.1:3000/api/orders/${order['id']}";

        final response = await http.put(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'op_code': order['Название'],
            'description': order['Описание'],
            'type': order['Тип'],
            'shipment_number': order['Номер отгрузки'],
            'delivery_date': order['Дата доставки'],
          }),
        );

        if (response.statusCode != 200) {
          // Обработка ошибки
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Ошибка при сохранении заказа с ID ${order['id']}'),
          ));
        }
      } else {
        // Если у заказа нет ID, значит это новый элемент и его нужно создать через POST-запрос
        var url = "http://192.168.56.1:3000/api/orders";

        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'op_code': order['Название'],
            'description': order['Описание'],
            'type': order['Тип'],
            'shipment_number': order['Номер отгрузки'],
            'delivery_date': order['Дата доставки'],
          }),
        );

        if (response.statusCode == 201) {
          final newOrder = jsonDecode(response.body);
          setState(() {
            order['id'] = newOrder['id']; // Присвоение ID новому заказу
          });
        } else {
          // Обработка ошибки при создании
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Ошибка при создании нового заказа'),
          ));
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
    }
    else if(_selectedCategoryIndex == 2) {
    for (var order in _items[2]) {
      if (order['id'] != null) {
        var url = "http://192.168.56.1:3000/api/packaging_lines/${order['id']}";

        final response = await http.put(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
          'Название': order['op_code'],
          'Номер отгрузки': order['shipment_number'],
          'Дата отгрузки': order['shipment_date'],
          'Линия': order['line'],
          'Описание': order['description'],
          'Тип упаковки': order['packaging_type'],
          'Упаковок по умолчанию': order['default_packaging'],
          'Номера упаковок': order['packaging_numbers'],
          'Буквенное обозначение упаковок': order['packaging_letters'],
          'Деталей': order['details'],
          }),
        );

        if (response.statusCode != 200) {
          // Обработка ошибки
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Ошибка при сохранении заказа с ID ${order['id']}'),
          ));
        }
      } else {
        // Если у заказа нет ID, значит это новый элемент и его нужно создать через POST-запрос
        var url = "http://192.168.56.1:3000/api/packaging_lines";

        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
          'Название': order['op_code'],
          'Номер отгрузки': order['shipment_number'],
          'Дата отгрузки': order['shipment_date'],
          'Линия': order['line'],
          'Описание': order['description'],
          'Тип упаковки': order['packaging_type'],
          'Упаковок по умолчанию': order['default_packaging'],
          'Номера упаковок': order['packaging_numbers'],
          'Буквенное обозначение упаковок': order['packaging_letters'],
          'Деталей': order['details']
          }),
        );

        if (response.statusCode == 201) {
          final newOrder = jsonDecode(response.body);
          setState(() {
            order['id'] = newOrder['id']; // Присвоение ID новому заказу
          });
        } else {
          // Обработка ошибки при создании
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Ошибка при создании нового заказа'),
          ));
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
    }
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
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addNewOrder,
                  child: Text('Добавить элемент'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: Text('Сохранить изменения'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:frontend/user_category/employee/screens/orders/orders-page.dart';
// import 'package:frontend/user_category/employee/screens/orders/deferred_packaging_page.dart';
// import 'package:frontend/user_category/employee/screens/orders/packaging_lines_page.dart';
// import 'package:frontend/user_category/employee/screens/orders/packaging_page.dart';
// import 'package:frontend/user_category/employee/screens/orders/orders-page.dart';

// class OrdersPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: OrdersPage(),
//     );
//   }
// }

// class OrdersContentsPage extends StatefulWidget {
//   @override
//   _OrdersPageContentState createState() => _OrdersPageContentState();
// }

// class _OrdersPageContentState extends State<OrdersContentsPage>{
//   int _selectedCategoryIndex = 0;

//   final List<String> _categories = [
//     'Заказы',
//     'Графики',
//     'Линии упаковок',
//     'Упаковки',
//     'Отложенные упаковки',
//     'Отчеты',
//   ];

//   List<Widget> _pages = [
//     OrdersPage(),
//     PackagingLinePage(),
//     PackagingPage(),
//     DeferredPackagingPage(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           Container(
//             width: 220,
//             color: Color(0xFFFFF1E9),
//             child: ListView.builder(
//               itemCount: _categories.length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _selectedCategoryIndex = index;
//                     });
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
//                     color: _selectedCategoryIndex == index
//                         ? Colors.orange
//                         : Colors.transparent,
//                     child: Text(
//                       _categories[index],
//                       style: TextStyle(
//                         fontSize: 16.0,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Expanded(
//             child: _pages[_selectedCategoryIndex],
//           ),
//         ],
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';

// class OrdersPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: OrdersContent(),
//     );
//   }
// }

// class OrdersContent extends StatefulWidget {
//   @override
//   _OrdersContentState createState() => _OrdersContentState();
// }

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
//               icon: Icon(Icons.delete, color: Colors.red),
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
//           color: Color(0xFFFFF1E9),
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
//                   padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
//                   color: _selectedCategoryIndex == index
//                       ? Colors.orange
//                       : Colors.transparent,
//                   child: Text(
//                     _categories[index],
//                     style: TextStyle(
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
//                 Divider(color: Colors.brown, thickness: 1.5),
//                 SizedBox(height: 20),
//                 Expanded(
//                   child: SingleChildScrollView(child: _buildTable()),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: _addItem,
//                   child: Text('Добавить элемент'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
