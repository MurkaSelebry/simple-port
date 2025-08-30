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
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _isLoading = true;
    });
    String token = "YOUR_TOKEN";
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
        _orders = data.map((order) => {
          'id': order['ID'],
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

  void _addNewOrder() {
    setState(() {
      _orders.add({
        'id': null,
        'Название': '',
        'Описание': '',
        'Тип': '',
        'Номер отгрузки': '',
        'Дата доставки': '',
      });
    });
  }

  Future<void> _deleteOrder(int index) async {
    setState(() {
      _isLoading = true;
    });

    String token = "YOUR_TOKEN";
    var order = _orders[index];

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
          _orders.removeAt(index);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Ошибка при удалении заказа с ID ${order['id']}'),
        ));
      }
    } else {
      setState(() {
        _orders.removeAt(index);
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildTable() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    List<DataRow> rows = _orders.map((order) {
      int index = _orders.indexOf(order);
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

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    String token = "YOUR_TOKEN";

    for (var order in _orders) {
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Ошибка при сохранении заказа с ID ${order['id']}'),
          ));
        }
      } else {
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
            order['id'] = newOrder['id'];
          });
        } else {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Colors.brown, thickness: 1.5),
        SizedBox(height: 20),
        Expanded(child: SingleChildScrollView(child: _buildTable())),
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
    );
  }
}
