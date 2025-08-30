import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class QRPage extends StatefulWidget {
  @override
  _QRPageState createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  String _selectedType = 'Упаковка';
  String? _selectedStatus;
  String? _selectedShipment;
  String? _selectedSalon;
  String? _selectedNumber;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      print('Picked image from ${source == ImageSource.camera ? 'camera' : 'gallery'}: ${image.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: ListView(
          children: <Widget>[
            _buildDropdownSection(),
            SizedBox(height: 16),
            _buildImagePickerSection(),
            SizedBox(height: 16),
            _buildOrderLinesSection(),
            SizedBox(height: 16),
            _buildDataTableSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownSection() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildDropdown('Тип упаковки', _selectedType, ['Упаковка', 'Возвратная упаковка'], (value) {
              setState(() {
                _selectedType = value!;
              });
            }),
            _buildDropdown('Статус', _selectedStatus, ['Статус 1', 'Статус 2'], (value) {
              setState(() {
                _selectedStatus = value!;
              });
            }),
            _buildDropdown('По отгрузке', _selectedShipment, ['SWE', 'Другой'], (value) {
              setState(() {
                _selectedShipment = value!;
              });
            }),
            _buildDropdown('По салону', _selectedSalon, ['Салон 1', 'Салон 2'], (value) {
              setState(() {
                _selectedSalon = value!;
              });
            }),
            _buildDropdown('По номеру', _selectedNumber, ['Номер 1', 'Номер 2'], (value) {
              setState(() {
                _selectedNumber = value!;
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items, ValueChanged<String?>? onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((item) => DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        )).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildImagePickerSection() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ExpansionTile(
        title: Text('Выбор изображения'),
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Выбрать из галереи'),
            onTap: () => _pickImage(ImageSource.gallery),
          ),
          if (Theme.of(context).platform == TargetPlatform.android ||
              Theme.of(context).platform == TargetPlatform.iOS)
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Сделать фото'),
              onTap: () => _pickImage(ImageSource.camera),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderLinesSection() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ExpansionTile(
        title: Text('Линии заказа'),
        children: <Widget>[
          ListTile(title: Text('Линия 1')),
          ListTile(title: Text('Линия 2')),
        ],
      ),
    );
  }

  Widget _buildDataTableSection() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(35.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const <DataColumn>[
              DataColumn(label: Text('Название')),
              DataColumn(label: Text('Описание')),
              DataColumn(label: Text('Тип упаковки')),
              DataColumn(label: Text('Упаковка')),
              DataColumn(label: Text('Номер')),
              DataColumn(label: Text('Из букв')),
              DataColumn(label: Text('Дата')),
              DataColumn(label: Text('Создано')),
              DataColumn(label: Text('Общий статус')),
              DataColumn(label: Text('Возврат')),
            ],
            rows: const <DataRow>[
              // Add DataRow instances here if needed
            ],
          ),
        ),
      ),
    );
  }
}
