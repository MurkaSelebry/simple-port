import 'package:flutter/material.dart';
import 'package:diplom/services/api_service.dart';
import 'dart:convert';

class ApiStatusScreen extends StatefulWidget {
  const ApiStatusScreen({Key? key}) : super(key: key);

  @override
  State<ApiStatusScreen> createState() => _ApiStatusScreenState();
}

class _ApiStatusScreenState extends State<ApiStatusScreen> {
  bool isChecking = false;
  bool? isApiHealthy;
  String? lastCheckTime;
  Map<String, dynamic>? orderStats;
  Map<String, dynamic>? infoStats;
  List<String> connectionLogs = [];

  @override
  void initState() {
    super.initState();
    _performHealthCheck();
  }

  Future<void> _performHealthCheck() async {
    setState(() {
      isChecking = true;
      connectionLogs.clear();
    });

    final startTime = DateTime.now();
    _addLog('Начинаем проверку состояния API...');

    try {
      // Проверка здоровья API
      _addLog('Проверяем доступность API...');
      final healthCheck = await ApiService.checkHealth();
      setState(() {
        isApiHealthy = healthCheck;
      });
      
      if (healthCheck) {
        _addLog('✅ API доступен');
        
        // Загрузка статистики заказов
        _addLog('Загружаем статистику заказов...');
        try {
          final orders = await ApiService.getOrderStatistics();
          setState(() {
            orderStats = orders;
          });
          _addLog('✅ Статистика заказов загружена');
        } catch (e) {
          _addLog('❌ Ошибка загрузки статистики заказов: $e');
        }

        // Загрузка информационных элементов
        _addLog('Загружаем информационные элементы...');
        try {
          final info = await ApiService.getInfoItems();
          setState(() {
            infoStats = info;
          });
          _addLog('✅ Информационные элементы загружены');
        } catch (e) {
          _addLog('❌ Ошибка загрузки информационных элементов: $e');
        }
      } else {
        _addLog('❌ API недоступен');
      }

    } catch (e) {
      setState(() {
        isApiHealthy = false;
      });
      _addLog('❌ Ошибка при проверке API: $e');
    }

    final endTime = DateTime.now();
    final duration = endTime.difference(startTime);
    
    setState(() {
      isChecking = false;
      lastCheckTime = '${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}:${endTime.second.toString().padLeft(2, '0')}';
    });
    
    _addLog('Проверка завершена за ${duration.inMilliseconds}мс');
  }

  void _addLog(String message) {
    setState(() {
      connectionLogs.add('${DateTime.now().toIso8601String().substring(11, 19)}: $message');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Состояние API'),
        backgroundColor: Colors.orange[100],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isChecking ? null : _performHealthCheck,
            tooltip: 'Обновить состояние',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(),
            const SizedBox(height: 16),
            if (orderStats != null) _buildOrderStatsCard(),
            if (infoStats != null) _buildInfoStatsCard(),
            const SizedBox(height: 16),
            _buildApiInfoCard(),
            const SizedBox(height: 16),
            _buildConnectionLogs(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (isChecking) {
      statusColor = Colors.orange;
      statusIcon = Icons.sync;
      statusText = 'Проверяется...';
    } else if (isApiHealthy == true) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
      statusText = 'API работает';
    } else if (isApiHealthy == false) {
      statusColor = Colors.red;
      statusIcon = Icons.error;
      statusText = 'API недоступен';
    } else {
      statusColor = Colors.grey;
      statusIcon = Icons.help;
      statusText = 'Статус неизвестен';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (isChecking)
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      color: statusColor,
                      strokeWidth: 3,
                    ),
                  )
                else
                  Icon(statusIcon, size: 32, color: statusColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                      if (lastCheckTime != null)
                        Text(
                          'Последняя проверка: $lastCheckTime',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusIndicator(
                  'Заказы',
                  orderStats != null,
                  orderStats != null ? '${orderStats!['total'] ?? 0}' : '-',
                ),
                _buildStatusIndicator(
                  'Информация',
                  infoStats != null,
                  infoStats != null ? '${(infoStats!['items'] as List?)?.length ?? 0}' : '-',
                ),
                _buildStatusIndicator(
                  'API',
                  isApiHealthy == true,
                  isApiHealthy == true ? 'OK' : 'ERROR',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String label, bool isOk, String value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (isOk ? Colors.green : Colors.red).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isOk ? Icons.check : Icons.close,
            color: isOk ? Colors.green : Colors.red,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderStatsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Статистика заказов',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildStatChip('Всего', '${orderStats!['total'] ?? 0}', Colors.blue),
                _buildStatChip('Новые', '${orderStats!['new'] ?? 0}', Colors.green),
                _buildStatChip('В работе', '${orderStats!['inProgress'] ?? 0}', Colors.orange),
                _buildStatChip('Завершено', '${orderStats!['completed'] ?? 0}', Colors.purple),
                _buildStatChip('Отменено', '${orderStats!['cancelled'] ?? 0}', Colors.red),
              ],
            ),
            if (orderStats!['totalAmount'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Общая сумма: ${_formatAmount(orderStats!['totalAmount'])} ₽',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoStatsCard() {
    final items = infoStats!['items'] as List? ?? [];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Информационные элементы',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Всего элементов: ${items.length}'),
            const SizedBox(height: 8),
            if (items.isNotEmpty) ...[
              const Text('Последние элементы:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              ...items.take(3).map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  '• ${item['title'] ?? 'Без названия'}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Chip(
      label: Text(
        '$label: $value',
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
    );
  }

  Widget _buildApiInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Информация об API',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Базовый URL', ApiService.baseUrl),
            _buildInfoRow('Доступные endpoints', '/api/orders, /api/info, /api/auth'),
            _buildInfoRow('Поддерживаемые методы', 'GET, POST'),
            _buildInfoRow('Формат данных', 'JSON'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
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

  Widget _buildConnectionLogs() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Журнал подключений',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      connectionLogs.clear();
                    });
                  },
                  tooltip: 'Очистить журнал',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: connectionLogs.isEmpty
                  ? const Center(
                      child: Text(
                        'Журнал пуст',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: connectionLogs.length,
                      itemBuilder: (context, index) {
                        final log = connectionLogs[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          child: Text(
                            log,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                              color: log.contains('❌') 
                                  ? Colors.red 
                                  : log.contains('✅') 
                                      ? Colors.green 
                                      : Colors.black87,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
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