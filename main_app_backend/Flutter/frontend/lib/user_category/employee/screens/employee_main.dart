import 'package:flutter/material.dart';
import 'screens.dart';

void main() {
  runApp(EmployeeMainPage());
}

class EmployeeMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedCategory;

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  Widget _buildContent() {
    switch (_selectedCategory) {
      case 'Информация':
        return InfoPage();
      case 'Заказы':
        return OrdersPage();
      case 'QR код':
        return QRPage();
      case 'Каталог':
        return CatalogPage();
      case 'Администрирование':
        return AdminPage();
      case 'Настройки аккаунта':
        return AccountSettingsPage();
      default:
        return Center(
          child: Text('Выберите категорию', style: TextStyle(fontSize: 18), selectionColor: Colors.orange,),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16.0,
            runSpacing: 8.0,
            children: <Widget>[
              _buildCategoryButton('Информация'),
              _buildCategoryButton('Заказы'),
              _buildCategoryButton('QR код'),
              _buildCategoryButton('Каталог'),
              _buildCategoryButton('Администрирование'),
              _buildCategoryButton('Настройки аккаунта'),
            ],
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    final bool isSelected = _selectedCategory == category;

    return GestureDetector(
      onTap: () {
        _selectCategory(category);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Text(
              category,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.orange : Colors.black,
              ),
            ),
            if (isSelected)
              Container(
                margin: EdgeInsets.only(top: 4.0),
                height: 2.0,
                width: 60.0,
                color: Colors.orange,
              ),
          ],
        ),
      ),
    );
  }
}
