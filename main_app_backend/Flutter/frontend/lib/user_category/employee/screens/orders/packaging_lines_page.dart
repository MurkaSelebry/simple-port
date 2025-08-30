import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PackagingLinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PackagingLineContent(),
    );
  }
}

class PackagingLineContent extends StatefulWidget {
  @override
  _PackagingLineContentState createState() => _PackagingLineContentState();
}

class _PackagingLineContentState extends State<PackagingLineContent> {
  List<Map<String, dynamic>> _packagingLines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPackagingLines();
  }

  Future<void> _fetchPackagingLines() async {
    setState(() {
      _isLoading = true;
    });
    String token = "YOUR_TOKEN";
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
        _packagingLines = data.map((line) => {
          'id': line['id'],
          'OrderID': line['order_id'],
          'OpCode': line['op_code'],
          'ShipmentNumber': line['shipment_number'],
          'ShipmentDate': line['shipment_date'],
          'Line': line['line'],
          'Description': line['description'],
          'PackagingType': line['packaging_type'],
          'DefaultPackaging': line['default_packaging'],
          'PackagingNumbers': line['packaging_numbers'],
          'PackagingLetters': line['packaging_letters'],
          'Details': line['details'],
        }).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Ошибка при загрузке линий упаковок');
    }
  }

  void _addNewPackagingLine() {
    setState(() {
      _packagingLines.add({
        'id': null,
        'OrderID': '',
        'OpCode': '',
        'ShipmentNumber': '',
        'ShipmentDate': '',
        'Line': '',
        'Description': '',
        'PackagingType': '',
        'DefaultPackaging': 0,
        'PackagingNumbers': '',
        'PackagingLetters': '',
        'Details': '',
      });
    });
  }

  Future<void> _deletePackagingLine(int index) async {
    setState(() {
      _isLoading = true;
    });

    String token = "YOUR_TOKEN";
    var line = _packagingLines[index];

    if (line['id'] != null) {
      var url = "http://192.168.56.1:3000/api/packaging_lines/${line['id']}";

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
          _packagingLines.removeAt(index);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Ошибка при удалении линии упаковки с ID ${line['id']}'),
        ));
      }
    } else {
      setState(() {
        _packagingLines.removeAt(index);
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

    for (var line in _packagingLines) {
      if (line['id'] != null) {
        var url = "http://192.168.56.1:3000/api/packaging_lines/${line['id']}";

        final response = await http.put(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'order_id': line['OrderID'],
            'op_code': line['OpCode'],
            'shipment_number': line['ShipmentNumber'],
            'shipment_date': line['ShipmentDate'],
            'line': line['Line'],
            'description': line['Description'],
            'packaging_type': line['PackagingType'],
            'default_packaging': line['DefaultPackaging'],
            'packaging_numbers': line['PackagingNumbers'],
            'packaging_letters': line['PackagingLetters'],
            'details': line['Details'],
          }),
        );

        if (response.statusCode != 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Ошибка при сохранении линии упаковки с ID ${line['id']}'),
          ));
        }
      } else {
        var url = "http://192.168.56.1:3000/api/packaging_lines";

        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'order_id': line['OrderID'],
            'op_code': line['OpCode'],
            'shipment_number': line['ShipmentNumber'],
            'shipment_date': line['ShipmentDate'],
            'line': line['Line'],
            'description': line['Description'],
            'packaging_type': line['PackagingType'],
            'default_packaging': line['DefaultPackaging'],
            'packaging_numbers': line['PackagingNumbers'],
            'packaging_letters': line['PackagingLetters'],
            'details': line['Details'],
          }),
        );

        if (response.statusCode == 201) {
          final newLine = jsonDecode(response.body);
          setState(() {
            line['id'] = newLine['id'];
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Ошибка при создании новой линии упаковки'),
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
                  onPressed: _addNewPackagingLine,
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

    List<DataRow> rows = _packagingLines.map((line) {
      int index = _packagingLines.indexOf(line);
      return DataRow(
        cells: [
          DataCell(
            TextFormField(
              initialValue: line['OrderID'].toString(),
              onChanged: (value) {
                setState(() {
                  line['OrderID'] = int.tryParse(value) ?? 0;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: line['OpCode'],
              onChanged: (value) {
                setState(() {
                  line['OpCode'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: line['ShipmentNumber'],
              onChanged: (value) {
                setState(() {
                  line['ShipmentNumber'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: line['ShipmentDate'],
              onChanged: (value) {
                setState(() {
                  line['ShipmentDate'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: line['Line'],
              onChanged: (value) {
                setState(() {
                  line['Line'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: line['Description'],
              onChanged: (value) {
                setState(() {
                  line['Description'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: line['PackagingType'],
              onChanged: (value) {
                setState(() {
                  line['PackagingType'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: line['DefaultPackaging'].toString(),
              onChanged: (value) {
                setState(() {
                  line['DefaultPackaging'] = int.tryParse(value) ?? 0;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: line['PackagingNumbers'],
              onChanged: (value) {
                setState(() {
                  line['PackagingNumbers'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: line['PackagingLetters'],
              onChanged: (value) {
                setState(() {
                  line['PackagingLetters'] = value;
                });
              },
            ),
          ),
          DataCell(
            TextFormField(
              initialValue: line['Details'],
              onChanged: (value) {
                setState(() {
                  line['Details'] = value;
                });
              },
            ),
          ),
          DataCell(
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deletePackagingLine(index),
            ),
          ),
        ],
      );
    }).toList();

    return DataTable(
      columns: const [
        DataColumn(label: Text('OrderID')),
        DataColumn(label: Text('OpCode')),
        DataColumn(label: Text('ShipmentNumber')),
        DataColumn(label: Text('ShipmentDate')),
        DataColumn(label: Text('Line')),
        DataColumn(label: Text('Description')),
        DataColumn(label: Text('PackagingType')),
        DataColumn(label: Text('DefaultPackaging')),
        DataColumn(label: Text('PackagingNumbers')),
        DataColumn(label: Text('PackagingLetters')),
        DataColumn(label: Text('Details')),
        DataColumn(label: Text('Actions')),
      ],
      rows: rows,
    );
  }
}
