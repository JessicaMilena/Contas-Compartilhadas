import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/groups_screen.dart';
import 'screens/create_group_screen.dart';
import 'screens/group_details_screen.dart';
import 'screens/edit_group_screen.dart';
import 'screens/add_transaction_screen.dart';
import 'screens/transactions_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/data_visualization_screen.dart';
import 'screens/shared_expenses_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/update_profile_screen.dart';
import 'screens/help_support_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/InviteMembersScreen.dart'; // Adicione esta linha

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contas Compartilhadas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/groups': (context) => GroupsScreen(),
        '/create_group': (context) => CreateGroupScreen(),
        '/group_details': (context) => GroupDetailsScreen(),
        '/edit_group': (context) => EditGroupScreen(),
        '/add_transaction': (context) => AddTransactionScreen(),
        '/reports': (context) => ReportsScreen(),
        '/transactions': (context) => TransactionsScreen(),
        '/data_visualization': (context) => DataVisualizationScreen(),
        '/shared_expenses': (context) => SharedExpensesScreen(),
        '/settings': (context) => SettingsScreen(),
        '/update_profile': (context) => UpdateProfileScreen(),
        '/help_support': (context) => HelpSupportScreen(),
        '/reset_password': (context) => ResetPasswordScreen(),
        '/invite_members': (context) =>
            InviteMembersScreen(), // Adicione esta linha
      },
    );
  }
}
