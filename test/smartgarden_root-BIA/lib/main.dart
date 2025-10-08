import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// suas telas
import 'LoginScreen.dart';
import 'SignupScreen.dart';
// RootScreen centraliza a bottom navigation e alterna entre Home/Plants/etc.
import 'RootScreen.dart';
import 'session_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class AppColors {
  static const brand = Color(0xFFFDB94F);
  static const accent = Color(0xFFFDB94F);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseText = GoogleFonts.montserratAlternates();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Garden',
      theme: ThemeData(
        textTheme: TextTheme(bodyMedium: baseText),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.brand),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        '/welcome': (_) => const WelcomeScreen(),
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        // agora a rota /home aponta para o RootScreen (que contém HomeScreen + PlantsScreen etc.)
        '/home': (_) => const RootScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final loggedIn = await SessionManager.isLoggedIn();
    await Future.delayed(const Duration(milliseconds: 800)); // splash curto
    if (loggedIn) {
      // navega para a raíz da app com a tela que contém a BottomNav (RootScreen)
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // navega para WelcomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundfolhas.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.25),
                    Colors.black.withOpacity(0.55),
                    Colors.black.withOpacity(0.75),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Center(
                    child: SizedBox(
                      width: 150,
                      height: 50,
                      child: Image.asset('assets/images/Logov1.1.png'),
                    ),
                  ),
                  const SizedBox(height: 100),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Seu jardim,\nna palma\nda mão',
                          style: GoogleFonts.montserratAlternates(
                            color: const Color(0xFFD6D79B),
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            height: 1.05,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 15),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: size.width * 0.9),
                          child: Text(
                            'Cuide das suas plantas de forma simples e intuitiva',
                            style: GoogleFonts.montserratAlternates(
                              color: AppColors.accent,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 150),
                  PillButton.white(
                    label: 'Criar conta',
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                  ),
                  const SizedBox(height: 14),
                  PillButton.filled(
                    label: 'Login',
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PillButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool filled;

  const PillButton._({
    required this.label,
    required this.onPressed,
    required this.filled,
  });

  factory PillButton.filled({required String label, required VoidCallback? onPressed}) =>
      PillButton._(label: label, onPressed: onPressed, filled: true);

  factory PillButton.white({required String label, required VoidCallback? onPressed}) =>
      PillButton._(label: label, onPressed: onPressed, filled: false);

  @override
  Widget build(BuildContext context) {
    final baseStyle = GoogleFonts.montserratAlternates(fontSize: 15, fontWeight: FontWeight.w700);
    final background = filled ? AppColors.brand : Colors.white;
    final foreground = filled ? Colors.black : Colors.black87;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: filled ? 2 : 0,
          shadowColor: Colors.black45,
          backgroundColor: background,
          foregroundColor: foreground,
          shape: const StadiumBorder(),
        ),
        child: Text(label, style: baseStyle),
      ),
    );
  }
}

