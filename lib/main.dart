import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:widgets_screens/adapt/login_screen.dart';
import 'package:widgets_screens/screens/home_page.dart';
import 'adapt/profile_screen.dart';
import 'firebase_options.dart';

void main() async {
  // Certifique-se de que os widgets Flutter estão inicializados antes de inicializar o Firebase.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialize o Firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicie o aplicativo.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: LoginScreen(),
    );
  }
}
