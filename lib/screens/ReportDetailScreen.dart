import 'package:flutter/material.dart';

class ReportDetailScreen extends StatelessWidget {
  final Map<String, String> report;

  ReportDetailScreen({required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(report['title'] ?? 'Detalhes do Relatório'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título do Relatório
            Text(
              report['title'] ?? 'Título do Relatório',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Descrição do Relatório
            Text(
              report['description'] ?? 'Descrição do relatório não disponível.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Seção para mais detalhes (se necessário)
            if (report.containsKey('additionalDetails') &&
                report['additionalDetails']!.isNotEmpty) ...[
              Text(
                'Detalhes Adicionais:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                report['additionalDetails']!,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
            ],

            // Botão para exportar ou outras ações, se necessário
            ElevatedButton(
              onPressed: () {
                // Implementar ação para exportar ou compartilhar relatório
              },
              child: Text('Exportar Relatório'),
            ),
          ],
        ),
      ),
    );
  }
}
