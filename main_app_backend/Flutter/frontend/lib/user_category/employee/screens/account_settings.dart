import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AccountSettingsPage extends StatefulWidget {
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
  List<Map<String, dynamic>> users = [];

Future<void> _fetchData() async{
    
    String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjMiLCJleHAiOjE3Mjg2MTY3MTJ9.3cx6NXwHIhHcZnjcmX534sV2JV_SnYDeV7oFPxdl1qE";
    var url = "http://192.168.56.1:3000/api/users";

    final response = await http.get(Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        users = data.map((order) => {
          'id': order['ID'], // Важно сохранять ID для дальнейших обновлений
          'Ник': order['nickname'],
          'email': order['email'],
          'ФИО': order['fullname'],

        }).toList();
      });
    } else {
      setState(() {
      });
      throw Exception('Ошибка при загрузке заказов');
    }
}

  Future<void> _saveAcSet() async {
    String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjMiLCJleHAiOjE3Mjg2MTY3MTJ9.3cx6NXwHIhHcZnjcmX534sV2JV_SnYDeV7oFPxdl1qE";
    var id = '2';
    var url = "http://192.168.56.1:3000/api/users/${id}";
      for (var user in users){
        final response = await http.put(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'id': user['ID'], // Важно сохранять ID для дальнейших обновлений
          'Ник': user['nickname'],
          'email': user['email'],
          'ФИО': user['fullname'],
          }),
        );  
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Профиль',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
            
                      decoration: InputDecoration(labelText: 'Ник'),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    CheckboxListTile(
                      title: Text('Email подтвержден'),
                      value: emailConfirmed,
                      enabled: false,
                      onChanged: (bool? value) {
                        setState(() {
                          emailConfirmed = value ?? false;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Отправить запрос на подтверждение Email'),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'ФИО'),
                    ),
                    ElevatedButton(onPressed: _saveAcSet,  
                    child: Text('Отправить запрос на подтверждение Email')),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Автоматически отслеживание',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    CheckboxListTile(
                      title: Text('Заказов при моем изменении'),
                      value: trackMyChanges,
                      onChanged: (bool? value) {
                        setState(() {
                          trackMyChanges = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Заказов отделов продаж на которые я подписан'),
                      value: trackSalesOrders,
                      onChanged: (bool? value) {
                        setState(() {
                          trackSalesOrders = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Заказов дочерних отделов продаж'),
                      value: trackSubDepartmentOrders,
                      onChanged: (bool? value) {
                        setState(() {
                          trackSubDepartmentOrders = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Уведомления',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    CheckboxListTile(
                      title: Text('По глобальным правилам статусов'),
                      value: globalStatusNotifications,
                      onChanged: (bool? value) {
                        setState(() {
                          globalStatusNotifications = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('По моим правилам статусов'),
                      value: myStatusNotifications,
                      onChanged: (bool? value) {
                        setState(() {
                          myStatusNotifications = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('О новых заказах'),
                      value: newOrdersNotifications,
                      onChanged: (bool? value) {
                        setState(() {
                          newOrdersNotifications = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('О комментариях'),
                      value: commentsNotifications,
                      onChanged: (bool? value) {
                        setState(() {
                          commentsNotifications = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Об общих документах'),
                      value: documentsNotifications,
                      onChanged: (bool? value) {
                        setState(() {
                          documentsNotifications = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('О рекламных материалах'),
                      value: marketingNotifications,
                      onChanged: (bool? value) {
                        setState(() {
                          marketingNotifications = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('О прайсах'),
                      value: pricesNotifications,
                      onChanged: (bool? value) {
                        setState(() {
                          pricesNotifications = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Отправлять на email'),
                      value: sendEmailNotifications,
                      onChanged: (bool? value) {
                        setState(() {
                          sendEmailNotifications = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Telegram зарегистрирован'),
                      value: telegramRegistered,
                      enabled: false,
                      onChanged: (bool? value) {
                        setState(() {
                          telegramRegistered = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Отправлять в Telegram'),
                      value: sendTelegramNotifications,
                      onChanged: (bool? value) {
                        setState(() {
                          sendTelegramNotifications = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}