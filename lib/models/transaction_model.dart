import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String userId;
  final String description;
  final double amount;
  final String type; // "Fixo" ou "Variável"
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.description,
    required this.amount,
    required this.type,
    required this.date,
  });

  // Converte o modelo para um mapa para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'description': description,
      'amount': amount,
      'type': type,
      'date': Timestamp.fromDate(date),
    };
  }

  // Cria um modelo a partir de um documento do Firestore
  factory TransactionModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return TransactionModel(
      id: data['id'] ?? '',
      userId: data['userId'] ?? '',
      description: data['description'] ?? '',
      amount: (data['amount'] as num).toDouble(),
      type: data['type'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
    );
  }
}

void main() async {
  // Exemplo de como salvar uma transação no Firestore
  final transaction = TransactionModel(
    id: '123',
    userId: 'user123',
    description: 'Compra de café',
    amount: 4.50,
    type: 'Variável',
    date: DateTime.now(),
  );

  await FirebaseFirestore.instance
      .collection('transactions')
      .doc(transaction.id)
      .set(transaction.toMap());

  // Exemplo de como recuperar uma transação do Firestore
  final doc = await FirebaseFirestore.instance
      .collection('transactions')
      .doc('123')
      .get();

  final retrievedTransaction = TransactionModel.fromDocument(doc);

  print('Descrição: ${retrievedTransaction.description}');
  print('Valor: ${retrievedTransaction.amount}');
  print('Tipo: ${retrievedTransaction.type}');
  print('Data: ${retrievedTransaction.date}');
}
