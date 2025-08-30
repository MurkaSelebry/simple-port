import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const AdminPage({super.key});

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

  final List<String> _roles = ['Admin', 'User', 'Guest'];

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
    const String chars = letters + numbers + specials;
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
      const SnackBar(content: Text('User created')),
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
      const SnackBar(content: Text('User deleted')),
    );
  }

  void _updateUser() {
    // Handle user update
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
        leading: IconButton(
          icon: const Icon(Icons.home),
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
                  const Text(
                    'Create User',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nicknameController,
                    decoration: const InputDecoration(labelText: 'Nickname'),
                  ),
                  const SizedBox(height: 16),
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
                    decoration: const InputDecoration(labelText: 'Role'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _createUser,
                    child: const Text('Create User'),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Search User',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchEmailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _searchUser,
                    child: const Text('Search'),
                  ),
                  const SizedBox(height: 16),
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
                          child: const Text('Delete User'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _updateUser,
                          child: const Text('Update User'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(width: 32),
            // Displaying created user information
            Expanded(
              flex: 1,
              child: _createdUserInfo.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        _createdUserInfo,
                        style: const TextStyle(fontSize: 18),
                      ),
                    )
                  : const Center(
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
