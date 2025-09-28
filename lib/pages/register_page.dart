import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/link.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  bool loading = false;

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    var response = await http.post(
      Uri.parse(Links.register),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'password_confirmation': confirmController.text,
      }),
    );

    setState(() => loading = false);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Register Successful! Token: ${data['access_token']}')),
      );
      Navigator.pop(context); // ارجع لصفحة login
    } else {
      var error = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error['message'] ?? 'Register Failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter name' : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter email' : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter password' : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: confirmController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) => val!.isEmpty ? 'Confirm password' : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: loading ? null : register,
                  child: loading ? CircularProgressIndicator(color: Colors.white) : Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}