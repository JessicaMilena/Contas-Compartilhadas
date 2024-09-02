import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseTile extends StatelessWidget {
  final String description;
  final double amount;
  final String type;
  final DateTime date;

  const ExpenseTile({
    required this.description,
    required this.amount,
    required this.type,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final color = type == 'Fixo' ? Colors.green : Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Icon(
          type == 'Fixo' ? Icons.attach_money : Icons.money_off,
          color: color,
        ),
        title: Text(
          description,
          style: TextStyle(color: color),
        ),
        subtitle: Text(
          '${amount.toStringAsFixed(2)} - ${type}',
          style: TextStyle(color: color),
        ),
        trailing: Text(
          DateFormat('dd/MM/yyyy').format(date),
        ),
      ),
    );
  }
}
