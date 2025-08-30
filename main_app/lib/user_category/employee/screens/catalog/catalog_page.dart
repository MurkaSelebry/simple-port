import 'package:flutter/material.dart';
import 'dynamic_properties.dart';
import 'groups.dart';
import 'product_codes.dart';
import 'products.dart';
import 'subgroups.dart';
import 'types_of_subgroups.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _CatalogContent(),
    );
  }
}

class _CatalogContent extends StatefulWidget {
  const _CatalogContent();

  @override
  State<_CatalogContent> createState() => _CatalogContentState();
}

class _CatalogContentState extends State<_CatalogContent> {
  int _selectedCategoryIndex = 0;

  final List<Widget> _pages = const[
    Products(),
    Groups(),
    Subgroups(),
    TypesOfSubgroups(),
    DynamicProperties(),
    ProductCodes(),
  ];

  final List<String> _categories = [
    'Продукты',
    'Группы',
    'Подгруппы',
    'Типы подгрупп',
    'Динамические свойства',
    'Коды продуктов',
  ];

  final List<IconData> _icons = [
    Icons.shopping_cart,
    Icons.bar_chart,
    Icons.inventory,
    Icons.build,
    Icons.archive,
    Icons.schedule,
    Icons.assignment,
  ];

  final List<Color> _categoryColors = [
    Color(0xFFFFF1E9),
    Color(0xFFE3F2FD),
    Color(0xFFF1F8E9),
    Color(0xFFFFE0B2),
    Color(0xFFD1C4E9),
    Color(0xFFB2DFDB),
    Color(0xFFFFCDD2),
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
                      Text(
                        _categories[index],
                        style: const TextStyle(fontSize: 16.0),
                      ),
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