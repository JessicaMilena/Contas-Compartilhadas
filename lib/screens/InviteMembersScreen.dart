import 'package:flutter/material.dart';

class InviteMembersScreen extends StatefulWidget {
  @override
  _InviteMembersScreenState createState() => _InviteMembersScreenState();
}

class _InviteMembersScreenState extends State<InviteMembersScreen> {
  final _emailController = TextEditingController();

  void _sendInvitation() {
    final email = _emailController.text;

    if (email.isNotEmpty) {
      // Aqui você deve implementar a lógica para enviar o convite por e-mail.
      // Isso pode incluir o uso de um serviço backend para enviar e-mails.

      // Exemplo de mensagem de sucesso (substitua com sua lógica de envio de e-mail)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Convite enviado para $email')),
      );

      // Limpa o campo de texto
      _emailController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Convidar Membros'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-mail do Membro',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendInvitation,
              child: Text('Enviar Convite'),
            ),
          ],
        ),
      ),
    );
  }
}
