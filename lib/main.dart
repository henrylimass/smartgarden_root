import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Containers/Welcome/welcome_screen.dart';
import 'Containers/login/loginscreen.dart';
import 'Containers/cadastro/SignupScreen.dart';
//import 'Containers/HOME/HomeScreen.dart';
import 'Containers/HOME/RootScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Garden',
      theme: ThemeData(useMaterial3: true),
      home: const WelcomeScreen(),
      routes: {
        '/welcome': (_) => const WelcomeScreen(),
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => RegisterScreen(),
        '/home': (_) => const RootScreen(),
      },
    );
  }
}


