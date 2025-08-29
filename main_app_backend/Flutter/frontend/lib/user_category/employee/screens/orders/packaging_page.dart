import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PackagingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PackagingContent(),
    );
  }
}

class PackagingContent extends StatefulWidget {
  @override
  _PackagingContentState createState() => _PackagingContentState();
}

class _PackagingContentState extends State<PackagingContent> {
  List<Map<String, dynamic>> _packaging = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPackaging();
  }

  Future<void> _fetchPackaging() async {
    setState(() {
      _isLoading = true;
    });
    String token = "YOUR_TOKEN";
    var url = "http://192.168.56.1:3000/api/packaging";

    final response = await http.get(Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _packaging = data.map((pack) => {
          'id': pack['id'],
          'Status': pack['status'],
          'OpCode': pack['op_code'],
          'ShipmentNumber': pack['shipment_number'],
          'ShipmentDate': pack['shipment_date'],
          'City': pack['city'],
          'PlannedDeliveryDate': pack['planned_delivery_date'],
        }).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Ошибка при загрузке упаковок');
    }
  }

  void _addNewPackaging() {
    setState(() {
      _packaging.add({
        'id': null,
        'Status': '',
        'OpCode': '',
        'ShipmentNumber': '',
        'ShipmentDate': '',
        'City': '',
        'PlannedDeliveryDate': '',
      });
    });
  }

  Future<void> _deletePackaging(int index) async {
    setState(() {
      _isLoading = true;
    });

    String token = "YOUR_TOKEN";
    var pack = _packaging[index];

    if (pack['id'] != null) {
      var url = "http://192.168.56.1:3000/api/packaging/${pack['id']}";

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
          _packaging.removeAt(index);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Ошибка при удалении упаковки с ID ${pack['id']}'),
        ));
      }
    } else {
      setState(() {
        _packaging.removeAt(index);
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

    for (var pack in _packaging) {
      if (pack['id'] != null) {
        var url = "http://192.168.56.1:3000/api/packaging/${pack['id']}";

        final response = await http.put(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'status': pack['Status'],
            'op_code': pack['OpCode'],
            'shipment_number': pack['ShipmentNumber'],
            'shipment_date': pack['ShipmentDate'],
            'city': pack['City'],
            'planned_delivery_date': pack['PlannedDeliveryDate'],
          }),
        );

        if (response.statusCode != 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Ошибка при сохранении упаковки с ID ${pack['id']}'),
          ));
        }
      } else {
        var url = "http://192.168.56.1:3000/api/packaging";

        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'status': pack['Status'],
            'op_code': pack['OpCode'],
            'shipment_number': pack['ShipmentNumber'],
            'shipment_date': pack['ShipmentDate'],
            'city': pack['City'],
            'planned_delivery_date': pack['PlannedDeliveryDate'],
          }),
        );

        if (response.statusCode == 201) {
          final newPack = jsonDecode(response.body);
          setState(() {
            pack['id'] = newPack['id'];
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Ошибка при создании новой упаковки'),
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
                  onPressed: _addNewPackaging,
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

    List<DataRow> rows = _packaging.map((pack) {
      int index = _packaging.indexOf(pack);
      return DataRow(
        cells: [
          DataCell(
            TextFormField(
              initialValue: pack['Status'],
              onChanged: (value) {
                setState(() {
                  pack['Status'] = value;
                });
              },
            ),
          ),
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
              initialValue: pack['ShipmentDate'],
              onChanged: (value) {
                setState(() {
                  pack['ShipmentDate'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: pack['City'],
              onChanged: (value) {
                setState(() {
                  pack['City'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: pack['PlannedDeliveryDate'],
              onChanged: (value) {
                setState(() {
                  pack['PlannedDeliveryDate'] = value;
                });
              },
            ),
          ),
          DataCell(
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deletePackaging(index),
            ),
          ),
        ],
      );
    }).toList();

    return DataTable(
      columns: const [
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('OpCode')),
        DataColumn(label: Text('ShipmentNumber')),
        DataColumn(label: Text('ShipmentDate')),
        DataColumn(label: Text('City')),
        DataColumn(label: Text('PlannedDeliveryDate')),
        DataColumn(label: Text('Actions')),
      ],
      rows: rows,
    );
  }
}
