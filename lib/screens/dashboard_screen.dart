import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  bool _isLoading = true;
  double _totalIncome = 0.0;
  double _totalExpenses = 0.0;
  double _balance = 0.0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    if (user == null) {
      Navigator.of(context).pushReplacementNamed('/login');
    } else {
      _loadFinancialData();
    }
  }

  Future<void> _loadFinancialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final startOfMonth = Timestamp.fromDate(
          DateTime(DateTime.now().year, DateTime.now().month, 1));
      final endOfMonth = Timestamp.fromDate(
          DateTime(DateTime.now().year, DateTime.now().month + 1, 0));

      final transactionsSnapshot = await _firestore
          .collection('transactions')
          .where('userId', isEqualTo: user?.uid)
          .where('date', isGreaterThanOrEqualTo: startOfMonth)
          .where('date', isLessThanOrEqualTo: endOfMonth)
          .get(); // Use `get()` instead of `snapshots().first`

      double totalIncome = 0.0;
      double totalExpenses = 0.0;

      transactionsSnapshot.docs.forEach((doc) {
        final data = doc.data();
        final amount = data['amount'] as double;
        final type = data['type'] as String;

        if (type == 'income') {
          totalIncome += amount;
        } else if (type == 'expense') {
          totalExpenses += amount;
        }
      });

      setState(() {
        _totalIncome = totalIncome;
        _totalExpenses = totalExpenses;
        _balance = _totalIncome - _totalExpenses;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Falha ao carregar dados: ${error.toString()}'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Central de Finanças'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resumo Financeiro
                  Text(
                    'Resumo Financeiro',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  _buildSummaryCard(
                      'Total de Renda', _totalIncome, Colors.green),
                  SizedBox(height: 10),
                  _buildSummaryCard(
                      'Total de Despesas', _totalExpenses, Colors.red),
                  SizedBox(height: 10),
                  _buildSummaryCard('Saldo Atual', _balance, Colors.blue),
                  SizedBox(height: 20),

                  // Grid de Botões
                  Expanded(
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      children: [
                        _buildDashboardButton(context, Icons.group,
                            'Gerenciar Grupos', '/groups'),
                        _buildDashboardButton(context, Icons.add,
                            'Adicionar Despesa/Renda', '/add_transaction'),
                        _buildDashboardButton(context, Icons.pie_chart,
                            'Visualizar Relatórios', '/reports'),
                        _buildDashboardButton(context, Icons.bar_chart,
                            'Visualizar Dados', '/data_visualization'),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, double amount, Color color) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(title),
        trailing: Text(
          'R\$ ${amount.toStringAsFixed(2)}',
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildDashboardButton(
      BuildContext context, IconData icon, String label, String route) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.of(context).pushNamed(route);
      },
      icon: Icon(icon, size: 30),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16),
        textStyle: TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
