import 'package:flutter/material.dart';
import 'package:frontend/user_category/employee/screens/screens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      theme: ThemeData(
        fontFamily: 'Arial',
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _selectedCategory = 'Информация';

  final Map<String, Widget> _pages = {
    'Информация': InfoPage(),
    'Заказы': OrdersPage(),
    'QR код': QRPage(),
    'Каталог': CatalogPage(),
    'Администрирование': AdminPage(),
    'Настройки аккаунта': AccountSettingsPage(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Главное меню'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.orange[100],
            padding: EdgeInsets.symmetric(vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _pages.keys.map((String key) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = key;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        key,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: _selectedCategory == key ? Colors.black : Colors.brown,
                          fontWeight: _selectedCategory == key ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: _pages[_selectedCategory]!,
          ),
        ],
      ),
    );
  }
}
