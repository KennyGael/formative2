import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/incident_provider.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';
import 'utils/constants.dart';

/// Debug-only switch for the Firebase Storage emulator (see README).
const bool kUseStorageEmulator = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Billing workaround: send photo uploads to the local Storage emulator while
  // developing. Auth and Firestore still use the real cloud project.
  // Set kUseStorageEmulator to false once real Firebase Storage is available.
  if (kUseStorageEmulator && kDebugMode) {
    await FirebaseStorage.instance.useStorageEmulator('10.0.2.2', 9199);
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..tryRestoreSession()),
        ChangeNotifierProvider(create: (_) => IncidentProvider()),
      ],
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
      theme: ThemeData(
        colorSchemeSeed: AppColors.primary,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.coral,
          foregroundColor: Colors.white,
        ),
      ),
      home: auth.isLoggedIn ? const MainShell() : const LoginScreen(),
    );
  }
}
