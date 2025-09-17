import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pill_button.dart';

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
                      width: 86,
                      height: 86,
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
                            color: const Color.fromRGBO(214, 215, 155, 1),
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
                              color: const Color.fromRGBO(253, 185, 79, 1),
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
