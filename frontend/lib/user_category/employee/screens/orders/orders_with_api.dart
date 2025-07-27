import 'package:flutter/material.dart';
import 'package:diplom/services/api_service.dart';

class OrdersWithApi extends StatefulWidget {
  const OrdersWithApi({Key? key}) : super(key: key);

  @override
  State<OrdersWithApi> createState() => _OrdersWithApiState();
}

class _OrdersWithApiState extends State<OrdersWithApi> {
  List<dynamic> orders = [];
  Map<String, dynamic>? statistics;
  bool isLoading = true;
  String? errorMessage;
  String? selectedStatus;
  String? selectedPriority;

  final List<String> statusOptions = ['New', 'InProgress', 'Completed', 'Cancelled'];
  final List<String> priorityOptions = ['High', 'Medium', 'Low'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await Future.wait([
        _loadOrders(),
        _loadStatistics(),
      ]);
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

  Future<void> _loadOrders() async {
    try {
      final response = await ApiService.getOrders(
        status: selectedStatus,
        priority: selectedPriority,
      );
      setState(() {
        orders = response['orders'] ?? [];
      });
    } catch (e) {
      throw Exception('Ошибка загрузки заказов: $e');
    }
  }

  Future<void> _loadStatistics() async {
    try {
      final response = await ApiService.getOrderStatistics();
      setState(() {
        statistics = response;
      });
    } catch (e) {
      throw Exception('Ошибка загрузки статистики: $e');
    }
  }

  void _onFilterChanged() {
    _loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заказы'),
        backgroundColor: Colors.blue[100],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Обновить данные',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          if (statistics != null) _buildStatistics(),
          Expanded(
            child: _buildOrdersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey[100],
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Статус',
                border: OutlineInputBorder(),
              ),
              value: selectedStatus,
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Все статусы'),
                ),
                ...statusOptions.map((status) => DropdownMenuItem<String>(
                  value: status,
                  child: Text(_getStatusText(status)),
                )),
              ],
              onChanged: (value) {
                setState(() {
                  selectedStatus = value;
                });
                _onFilterChanged();
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Приоритет',
                border: OutlineInputBorder(),
              ),
              value: selectedPriority,
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Все приоритеты'),
                ),
                ...priorityOptions.map((priority) => DropdownMenuItem<String>(
                  value: priority,
                  child: Text(_getPriorityText(priority)),
                )),
              ],
              onChanged: (value) {
                setState(() {
                  selectedPriority = value;
                });
                _onFilterChanged();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Статистика заказов',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard('Всего', statistics!['total']?.toString() ?? '0', Colors.blue),
              _buildStatCard('Новые', statistics!['new']?.toString() ?? '0', Colors.green),
              _buildStatCard('В работе', statistics!['inProgress']?.toString() ?? '0', Colors.orange),
              _buildStatCard('Завершено', statistics!['completed']?.toString() ?? '0', Colors.purple),
              _buildStatCard('Отменено', statistics!['cancelled']?.toString() ?? '0', Colors.red),
            ],
          ),
          if (statistics!['totalAmount'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                'Общая сумма: ${_formatAmount(statistics!['totalAmount'])} руб.',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildOrdersList() {
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
              onPressed: _loadData,
              child: const Text('Попробовать снова'),
            ),
          ],
        ),
      );
    }

    if (orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Заказы не найдены',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ExpansionTile(
        title: Text(
          order['title'] ?? 'Без названия',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${order['id']}'),
            Text('Статус: ${_getStatusText(order['status'])}'),
            Text('Приоритет: ${_getPriorityText(order['priority'])}'),
          ],
        ),
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(order['status']),
          child: Text(
            '${order['id']}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (order['description'] != null)
                  _buildInfoRow('Описание', order['description']),
                _buildInfoRow('Создан', _formatDate(order['createdAt'])),
                if (order['updatedAt'] != null)
                  _buildInfoRow('Обновлен', _formatDate(order['updatedAt'])),
                if (order['completedAt'] != null)
                  _buildInfoRow('Завершен', _formatDate(order['completedAt'])),
                if (order['assignedUser'] != null)
                  _buildInfoRow('Исполнитель', order['assignedUser']['nick']),
                if (order['notes'] != null)
                  _buildInfoRow('Примечания', order['notes']),
                if (order['totalAmount'] != null)
                  _buildInfoRow('Сумма', '${_formatAmount(order['totalAmount'])} руб.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'New':
        return 'Новый';
      case 'InProgress':
        return 'В работе';
      case 'Completed':
        return 'Завершено';
      case 'Cancelled':
        return 'Отменено';
      default:
        return status ?? 'Неизвестно';
    }
  }

  String _getPriorityText(String? priority) {
    switch (priority) {
      case 'High':
        return 'Высокий';
      case 'Medium':
        return 'Средний';
      case 'Low':
        return 'Низкий';
      default:
        return priority ?? 'Неизвестно';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'New':
        return Colors.green;
      case 'InProgress':
        return Colors.orange;
      case 'Completed':
        return Colors.purple;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  String _formatAmount(dynamic amount) {
    if (amount == null) return '0';
    if (amount is num) {
      return amount.toStringAsFixed(2);
    }
    return amount.toString();
  }
} 