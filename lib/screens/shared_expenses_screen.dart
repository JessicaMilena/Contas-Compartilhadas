import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SharedExpensesScreen extends StatefulWidget {
  @override
  _SharedExpensesScreenState createState() => _SharedExpensesScreenState();
}

class _SharedExpensesScreenState extends State<SharedExpensesScreen> {
  String _selectedMonth = DateFormat('yyyy-MM').format(DateTime.now());
  bool _isLoading = true;
  List<DocumentSnapshot> _expenses = [];

  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      final snapshot = await _firestore
          .collection('transactions')
          .where('date',
              isGreaterThanOrEqualTo: DateTime.parse('$_selectedMonth-01'))
          .where('date',
              isLessThan: DateTime.parse('$_selectedMonth-01').add(Duration(
                  days: DateTime(DateTime.parse(_selectedMonth).year,
                          DateTime.parse(_selectedMonth).month + 1, 0)
                      .day)))
          .get();

      setState(() {
        _expenses = snapshot.docs;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Falha ao carregar gastos: ${error.toString()}'),
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
        title: Text('Gastos Compartilhados'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seletor de mês
            DropdownButtonFormField<String>(
              value: _selectedMonth,
              onChanged: (value) {
                setState(() {
                  _selectedMonth = value!;
                  _loadExpenses();
                });
              },
              items: List.generate(
                12,
                (index) {
                  final month =
                      DateTime.now().subtract(Duration(days: 30 * index));
                  final formattedMonth = DateFormat('yyyy-MM').format(month);
                  return DropdownMenuItem(
                    value: formattedMonth,
                    child: Text(DateFormat('MMMM yyyy').format(month)),
                  );
                },
              ),
              decoration: InputDecoration(
                labelText: 'Selecionar Mês',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Lista de gastos
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: _expenses.length,
                      itemBuilder: (context, index) {
                        final expense =
                            _expenses[index].data() as Map<String, dynamic>;
                        final description = expense['description'] as String;
                        final amount = expense['amount'] as double;
                        final date = expense['date'] as Timestamp;

                        return ListTile(
                          title: Text(description),
                          subtitle: Text(
                              DateFormat('dd/MM/yyyy').format(date.toDate())),
                          trailing: Text('R\$ ${amount.toStringAsFixed(2)}'),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
