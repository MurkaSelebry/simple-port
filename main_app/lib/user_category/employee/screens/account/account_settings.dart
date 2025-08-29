import 'package:flutter/material.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  bool emailConfirmed = false;
  bool trackMyChanges = false;
  bool trackSalesOrders = false;
  bool trackSubDepartmentOrders = false;
  bool globalStatusNotifications = false;
  bool myStatusNotifications = false;
  bool newOrdersNotifications = false;
  bool commentsNotifications = false;
  bool documentsNotifications = false;
  bool marketingNotifications = false;
  bool pricesNotifications = false;
  bool sendEmailNotifications = false;
  bool telegramRegistered = false;
  bool sendTelegramNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Определяем, мобильный это экран или нет
                bool isMobile = constraints.maxWidth < 768;
                
                if (isMobile) {
                  // Мобильная версия - вертикальное расположение
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileSection(),
                      const SizedBox(height: 30),
                      _buildTrackingSection(),
                      const SizedBox(height: 30),
                      _buildNotificationsSection(),
                    ],
                  );
                } else {
                  // Десктопная версия - горизонтальное расположение
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(child: _buildProfileSection()),
                      const SizedBox(width: 20),
                      Expanded(child: _buildTrackingSection()),
                      const SizedBox(width: 20),
                      Expanded(child: _buildNotificationsSection()),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Профиль',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Ник',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Почта',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        CheckboxListTile(
          title: const Text('Почта подтверждена'),
          value: emailConfirmed,
          enabled: false,
          onChanged: (bool? value) {
            setState(() {
              emailConfirmed = value ?? false;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Отправить запрос на подтверждение почты'),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Фамилия',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Имя',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Отчество',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildTrackingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Автоматическое отслеживание',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Заказов при моем изменении'),
          value: trackMyChanges,
          onChanged: (bool? value) {
            setState(() {
              trackMyChanges = value ?? false;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Заказов отделов продаж на которые я подписан'),
          value: trackSalesOrders,
          onChanged: (bool? value) {
            setState(() {
              trackSalesOrders = value ?? false;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Заказов дочерних отделов продаж'),
          value: trackSubDepartmentOrders,
          onChanged: (bool? value) {
            setState(() {
              trackSubDepartmentOrders = value ?? false;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Уведомления',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('По глобальным правилам статусов'),
          value: globalStatusNotifications,
          onChanged: (bool? value) {
            setState(() {
              globalStatusNotifications = value ?? false;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('По моим правилам статусов'),
          value: myStatusNotifications,
          onChanged: (bool? value) {
            setState(() {
              myStatusNotifications = value ?? false;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('О новых заказах'),
          value: newOrdersNotifications,
          onChanged: (bool? value) {
            setState(() {
              newOrdersNotifications = value ?? false;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('О комментариях'),
          value: commentsNotifications,
          onChanged: (bool? value) {
            setState(() {
              commentsNotifications = value ?? false;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Об общих документах'),
          value: documentsNotifications,
          onChanged: (bool? value) {
            setState(() {
              documentsNotifications = value ?? false;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('О рекламных материалах'),
          value: marketingNotifications,
          onChanged: (bool? value) {
            setState(() {
              marketingNotifications = value ?? false;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('О прайсах'),
          value: pricesNotifications,
          onChanged: (bool? value) {
            setState(() {
              pricesNotifications = value ?? false;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Отправлять на email'),
          value: sendEmailNotifications,
          onChanged: (bool? value) {
            setState(() {
              sendEmailNotifications = value ?? false;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Telegram зарегистрирован'),
          value: telegramRegistered,
          enabled: false,
          onChanged: (bool? value) {
            setState(() {
              telegramRegistered = value ?? false;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Отправлять в Telegram'),
          value: sendTelegramNotifications,
          onChanged: (bool? value) {
            setState(() {
              sendTelegramNotifications = value ?? false;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}