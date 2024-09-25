import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:proyecto/Models/LoginResponse.dart';
import 'package:proyecto/page/home.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController txtUser = TextEditingController();
  TextEditingController txtPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQK9pIsCYx9Z9wPHyN-qDcqJMUALTYV0phaxw&s'),
            Padding(
                padding: EdgeInsets.all(40),
                child: TextFormField(
                  controller: txtUser,
                  decoration: InputDecoration(label: Text('Usuario')),
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 40),
              child: TextFormField(
                controller: txtPass,
                decoration: InputDecoration(label: Text('Contraseña')),
                obscureText: true,
              ),
            ),
            TextButton(
                onPressed: () async {
                  final response = await http.post(
                      Uri.parse('http://10.172.254.247:8000/api/login'),
                      body: jsonEncode(<String, dynamic>{
                        'email': txtUser.text,
                        'password': txtPass.text
                      }),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8'
                      });

                  print(response.body);
                  Map<String, dynamic> responseJson = jsonDecode(response.body);
                  final loginResponse = LoginResponse.fromJson(responseJson);
                  if (loginResponse.acceso == "OK") {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Home())
                  );
                  } else {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      title: 'Oops...',
                      text: 'Sorry, something went wrong',
                    );
                  }
                },
                child: Text('Acceder'))
          ],
        ),
      ),
    );
  }
}
