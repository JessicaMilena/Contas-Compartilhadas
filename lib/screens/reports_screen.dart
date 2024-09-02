import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatórios'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Adicionar Novo Relatório',
            onPressed: () {
              // Implementar ação para adicionar novo relatório
            },
          ),
          IconButton(
            icon: Icon(Icons.download),
            tooltip: 'Exportar Relatórios',
            onPressed: () {
              // Implementar ação para exportar relatórios
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Texto explicativo
            Text(
              'Aqui você encontrará relatórios financeiros detalhados.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Barra de Pesquisa
            TextField(
              decoration: InputDecoration(
                labelText: 'Pesquisar Relatórios',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // ListView de relatórios
            Expanded(
              child: _buildReportList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportList(BuildContext context) {
    // Exemplo de lista de relatórios. No uso real, você pode carregar dados de uma fonte.
    final reports = [
      {
        'title': 'Relatório de Julho',
        'description': 'Resumo financeiro do mês de julho.'
      },
      {
        'title': 'Relatório de Agosto',
        'description': 'Resumo financeiro do mês de agosto.'
      },
      // Adicione mais relatórios conforme necessário
    ];

    if (reports.isEmpty) {
      return Center(child: Text('Nenhum relatório disponível.'));
    }

    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return _buildReportCard(
          title: report['title']!,
          description: report['description']!,
          onTap: () {
            // Navegar para detalhes do relatório
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ReportDetailScreen(report: report),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildReportCard({
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}

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
            Text(
              report['description'] ?? '',
              style: TextStyle(fontSize: 16),
            ),
            // Adicione mais detalhes do relatório conforme necessário
            SizedBox(height: 20),
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
