import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: AdminPage(),
    );
  }
}

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _emailController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _searchEmailController = TextEditingController();
  String _selectedRole = 'User';
  String _statusMessage = '';
  bool _userFound = false;
  String _createdUserInfo = '';

  List<String> _roles = ['Admin', 'User', 'Guest'];

  // Function to generate a random password
  String _generatePassword() {
    final Random random = Random();
    const String letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String numbers = '0123456789';
    const String specials = '@_';

    String password = '';
    password += letters[random.nextInt(26) + 26]; // One uppercase letter
    password += letters[random.nextInt(26)]; // One lowercase letter
    password += numbers[random.nextInt(10)]; // One digit
    password += specials[random.nextInt(2)]; // One special character

    // Generate remaining characters to make up the length of 8
    final String chars = letters + numbers + specials;
    for (int i = 4; i < 8; i++) {
      password += chars[random.nextInt(chars.length)];
    }

    // Shuffle the password to ensure random order
    List<String> passwordList = password.split('');
    passwordList.shuffle(random);
    return passwordList.join('');
  }

  void _createUser() {
    // Handle user creation
    String email = _emailController.text;
    String nickname = _nicknameController.text;
    String password = _generatePassword();

    setState(() {
      _createdUserInfo =
          'Email: $email\nNickname: $nickname\nRole: $_selectedRole\nPassword: $password';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User created')),
    );
    _emailController.clear();
    _nicknameController.clear();
  }

  void _searchUser() {
    // Dummy logic for demonstration
    String emailToSearch = _searchEmailController.text;

    // Simulate user search logic
    setState(() {
      if (emailToSearch == 'found@example.com') {
        _userFound = true;
        _statusMessage = 'User found';
      } else {
        _userFound = false;
        _statusMessage = 'User not found';
      }
    });
  }

  void _deleteUser() {
    // Handle user deletion
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User deleted')),
    );
  }

  void _updateUser() {
    // Handle user update
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Row(
          children: [
            // Form for creating a user
            Expanded(
              flex: 1,
              child: ListView(
                children: <Widget>[
                  Text(
                    'Create User',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _nicknameController,
                    decoration: InputDecoration(labelText: 'Nickname'),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    items: _roles.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRole = newValue!;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Role'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _createUser,
                    child: Text('Create User'),
                  ),
                  SizedBox(height: 32),
                  Text(
                    'Search User',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _searchEmailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _searchUser,
                    child: Text('Search'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    _statusMessage,
                    style: TextStyle(
                      fontSize: 18,
                      color: _userFound ? Colors.green : Colors.red,
                    ),
                  ),
                  if (_userFound)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: _deleteUser,
                          child: Text('Delete User'),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _updateUser,
                          child: Text('Update User'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(width: 32),
            // Displaying created user information
            Expanded(
              flex: 1,
              child: _createdUserInfo.isNotEmpty
                  ? Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        _createdUserInfo,
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : Center(
                      child: Text(
                        'User info will be displayed here',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
