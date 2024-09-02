import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final double fixedIncome;
  final String accountType;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.fixedIncome,
    required this.accountType,
  });

  // Converte o modelo para um mapa para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'fixedIncome': fixedIncome,
      'accountType': accountType,
    };
  }

  // Cria um modelo a partir de um documento do Firestore
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      fixedIncome: (data['fixedIncome'] as num).toDouble(),
      accountType: data['accountType'] ?? '',
    );
  }
}
