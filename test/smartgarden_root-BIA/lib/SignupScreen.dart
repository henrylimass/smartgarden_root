import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4EC), 
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    height: 220,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/backgroundfolhas.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    height: 220,
                    color: Colors.black.withOpacity(0.3), 
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  top: 30,
                  child: Center(
                    child: SizedBox(
                      height: 60,
                      child: Image.asset("assets/images/Logov1.1.png"),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Text(
              "Cadastro",
              style: GoogleFonts.montserratAlternates(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0E520E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Crie sua conta para continuar",
              style: GoogleFonts.montserratAlternates(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildTextField("Nome"),
                  const SizedBox(height: 12),
                  _buildTextField("Email"),
                  const SizedBox(height: 12),
                  _buildTextField("Senha", obscureText: true),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Checkbox(
                        value: false,
                        onChanged: (_) {},
                        activeColor: const Color(0xFF0E520E),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.montserratAlternates(
                              color: Colors.black87,
                              fontSize: 12,
                            ),
                            children: [
                              const TextSpan(text: "Eu concordo com os "),
                              TextSpan(
                                text: "Termos de Serviços",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              const TextSpan(text: " e "),
                              TextSpan(
                                text: "Política de privacidade",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E520E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Cadastrar",
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Já possui uma conta?",
                        style: GoogleFonts.montserratAlternates(fontSize: 14),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/login");
                        },
                        child: Text(
                          "Login",
                          style: GoogleFonts.montserratAlternates(
                            color: Color.fromARGB(255, 52, 97, 253),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: const [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("Ou"),
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
                      icon: Image.asset(
                        "assets/icons/google.png",
                        height: 24,
                      ),
                      label: Text(
                        "Continuar com o Google",
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

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


Widget _buildTextField(String hint, {bool obscureText = false}) {
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
          color: Colors.grey,
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

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 40);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 80);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
