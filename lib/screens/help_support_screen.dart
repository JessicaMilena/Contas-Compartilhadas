import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajuda e Suporte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção de FAQ
            Text(
              'Perguntas Frequentes (FAQ)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildFAQItem(
              'Como posso recuperar minha senha?',
              'Para recuperar sua senha, clique em "Esqueci minha senha" na tela de login e siga as instruções enviadas para o seu email.',
            ),
            _buildFAQItem(
              'Como posso alterar meu email?',
              'Para alterar seu email, vá até a tela de configurações e selecione "Atualizar Perfil".',
            ),
            SizedBox(height: 20),

            // Seção de Suporte Técnico
            Text(
              'Suporte Técnico',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Se você encontrar algum problema técnico ou precisar de assistência adicional, entre em contato conosco através dos seguintes canais:',
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email de Suporte'),
              subtitle: Text('suporte@contascompartilhadas.com.br'),
              onTap: () {
                _launchEmail('suporte@contascompartilhadas.com.br');
              },
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Telefone de Suporte'),
              subtitle: Text('(11) 1234-5678'),
              onTap: () {
                _launchPhone('(11) 1234-5678');
              },
            ),
            SizedBox(height: 20),

            // Seção de Feedback
            Text(
              'Deixe seu Feedback',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Sua opinião é importante para nós! Se você tiver sugestões ou comentários, por favor, entre em contato com a nossa equipe.',
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _launchFeedbackForm();
              },
              child: Text('Enviar Feedback'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(answer),
        ),
      ],
    );
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': 'Suporte'},
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Não foi possível abrir o email';
    }
  }

  void _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Não foi possível iniciar a chamada';
    }
  }

  void _launchFeedbackForm() async {
    final Uri feedbackUri = Uri.parse('https://example.com/feedback-form');
    if (await canLaunchUrl(feedbackUri)) {
      await launchUrl(feedbackUri);
    } else {
      throw 'Não foi possível abrir o formulário de feedback';
    }
  }
}
