import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Cria uma conta de usuário com o [email] e [password] fornecidos.
  /// Retorna o usuário criado em caso de sucesso, ou `null` em caso de erro.
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      _handleAuthError(e);
      return null;
    }
  }

  /// Faz login do usuário com o [email] e [password] fornecidos.
  /// Retorna o usuário autenticado em caso de sucesso, ou `null` em caso de erro.
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      _handleAuthError(e);
      return null;
    }
  }

  /// Faz logout do usuário atual.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      _handleAuthError(e);
    }
  }

  /// Retorna o usuário atualmente autenticado.
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Manipula e exibe erros de autenticação.
  void _handleAuthError(dynamic error) {
    // Aqui você pode implementar um sistema de logging ou mostrar mensagens de erro amigáveis
    print('Erro de autenticação: $error');
  }
}
