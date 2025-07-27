import 'package:diplom/user_category/admin/admin.dart';
import 'package:diplom/user_category/employee/screens/employee_main.dart';
import 'package:diplom/services/api_service.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Корпоративный портал',
        theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      color: Colors.white,
      routes: {
        '/employee': (context) => EmployeeMainPage(),
        '/admin': (context) => AdminPage(),
      },
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _nickFocusNode = FocusNode();

  String _email = '';
  String _password = '';
  String _nick = '';

  String? _emailError;
  String? _passwordError;
  String? _nickError;

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _nickFocusNode.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите вашу почту';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Введите корректный адрес почты';
    }
    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Введите ваш пароль';
    }
    if (password.length < 6) {
      return 'Пароль должен содержать минимум 6 символов';
    }
    return null;
  }

  String? _validateNick(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите ваш ник';
    }
    return null;
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      try {
        // Показываем индикатор загрузки
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        // Выполняем авторизацию
        final result = await ApiService.login(_email, _password);
        
        // Скрываем индикатор загрузки
        Navigator.pop(context);
        
        // Переходим на главную страницу
        Navigator.pushReplacementNamed(context, '/employee');
        
      } catch (e) {
        // Скрываем индикатор загрузки
        Navigator.pop(context);
        
        // Показываем ошибку
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Ошибка'),
              content: Text('Ошибка входа: $e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            decoration: BoxDecoration(
              //color: Colors.white,
              color: const Color(0xFFFFF3EE), // Светло-оранжевый фон
              borderRadius: BorderRadius.circular(24.0),
            ),
            width: isSmallScreen ? screenWidth * 0.9 : screenWidth * 0.5,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Вход',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildTextField(
                    label: 'Ник',
                    focusNode: _nickFocusNode,
                    errorText: _nickError,
                    validator: _validateNick,
                    onChanged: (value) {
                      setState(() {
                        _nickError = _validateNick(value);
                      });
                    },
                    onSaved: (value) => _nick = value!,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_emailFocusNode),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildTextField(
                    label: 'Почта',
                    focusNode: _emailFocusNode,
                    errorText: _emailError,
                    validator: _validateEmail,
                    onChanged: (value) {
                      setState(() {
                        _emailError = _validateEmail(value);
                      });
                    },
                    onSaved: (value) => _email = value!,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_passwordFocusNode),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildTextField(
                    label: 'Пароль',
                    focusNode: _passwordFocusNode,
                    errorText: _passwordError,
                    validator: _validatePassword,
                    onChanged: (value) {
                      setState(() {
                        _passwordError = _validatePassword(value);
                      });
                    },
                    onSaved: (value) => _password = value!,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _login(),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  GestureDetector(
                    onTap: _login,
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB998), // Оранжевая кнопка
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: const Text(
                        'Войти',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(height: screenHeight * 0.02),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.pushNamed(context, '/admin');
                  //   },
                  //   child: Container(
                  //     alignment: Alignment.center,
                  //     width: double.infinity,
                  //     padding: EdgeInsets.symmetric(
                  //         vertical: screenHeight * 0.02),
                  //     decoration: BoxDecoration(
                  //       color: const Color(0xFFFFB998),
                  //       borderRadius: BorderRadius.circular(20.0),
                  //     ),
                  //     child: const Text(
                  //       'Админ',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: screenHeight * 0.02),
                  // GestureDetector(
                  //   onTap: () {
                  //     // Navigate to registration page
                  //   },
                  //   child: const Text(
                  //     "Нет аккаунта? Зарегистрироваться",
                  //     style: TextStyle(color: Colors.orange),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required FocusNode focusNode,
    required FormFieldValidator<String>? validator,
    required ValueChanged<String> onChanged,
    required FormFieldSetter<String> onSaved,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    TextInputAction textInputAction = TextInputAction.done,
    ValueChanged<String>? onFieldSubmitted,
    String? errorText,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        errorText: errorText,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orangeAccent),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orange),
          borderRadius: BorderRadius.circular(12.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      focusNode: focusNode,
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
