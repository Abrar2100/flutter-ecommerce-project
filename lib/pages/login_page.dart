import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/link.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool loading = false;

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    var response = await http.post(
      Uri.parse(Links.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    setState(() => loading = false);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Successful!'),
          backgroundColor: Colors.green,
        ),
      );

      // الانتقال للصفحة الرئيسية بعد تسجيل الدخول
      Navigator.pushReplacementNamed(context, '/home');

    } else {
      var error = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error['message'] ?? 'Login Failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // خلفية بيضاء
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // شعار أو أي عنصر أصفر صغير
                  Container(
                    width: 80,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.yellow[700],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 30),

                  // عنوان الصفحة
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900], // أزرق داكن
                    ),
                  ),
                  SizedBox(height: 20),

                  // الحقول
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.blue[50], // أزرق فاتح خفيف
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.email, color: Colors.blue[900]),
                    ),
                    validator: (val) => val!.isEmpty ? 'Enter email' : null,
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.blue[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.lock, color: Colors.blue[900]),
                    ),
                    validator: (val) => val!.isEmpty ? 'Enter password' : null,
                  ),
                  SizedBox(height: 25),

                  // زر تسجيل الدخول
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: loading ? null : login,
                      child: loading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Login',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // رابط الانتقال لصفحة التسجيل
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account?', style: TextStyle(color: Colors.grey[700])),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.yellow[800], fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}