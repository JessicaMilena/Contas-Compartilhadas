import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contas_compartilhadas/models/user_model.dart';
import 'package:contas_compartilhadas/models/group_model.dart';
import 'package:contas_compartilhadas/models/transaction_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Adiciona um novo usuário ao Firestore.
  Future<void> addUser(UserModel user) async {
    try {
      await _db.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      _handleDatabaseError(e, 'usuário');
    }
  }

  /// Adiciona um novo grupo ao Firestore.
  Future<void> addGroup(GroupModel group) async {
    try {
      await _db.collection('groups').doc(group.id).set(group.toMap());
    } catch (e) {
      _handleDatabaseError(e, 'grupo');
    }
  }

  /// Adiciona uma nova transação ao Firestore.
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await _db
          .collection('transactions')
          .doc(transaction.id)
          .set(transaction.toMap());
    } catch (e) {
      _handleDatabaseError(e, 'transação');
    }
  }

  /// Obtém uma lista de usuários do Firestore.
  Stream<List<UserModel>> getUsers() {
    return _db.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromDocument(doc)).toList();
    });
  }

  /// Obtém uma lista de grupos do Firestore.
  Stream<List<GroupModel>> getGroups() {
    return _db.collection('groups').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => GroupModel.fromDocument(doc)).toList();
    });
  }

  /// Obtém uma lista de transações do Firestore.
  Stream<List<TransactionModel>> getTransactions() {
    return _db.collection('transactions').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TransactionModel.fromDocument(doc))
          .toList();
    });
  }

  /// Lida com erros do Firestore e imprime uma mensagem amigável.
  void _handleDatabaseError(dynamic error, String type) {
    print('Erro ao adicionar $type: $error');
  }
}
