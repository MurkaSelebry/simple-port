import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeferredPackagingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DeferredPackagingContent(),
    );
  }
}

class DeferredPackagingContent extends StatefulWidget {
  @override
  _DeferredPackagingContentState createState() => _DeferredPackagingContentState();
}

class _DeferredPackagingContentState extends State<DeferredPackagingContent> {
  List<Map<String, dynamic>> _deferredPackagings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDeferredPackagings();
  }

  Future<void> _fetchDeferredPackagings() async {
    setState(() {
      _isLoading = true;
    });
    String token = "YOUR_TOKEN";
    var url = "http://192.168.56.1:3000/api/deferred_packaging";

    final response = await http.get(Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _deferredPackagings = data.map((pack) => {
          'id': pack['id'],
          'OpCode': pack['op_code'],
          'Description': pack['description'],
          'Type': pack['type'],
          'ShipmentNumber': pack['shipment_number'],
          'DeliveryDate': pack['delivery_date'],
        }).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Ошибка при загрузке отложенных упаковок');
    }
  }

  void _addNewDeferredPackaging() {
    setState(() {
      _deferredPackagings.add({
        'id': null,
        'OpCode': '',
        'Description': '',
        'Type': '',
        'ShipmentNumber': '',
        'DeliveryDate': '',
      });
    });
  }

  Future<void> _deleteDeferredPackaging(int index) async {
    setState(() {
      _isLoading = true;
    });

    String token = "YOUR_TOKEN";
    var pack = _deferredPackagings[index];

    if (pack['id'] != null) {
      var url = "http://192.168.56.1:3000/api/deferred_packaging/${pack['id']}";

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
          _deferredPackagings.removeAt(index);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Ошибка при удалении отложенной упаковки с ID ${pack['id']}'),
        ));
      }
    } else {
      setState(() {
        _deferredPackagings.removeAt(index);
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    String token = "YOUR_TOKEN";

    for (var pack in _deferredPackagings) {
      if (pack['id'] != null) {
        var url = "http://192.168.56.1:3000/api/deferred_packaging/${pack['id']}";

        final response = await http.put(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'op_code': pack['OpCode'],
            'description': pack['Description'],
            'type': pack['Type'],
            'shipment_number': pack['ShipmentNumber'],
            'delivery_date': pack['DeliveryDate'],
          }),
        );

        if (response.statusCode != 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Ошибка при сохранении отложенной упаковки с ID ${pack['id']}'),
          ));
        }
      } else {
        var url = "http://192.168.56.1:3000/api/deferred_packaging";

        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'op_code': pack['OpCode'],
            'description': pack['Description'],
            'type': pack['Type'],
            'shipment_number': pack['ShipmentNumber'],
            'delivery_date': pack['DeliveryDate'],
          }),
        );

        if (response.statusCode == 201) {
          final newPack = jsonDecode(response.body);
          setState(() {
            pack['id'] = newPack['id'];
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Ошибка при создании новой отложенной упаковки'),
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
    return Row(
      children: [
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
                  onPressed: _addNewDeferredPackaging,
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

  Widget _buildTable() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    List<DataRow> rows = _deferredPackagings.map((pack) {
      int index = _deferredPackagings.indexOf(pack);
      return DataRow(
        cells: [
          DataCell(
            TextFormField(
              initialValue: pack['OpCode'],
              onChanged: (value) {
                setState(() {
                  pack['OpCode'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: pack['Description'],
              onChanged: (value) {
                setState(() {
                  pack['Description'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: pack['Type'],
              onChanged: (value) {
                setState(() {
                  pack['Type'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: pack['ShipmentNumber'],
              onChanged: (value) {
                setState(() {
                  pack['ShipmentNumber'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: pack['DeliveryDate'],
              onChanged: (value) {
                setState(() {
                  pack['DeliveryDate'] = value;
                });
              },
            ),
          ),
          DataCell(
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteDeferredPackaging(index),
            ),
          ),
        ],
      );
    }).toList();

    return DataTable(
      columns: const [
        DataColumn(label: Text('OpCode')),
        DataColumn(label: Text('Description')),
        DataColumn(label: Text('Type')),
        DataColumn(label: Text('ShipmentNumber')),
        DataColumn(label: Text('DeliveryDate')),
        DataColumn(label: Text('Actions')),
      ],
      rows: rows,
    );
  }
}
