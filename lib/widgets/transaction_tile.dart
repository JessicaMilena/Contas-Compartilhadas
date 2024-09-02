import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final String description;
  final double amount;
  final String type;
  final DateTime date;

  const TransactionTile({
    required this.description,
    required this.amount,
    required this.type,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Icon(
          type == 'Fixo' ? Icons.attach_money : Icons.money_off,
          color: type == 'Fixo' ? Colors.green : Colors.red,
        ),
        title: Text(
          description,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${amount.toStringAsFixed(2)} - $type',
          style: TextStyle(color: Colors.grey[700]),
        ),
        trailing: Text(formatter.format(date)),
      ),
    );
  }
}
