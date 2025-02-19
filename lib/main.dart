import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_todo/firebase_options.dart';
import 'package:firebase_todo/screens/desborad/splash_screen/splash_view.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// ensure karega firebase initialize hai ya nahi
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// firebase core initializeApp

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashView(),
    );
  }
}
