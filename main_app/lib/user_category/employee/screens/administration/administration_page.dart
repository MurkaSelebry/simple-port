import 'package:flutter/material.dart';
import 'sales_departments.dart';
import 'structure_of_sales_departments.dart';
import 'statuses.dart';
import 'users.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdminContent(),
    );
  }
}

class AdminContent extends StatefulWidget {
  const AdminContent({super.key});

  @override
  _AdminContentState createState() => _AdminContentState();
}

class _AdminContentState extends State<AdminContent> {
  int _selectedCategoryIndex = 0;

  final List<Widget> _pages = const[
    Users(),
    Statuses(),
    StructureOfSalesDepartments(),
    SalesDepartments(),
  ];

  final List<String> _categories = [
    'Пользователи',
    'Статусы',
    'Структура отделов продаж',
    'Отделы продаж',
  ];

  final List<IconData> _icons = [
    Icons.people,
    Icons.flag,
    Icons.account_tree,
    Icons.business,
  ];

  final List<Color> _categoryColors = [
    Color(0xFFFFF1E9), // Оранжевый (для пользователей)
    Color(0xFFE3F2FD), // Синий (для статусов)
    Color(0xFFF1F8E9), // Зеленый (для структуры)
    Color(0xFFFFE0B2), // Желтый (для отделов)
  ];

  // Метод для отображения выпадающего меню
  void _showPopupMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: _categories.length * 60.0, // Высота зависит от количества категорий
          ),
          child: ListView.builder(
            shrinkWrap: true, // Уменьшает размер до содержимого
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(_icons[index], color: Colors.black54),
                title: Text(_categories[index]),
                onTap: () {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                  Navigator.pop(context); // Закрыть меню
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Для узких экранов (мобильных устройств)
    if (screenWidth < 600) {
      return Column(
        children: [
          // Верхний ряд с иконкой меню и названием категории
          Container(
            color: Colors.white, // Устанавливаем белый фон
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => _showPopupMenu(context),
                ),
                Text(
                  _categories[_selectedCategoryIndex],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Содержимое текущей категории
          Expanded(
            child: _pages[_selectedCategoryIndex],
          ),
        ],
      );
    }

    // Для широких экранов (планшетов и десктопов)
    return Row(
      children: [
        // Боковая панель с категориями
        Container(
          width: 255,
          color: Colors.white,
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
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                  color: _selectedCategoryIndex == index
                      ? _categoryColors[index]
                      : Colors.transparent,
                  child: Row(
                    children: [
                      Icon(_icons[index], color: Colors.black54),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _categories[index],
                          style: const TextStyle(fontSize: 16.0),
                          overflow: TextOverflow.visible,
                          softWrap: true,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Содержимое текущей категории
        Expanded(
          child: _pages[_selectedCategoryIndex],
        ),
      ],
    );
  }
}