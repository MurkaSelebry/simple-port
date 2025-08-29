import 'package:flutter/material.dart';

class Reports extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildMenuCard(
            context,
            'Заказы с ценой по отгрузке',
            Icons.attach_money,
            Colors.amber[600]!,
            () => _navigateTo(context, OrdersWithShipmentPriceScreen()),
          ),
          SizedBox(height: 16),
          _buildMenuCard(
            context,
            'Отгрузочная ведомость',
            Icons.list_alt,
            Colors.green[600]!,
            () => _navigateTo(context, ShipmentListScreen()),
          ),
          SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('УПАКОВКИ', style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            )),
          ),
          SizedBox(height: 8),
          _buildMenuCard(
            context,
            'По упаковщикам',
            Icons.people,
            Colors.purple[600]!,
            () => _navigateTo(context, ByPackersScreen()),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, 
                        Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        splashColor: color.withOpacity(0.2),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              SizedBox(width: 16),
              Text(title, style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              )),
              Spacer(),
              Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => screen,
    ));
  }
}

class OrdersWithShipmentPriceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _BaseScreen(
      title: 'Заказы с ценой по отгрузке',
      child: Column(
        children: [
          _buildDropdown('Номер отгрузки'),
          SizedBox(height: 24),
          _buildCreateButton(context),
        ],
      ),
    );
  }
}

class ShipmentListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _BaseScreen(
      title: 'Отгрузочная ведомость',
      child: Column(
        children: [
          _buildTextField('Год отгрузки'),
          SizedBox(height: 16),
          _buildTextField('Номер отгрузки'),
          SizedBox(height: 16),
          _buildDropdown('Салон'),
          SizedBox(height: 16),
          _buildDropdown('По заказу'),
          SizedBox(height: 16),
          _buildDropdown('Статус упаковок*'),
          SizedBox(height: 16),
          _buildTextField('Грузоотправитель'),
          SizedBox(height: 24),
          _buildCreateButton(context),
        ],
      ),
    );
  }
}

class ByPackersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _BaseScreen(
      title: 'По упаковщикам',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildTextField('За период C')),
              SizedBox(width: 16),
              Expanded(child: _buildTextField('ПО')),
            ],
          ),
          SizedBox(height: 16),
          _buildDropdown('Статус'),
          SizedBox(height: 24),
          _buildCreateButton(context),
        ],
      ),
    );
  }
}

class _BaseScreen extends StatelessWidget {
  final String title;
  final Widget child;

  const _BaseScreen({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[700]!, Colors.blue[400]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: child,
      ),
    );
  }
}

Widget _buildTextField(String label) {
  return TextFormField(
    decoration: InputDecoration(
      labelText: label,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    ),
    style: TextStyle(fontSize: 16, color: Colors.black),
  );
}

Widget _buildDropdown(String label) {
  return DropdownButtonFormField<String>(
    decoration: InputDecoration(
      labelText: label,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    items: ['Вариант 1', 'Вариант 2', 'Вариант 3']
        .map((label) => DropdownMenuItem(
              child: Text(label),
              value: label,
            ))
        .toList(),
    onChanged: (value) {},
    hint: Text('Выбрать...', style: TextStyle(color: Colors.black)),
    style: TextStyle(fontSize: 16, color: Colors.black),
    icon: Icon(Icons.arrow_drop_down, size: 28, color: Colors.black),
    isExpanded: true,
  );
}

Widget _buildCreateButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Документ создан', style: TextStyle(color: Colors.white)),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    },
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 14),
      child: Text('СОЗДАТЬ', style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      )),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue[600],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      minimumSize: Size(double.infinity, 50),
    ),
  );
}
