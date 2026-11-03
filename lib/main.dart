import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider()..tryRestoreSession(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return MaterialApp(
      title: 'Campus Incident Reporting',
      theme: ThemeData(colorSchemeSeed: const Color(0xFF6C4CF1), useMaterial3: true),
      home: auth.isLoggedIn
          ? const Scaffold(body: Center(child: Text('Home goes here (Step 4)')))
          : const LoginScreen(),
    );
  }
}
