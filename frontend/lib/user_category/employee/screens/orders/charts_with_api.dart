import 'package:flutter/material.dart';
import 'package:diplom/services/api_service.dart';
import 'dart:math' as math;

class ChartsWithApi extends StatefulWidget {
  const ChartsWithApi({Key? key}) : super(key: key);

  @override
  State<ChartsWithApi> createState() => _ChartsWithApiState();
}

class _ChartsWithApiState extends State<ChartsWithApi> {
  Map<String, dynamic>? statistics;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await ApiService.getOrderStatistics();
      setState(() {
        statistics = response;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика заказов'),
        backgroundColor: Colors.blue[100],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStatistics,
            tooltip: 'Обновить данные',
          ),
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Ошибка загрузки данных',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadStatistics,
              child: const Text('Попробовать снова'),
            ),
          ],
        ),
      );
    }

    if (statistics == null) {
      return const Center(
        child: Text('Нет данных для отображения'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(),
          const SizedBox(height: 24),
          _buildPieChart(),
          const SizedBox(height: 24),
          _buildBarChart(),
          const SizedBox(height: 24),
          _buildDetailsTable(),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final total = statistics!['total'] ?? 0;
    final totalAmount = statistics!['totalAmount'] ?? 0.0;

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Всего заказов',
            total.toString(),
            Icons.shopping_cart,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            'Общая сумма',
            '${_formatAmount(totalAmount)} ₽',
            Icons.attach_money,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Распределение заказов по статусам',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomPaint(
                    painter: PieChartPainter(statistics!),
                  ),
                ),
                Expanded(
                  child: _buildLegend(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    final items = [
      {'label': 'Новые', 'value': statistics!['new'] ?? 0, 'color': Colors.green},
      {'label': 'В работе', 'value': statistics!['inProgress'] ?? 0, 'color': Colors.orange},
      {'label': 'Завершено', 'value': statistics!['completed'] ?? 0, 'color': Colors.purple},
      {'label': 'Отменено', 'value': statistics!['cancelled'] ?? 0, 'color': Colors.red},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: items.map((item) => _buildLegendItem(
        item['label'] as String,
        item['value'] as int,
        item['color'] as Color,
      )).toList(),
    );
  }

  Widget _buildLegendItem(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label: $value',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Количество заказов по статусам',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: BarChartPainter(statistics!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTable() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Детальная статистика',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Table(
            border: TableBorder.all(color: Colors.grey[300]!),
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
            },
            children: [
              _buildTableRow('Статус', 'Количество', isHeader: true),
              _buildTableRow('Новые', '${statistics!['new'] ?? 0}'),
              _buildTableRow('В работе', '${statistics!['inProgress'] ?? 0}'),
              _buildTableRow('Завершено', '${statistics!['completed'] ?? 0}'),
              _buildTableRow('Отменено', '${statistics!['cancelled'] ?? 0}'),
              _buildTableRow('Всего', '${statistics!['total'] ?? 0}', isTotal: true),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String value, {bool isHeader = false, bool isTotal = false}) {
    final textStyle = TextStyle(
      fontWeight: isHeader || isTotal ? FontWeight.bold : FontWeight.normal,
      color: isHeader ? Colors.white : (isTotal ? Colors.blue[800] : Colors.black),
    );

    final backgroundColor = isHeader 
        ? Colors.blue[600] 
        : (isTotal ? Colors.blue[50] : Colors.white);

    return TableRow(
      decoration: BoxDecoration(color: backgroundColor),
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(label, style: textStyle),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(value, style: textStyle, textAlign: TextAlign.center),
        ),
      ],
    );
  }

  String _formatAmount(dynamic amount) {
    if (amount == null) return '0.00';
    if (amount is num) {
      return amount.toStringAsFixed(2);
    }
    return amount.toString();
  }
}

class PieChartPainter extends CustomPainter {
  final Map<String, dynamic> statistics;

  PieChartPainter(this.statistics);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;

    final total = statistics['total'] ?? 0;
    if (total == 0) return;

    final values = [
      statistics['new'] ?? 0,
      statistics['inProgress'] ?? 0,
      statistics['completed'] ?? 0,
      statistics['cancelled'] ?? 0,
    ];

    final colors = [
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
    ];

    double startAngle = -math.pi / 2;

    for (int i = 0; i < values.length; i++) {
      final value = values[i] as int;
      if (value == 0) continue;

      final sweepAngle = 2 * math.pi * value / total;
      
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    // Draw border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BarChartPainter extends CustomPainter {
  final Map<String, dynamic> statistics;

  BarChartPainter(this.statistics);

  @override
  void paint(Canvas canvas, Size size) {
    final values = [
      statistics['new'] ?? 0,
      statistics['inProgress'] ?? 0,
      statistics['completed'] ?? 0,
      statistics['cancelled'] ?? 0,
    ];

    final colors = [
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
    ];

    final labels = ['Новые', 'В работе', 'Завершено', 'Отменено'];

    final maxValue = values.fold<int>(0, (prev, value) => math.max(prev, value as int));
    if (maxValue == 0) return;

    final barWidth = size.width / values.length * 0.8;
    final barSpacing = size.width / values.length * 0.2;

    for (int i = 0; i < values.length; i++) {
      final value = values[i] as int;
      final barHeight = (value / maxValue) * (size.height - 40);

      final left = i * (barWidth + barSpacing) + barSpacing / 2;
      final top = size.height - barHeight - 20;

      final rect = Rect.fromLTWH(left, top, barWidth, barHeight);
      
      final paint = Paint()..color = colors[i];
      canvas.drawRect(rect, paint);

      // Draw value text
      final textPainter = TextPainter(
        text: TextSpan(
          text: value.toString(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(
          left + (barWidth - textPainter.width) / 2,
          top - textPainter.height - 5,
        ),
      );

      // Draw label
      final labelPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      labelPainter.paint(
        canvas,
        Offset(
          left + (barWidth - labelPainter.width) / 2,
          size.height - 15,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 