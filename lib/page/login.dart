import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                  decoration: InputDecoration(label: Text('Usuario')
                  ),
                )
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 40),
              child: TextFormField(
                decoration: InputDecoration(label: Text('Contraseña')
                ),
                obscureText: true,
              ),
            ),
            TextButton(onPressed: ()
            {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                text: 'Transaction Completed Successfully!',
              );
            }, child: Text('Acceder'))
          ],
        ),
      ),
    );
  }
}
