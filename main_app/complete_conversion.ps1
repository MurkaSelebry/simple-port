# Скрипт для завершения преобразования всех оставшихся таблиц

$files = @(
    "lib/user_category/employee/screens/catalog/dynamic_properties.dart",
    "lib/user_category/employee/screens/info/prices.dart",
    "lib/user_category/employee/screens/info/advertising_materials.dart",
    "lib/user_category/employee/screens/orders/packaging_lines.dart",
    "lib/user_category/employee/screens/orders/packaging.dart",
    "lib/user_category/employee/screens/orders/orders_and_packages.dart",
    "lib/user_category/employee/screens/orders/orders.dart",
    "lib/user_category/employee/screens/orders/deferred_packages.dart",
    "lib/user_category/employee/screens/administration/statuses.dart",
    "lib/user_category/employee/screens/administration/sales_departments.dart"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "Processing $file..."
        
        # Читаем содержимое файла
        $content = Get-Content $file -Raw
        
        # Заменяем DataTable на UniversalResponsiveTable
        $content = $content -replace 'return LayoutBuilder\([^}]*DataTable[^}]*\);', 'return UniversalResponsiveTable(data: ordersData, columns: [''Название'', ''Добавил'', ''Дата'', ''Изменил'', ''Изменено''], columnKeys: [''Название'', ''Добавил'', ''Дата'', ''Изменил'', ''Изменено''], onEdit: (index, field, value) { final order = filteredOrders[index]; final updatedOrder = order.copyWithField(field, value.toString()); setState(() { _orders[_orders.indexOf(order)] = updatedOrder; }); }, onDelete: (index) { setState(() { _orders.removeAt(index); }); }, onAdd: () { _showAddDialog(); }, primaryColor: Theme.of(context).colorScheme.primary, showFileUpload: true, columnTypes: { ''Дата'': ''date'', ''Изменено'': ''date'', }, );'
        
        # Сохраняем изменения
        Set-Content $file $content
        Write-Host "✓ $file processed"
    } else {
        Write-Host "✗ $file not found"
    }
}

Write-Host "Conversion completed!"
