import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'order_lines_table.dart';

class QRPage extends StatefulWidget {
  const QRPage({super.key});

  @override
  _QRPageState createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  String? _selectedType;
  String? _selectedStatus;
  String? _selectedShipment;
  String? _selectedSalon;
  String? _selectedNumber;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Изображение получено из ${source == ImageSource.camera ? 'камеры' : 'галереи'}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: const Text('Управление заказами'),
      //   centerTitle: true,
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   foregroundColor: Colors.black87,
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStatusSection(theme),
            const SizedBox(height: 24),
            _buildCameraSection(colorScheme),
            const SizedBox(height: 24),
            _buildOrderLinesSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection(ThemeData theme) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tune,
                  color: Colors.deepPurple[400],
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Установка статуса',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDropdown('Тип упаковки', _selectedType, 
              ['Упаковка', 'Возвратная упаковка'], (value) {
                setState(() => _selectedType = value);
              }),
            const SizedBox(height: 12),
            _buildDropdown('Статус', _selectedStatus, 
              ['Активен', 'Закрыт', 'В обработке'], (value) {
                setState(() => _selectedStatus = value);
              }),
            const SizedBox(height: 12),
            _buildDropdown('По отгрузке', _selectedShipment, 
              ['SWE', 'Другой', 'Все'], (value) {
                setState(() => _selectedShipment = value);
              }),
            const SizedBox(height: 12),
            _buildDropdown('По салону', _selectedSalon, 
              ['Салон 1', 'Салон 2', 'Все салоны'], (value) {
                setState(() => _selectedSalon = value);
              }),
            const SizedBox(height: 12),
            _buildDropdown('По номеру', _selectedNumber, 
              ['Номер 1', 'Номер 2', 'Все номера'], (value) {
                setState(() => _selectedNumber = value);
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items, ValueChanged<String?>? onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      dropdownColor: Colors.white,
      items: items.map((item) => DropdownMenuItem<String>(
        value: item,
        child: Text(
          item, 
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
      )).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.deepPurple[300],
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.deepPurple[400]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      style: const TextStyle(
        fontSize: 16, 
        color: Colors.black87,
      ),
      hint: Text(
        'Выберите $label', 
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildCameraSection(ColorScheme colorScheme) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.qr_code_scanner,
                  color: Colors.deepPurple[500],
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Сканирование QR-кода',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.camera_alt, size: 24),
                    label: const Text(
                      'Камера',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () => _pickImage(ImageSource.camera),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.deepPurple[400],
                      side: BorderSide(color: Colors.deepPurple[400]!, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.photo_library, size: 24),
                    label: const Text(
                      'Галерея',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () => _pickImage(ImageSource.gallery),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.deepPurple[400],
                      side: BorderSide(color: Colors.deepPurple[400]!, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderLinesSection(ThemeData theme) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: Icon(
          Icons.table_rows,
          color: Colors.deepPurple[400],
          size: 22,
        ),
        title: Text(
          'Линии заказа',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.deepPurple[600],
          ),
        ),
        iconColor: Colors.deepPurple[400],
        collapsedIconColor: Colors.deepPurple[400],
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: const OrderLinesTable(),
          ),
        ],
      ),
    );
  }
}