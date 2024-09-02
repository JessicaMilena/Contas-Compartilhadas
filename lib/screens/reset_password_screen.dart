import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _message = '';

  void _resetPassword() async {
    final email = _emailController.text;

    try {
      await _auth.sendPasswordResetEmail(email: email);
      setState(() {
        _message = 'Um e-mail de redefinição de senha foi enviado para $email.';
      });
    } catch (e) {
      setState(() {
        _message = 'Ocorreu um erro: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Redefinir Senha')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _resetPassword,
              child: Text('Redefinir Senha'),
            ),
            SizedBox(height: 16.0),
            Text(_message),
          ],
        ),
      ),
    );
  }
}
