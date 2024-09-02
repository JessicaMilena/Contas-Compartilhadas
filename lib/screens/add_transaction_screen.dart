import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  String _transactionType = 'Despesas';

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    final description = _descriptionController.text;
    final amount = double.parse(_amountController.text);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {
      final transactionsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions');

      // Salva a transação
      await transactionsRef.add({
        'description': description,
        'amount': amount,
        'type': _transactionType,
        'date': Timestamp.now(),
      });

      // Atualiza o resumo financeiro
      await _updateFinancialSummary(user.uid, amount, _transactionType);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transação adicionada com sucesso')),
      );

      _descriptionController.clear();
      _amountController.clear();
      setState(() {
        _transactionType = 'Despesas';
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Falha ao adicionar transação: ${error.toString()}')),
      );
    }
  }

  Future<void> _updateFinancialSummary(
      String userId, double amount, String type) async {
    try {
      final summaryRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('financial_summary')
          .doc('summary');

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(summaryRef);

        if (!snapshot.exists) {
          await summaryRef.set({
            'income': 0.0,
            'expenses': 0.0,
          });
        }

        final data = snapshot.data()!;
        final income = (data['income'] ?? 0.0) as double;
        final expenses = (data['expenses'] ?? 0.0) as double;

        if (type == 'Renda') {
          transaction.update(summaryRef, {
            'income': income + amount,
          });
        } else if (type == 'Despesas') {
          transaction.update(summaryRef, {
            'expenses': expenses + amount,
          });
        }
      });
    } catch (error) {
      print('Erro ao atualizar resumo financeiro: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Transação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma descrição';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um valor';
                  }
                  final parsedValue = double.tryParse(value);
                  if (parsedValue == null || parsedValue <= 0) {
                    return 'Por favor, insira um valor válido e positivo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _transactionType,
                decoration: InputDecoration(labelText: 'Tipo de Transação'),
                items: ['Despesas', 'Renda'].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _transactionType = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTransaction,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
