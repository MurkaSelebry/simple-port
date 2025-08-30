import 'package:flutter/material.dart';
import 'package:diplom/services/api_service.dart';

class InfoWithApi extends StatefulWidget {
  const InfoWithApi({Key? key}) : super(key: key);

  @override
  State<InfoWithApi> createState() => _InfoWithApiState();
}

class _InfoWithApiState extends State<InfoWithApi> {
  List<dynamic> infoItems = [];
  bool isLoading = true;
  String? errorMessage;
  String? selectedCategory;

  final List<String> categories = [
    'documents',
    'advertising',
    'prices',
    'general',
  ];

  final Map<String, String> categoryNames = {
    'documents': 'Документы',
    'advertising': 'Реклама',
    'prices': 'Прайсы',
    'general': 'Общие',
  };

  @override
  void initState() {
    super.initState();
    _loadInfoItems();
  }

  Future<void> _loadInfoItems() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await ApiService.getInfoItems(category: selectedCategory);
      setState(() {
        infoItems = response['items'] ?? [];
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

  void _onCategoryChanged(String? category) {
    setState(() {
      selectedCategory = category;
    });
    _loadInfoItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Информационные материалы'),
        backgroundColor: Colors.green[100],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInfoItems,
            tooltip: 'Обновить данные',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(
            child: _buildInfoItemsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey[100],
      child: Row(
        children: [
          const Text(
            'Категория:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              value: selectedCategory,
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Все категории'),
                ),
                ...categories.map((category) => DropdownMenuItem<String>(
                  value: category,
                  child: Text(categoryNames[category] ?? category),
                )),
              ],
              onChanged: _onCategoryChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItemsList() {
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
              onPressed: _loadInfoItems,
              child: const Text('Попробовать снова'),
            ),
          ],
        ),
      );
    }

    if (infoItems.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Информационные материалы не найдены',
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
      itemCount: infoItems.length,
      itemBuilder: (context, index) {
        final item = infoItems[index];
        return _buildInfoItemCard(item);
      },
    );
  }

  Widget _buildInfoItemCard(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getCategoryColor(item['category']),
          child: Icon(
            _getCategoryIcon(item['category']),
            color: Colors.white,
          ),
        ),
        title: Text(
          item['title'] ?? 'Без названия',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item['description'] != null)
              Text(
                item['description'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Text(
              'Категория: ${categoryNames[item['category']] ?? item['category']}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            if (item['createdAt'] != null)
              Text(
                'Создано: ${_formatDate(item['createdAt'])}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          _showItemDetails(item);
        },
      ),
    );
  }

  void _showItemDetails(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item['title'] ?? 'Детали'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item['description'] != null) ...[
                const Text(
                  'Описание:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(item['description']),
                const SizedBox(height: 16),
              ],
              _buildDetailRow('ID', item['id']?.toString()),
              _buildDetailRow('Категория', categoryNames[item['category']] ?? item['category']),
              if (item['content'] != null)
                _buildDetailRow('Содержимое', item['content']),
              if (item['createdAt'] != null)
                _buildDetailRow('Создано', _formatDate(item['createdAt'])),
              if (item['updatedAt'] != null)
                _buildDetailRow('Обновлено', _formatDate(item['updatedAt'])),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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

  Color _getCategoryColor(String? category) {
    switch (category) {
      case 'documents':
        return Colors.blue;
      case 'advertising':
        return Colors.purple;
      case 'prices':
        return Colors.green;
      case 'general':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String? category) {
    switch (category) {
      case 'documents':
        return Icons.description;
      case 'advertising':
        return Icons.campaign;
      case 'prices':
        return Icons.price_change;
      case 'general':
        return Icons.info;
      default:
        return Icons.help_outline;
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
} 