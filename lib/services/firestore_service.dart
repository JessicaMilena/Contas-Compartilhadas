import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contas_compartilhadas/models/user_model.dart';
import 'package:contas_compartilhadas/models/group_model.dart';
import 'package:contas_compartilhadas/models/transaction_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserModel?> getUser(String userId) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromDocument(doc);
      } else {
        return null;
      }
    } catch (e) {
      _handleFirestoreError(e, 'usuário');
      return null;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _db.collection('users').doc(user.id).update(user.toMap());
    } catch (e) {
      _handleFirestoreError(e, 'usuário');
    }
  }

  Future<GroupModel?> getGroup(String groupId) async {
    try {
      DocumentSnapshot doc = await _db.collection('groups').doc(groupId).get();
      if (doc.exists) {
        return GroupModel.fromDocument(doc);
      } else {
        return null;
      }
    } catch (e) {
      _handleFirestoreError(e, 'grupo');
      return null;
    }
  }

  Future<void> updateGroup(GroupModel group) async {
    try {
      await _db.collection('groups').doc(group.id).update(group.toMap());
    } catch (e) {
      _handleFirestoreError(e, 'grupo');
    }
  }

  Future<TransactionModel?> getTransaction(String transactionId) async {
    try {
      DocumentSnapshot doc =
          await _db.collection('transactions').doc(transactionId).get();
      if (doc.exists) {
        return TransactionModel.fromDocument(doc);
      } else {
        return null;
      }
    } catch (e) {
      _handleFirestoreError(e, 'transação');
      return null;
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await _db
          .collection('transactions')
          .doc(transaction.id)
          .update(transaction.toMap());
    } catch (e) {
      _handleFirestoreError(e, 'transação');
    }
  }

  Future<void> updateFinancialSummary(
      String userId, double amount, String type) async {
    try {
      final summaryRef = _db
          .collection('users')
          .doc(userId)
          .collection('financial_summary')
          .doc('summary');

      await _db.runTransaction((transaction) async {
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

        if (type == 'Renda fixa') {
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

  void _handleFirestoreError(dynamic error, String type) {
    print('Erro ao operar no $type: $error');
  }
}
