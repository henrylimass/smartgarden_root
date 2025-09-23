import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'session_manager.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4EC),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: _WaveClipper(),
                  child: Container(
                    height: 220,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/backgroundfolhas.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                ClipPath(
                  clipper: _WaveClipper(),
                  child: Container(
                    height: 220,
                    color: Colors.black.withOpacity(0.30),
                  ),
                ),
                Positioned.fill(
                  top: 30,
                  bottom: 30,
                  child: Center(
                    child: SizedBox(
                      height: 60,
                      child: Image.asset('assets/images/Logov1.1.png'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text(
              'Login',
              style: GoogleFonts.montserratAlternates(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0E520E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Digite suas credenciais para acessar',
              style: GoogleFonts.montserratAlternates(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _workSansField('Email'),
                  const SizedBox(height: 12),
                  _workSansField('Senha', obscureText: true),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.only(top: 6),
                      ),
                      child: Text(
                        'Esqueci minha senha',
                        style: GoogleFonts.workSans(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                       await SessionManager.setLoggedIn(true);
                       Navigator.pushReplacementNamed(context, '/home');
                       },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E520E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: const [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('Ou'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Image.asset('assets/icons/google.png', height: 22),
                      label: Text(
                        'Continuar com o Google',
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0E520E),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF0E520E)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Não tem uma conta? ',
                        style: GoogleFonts.workSans(fontSize: 13),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/signup'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          foregroundColor: const Color(0xFF3461FD), // azul
                        ),
                        child: Text(
                          'Criar conta',
                          style: GoogleFonts.workSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF3461FD), // azul
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.workSans(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                      children: const [
                        TextSpan(
                          text: 'Ao continuar, você concorda com os nossos\n',
                        ),
                        TextSpan(
                          text: 'Termos de Uso',
                          style: TextStyle(
                            color: Color(0xFF3461FD),
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(text: ' e '),
                        TextSpan(
                          text: 'Política de privacidade',
                          style: TextStyle(
                            color: Color(0xFF3461FD),
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


Widget _workSansField(String hint, {bool obscureText = false}) {
  return DefaultTextStyle.merge(
    style: GoogleFonts.workSans(
      fontSize: 14,
      color: Colors.black87,
    ),
    child: TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.workSans(
          fontSize: 14,
          color: Colors.black54,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF0E520E)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF0E520E)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF0E520E), width: 2),
        ),
      ),
    ),
  );
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()..lineTo(0, size.height - 40);
    final p1 = Offset(size.width / 4, size.height);
    final e1 = Offset(size.width / 2, size.height - 40);
    path.quadraticBezierTo(p1.dx, p1.dy, e1.dx, e1.dy);

    final p2 = Offset(size.width * 3 / 4, size.height - 80);
    final e2 = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(p2.dx, p2.dy, e2.dx, e2.dy);

    path
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
