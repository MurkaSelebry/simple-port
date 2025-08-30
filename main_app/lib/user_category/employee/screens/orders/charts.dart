import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MaterialApp(
    title: 'Графики заказов',
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
      canvasColor: Colors.white,
    ),
    home: Charts(),
  ));
}

class Charts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Графики заказов', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ChartSection(
              title: 'Заказы по ОП',
              filters: [
                NumericFilter(label: 'За последние N дней', initialValue: 30),
                NumericFilter(label: 'Результатов на график', initialValue: 46),
                DropdownFilter(
                  label: 'Типы заказов',
                  options: [
                    'Кухня',
                    'Фасад',
                    'Дозаказ',
                    'Рекламация',
                    'Переделка',
                    'Столешница',
                    'Стекло',
                    'Образцы',
                    'Уголок кухонный',
                    'Объединенная группа',
                    'Гардероб'
                  ],
                ),
              ],
              content: BarChartWidget(),
            ),
            SizedBox(height: 32),
            ChartSection(
              title: 'Заказы по статусам (Фасад)',
              filters: [
                NumericFilter(label: 'За последние N дней', initialValue: 30),
                NumericFilter(label: 'Результатов на график', initialValue: 10),
                DropdownFilter(
                  label: 'Типы заказов',
                  options: [
                    'Кухня',
                    'Фасад',
                    'Дозаказ',
                    'Рекламация',
                    'Переделка',
                    'Столешница',
                    'Стекло',
                    'Образцы',
                    'Уголок кухонный',
                    'Объединенная группа',
                    'Гардероб'
                  ],
                ),
              ],
              content: FacadPieChartWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartSection extends StatelessWidget {
  final String title;
  final List<Widget> filters;
  final Widget content;

  const ChartSection({
    required this.title,
    required this.filters,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: filters,
          ),
          SizedBox(height: 16),
          content,
        ],
      ),
    );
  }
}

class NumericFilter extends StatefulWidget {
  final String label;
  final int initialValue;

  const NumericFilter({required this.label, required this.initialValue});

  @override
  _NumericFilterState createState() => _NumericFilterState();
}

class _NumericFilterState extends State<NumericFilter> {
  late int value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  void increment() {
    setState(() {
      value++;
    });
  }

  void decrement() {
    setState(() {
      if (value > 0) value--;
    });
  }

  void updateValue(String input) {
    final int? newValue = int.tryParse(input);
    if (newValue != null && newValue >= 0) {
      setState(() {
        value = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${widget.label}: ',
            style: TextStyle(color: Colors.black),
          ),
          IconButton(
            icon: Icon(Icons.remove, color: Colors.black, size: 20),
            onPressed: decrement,
            padding: EdgeInsets.zero,
          ),
          SizedBox(
            width: 40,
            child: TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              controller: TextEditingController(text: value.toString()),
              onSubmitted: updateValue,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(color: Colors.black),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.black, size: 20),
            onPressed: increment,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class DropdownFilter extends StatefulWidget {
  final String label;
  final List<String> options;

  const DropdownFilter({required this.label, required this.options});

  @override
  _DropdownFilterState createState() => _DropdownFilterState();
}

class _DropdownFilterState extends State<DropdownFilter> {
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.options.isNotEmpty ? widget.options[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${widget.label}: ',
            style: TextStyle(color: Colors.black),
          ),
          SizedBox(width: 4),
          DropdownButton<String>(
            value: selectedOption,
            onChanged: (newValue) {
              setState(() {
                selectedOption = newValue;
              });
            },
            dropdownColor: Colors.white,
            style: TextStyle(color: Colors.black, fontSize: 14),
            underline: Container(),
            icon: Icon(Icons.arrow_drop_down, color: Colors.black),
            items: widget.options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class BarChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          backgroundColor: Colors.white,
          alignment: BarChartAlignment.spaceAround,
          barGroups: List.generate(10, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: (index + 1) * 10.0,
                  color: Colors.blueAccent,
                  width: 16,
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'ОП ${(value + 1).toInt()}',
                    style: TextStyle(color: Colors.black, fontSize: 10),
                  ),
                ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: TextStyle(color: Colors.black, fontSize: 10),
                ),
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 10,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.shade200,
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey.shade200,
                strokeWidth: 1,
              );
            },
          ),
        ),
      ),
    );
  }
}

class FacadPieChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Text(
          'Тип заказов: Фасад',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 300,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: 25,
                  color: Colors.blue,
                  title: 'Чертеж\n25%',
                  titleStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  radius: 60,
                ),
                PieChartSectionData(
                  value: 20,
                  color: Colors.green,
                  title: 'Производство\n20%',
                  titleStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  radius: 60,
                ),
                PieChartSectionData(
                  value: 15,
                  color: Colors.orange,
                  title: 'Покраска\n15%',
                  titleStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  radius: 60,
                ),
                PieChartSectionData(
                  value: 30,
                  color: Colors.red,
                  title: 'Сборка\n30%',
                  titleStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  radius: 60,
                ),
                PieChartSectionData(
                  value: 10,
                  color: Colors.purple,
                  title: 'Доставка\n10%',
                  titleStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  radius: 60,
                ),
              ],
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              startDegreeOffset: -90,
            ),
          ),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLegendItem(Colors.blue, 'Чертеж (25%)'),
              _buildLegendItem(Colors.green, 'Производство (20%)'),
              _buildLegendItem(Colors.orange, 'Покраска (15%)'),
              _buildLegendItem(Colors.red, 'Сборка (30%)'),
              _buildLegendItem(Colors.purple, 'Доставка (10%)'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}