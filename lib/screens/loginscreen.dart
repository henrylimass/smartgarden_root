// lib/login_screen.dart
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos um Scaffold como a base da nossa tela
    return Scaffold(
      // A cor de fundo principal da tela
      backgroundColor: const Color(0xFFF5F5F0), // Um tom de branco "off-white"
      // SingleChildScrollView permite que a tela seja rolável
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment:
                  Alignment.center, // Alinha os filhos do Stack no centro
              clipBehavior:
                  Clip.none, // Permite que o logo saia para fora da área
              children: [
                // Imagem de fundo
                Image.asset(
                  'assets/images/backgroundfolhas.jpg', // SUBSTITUA PELO NOME DA SUA IMAGEM
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                // Posicionamos o logo para que ele fique "vazando" para baixo
                Positioned(
                  bottom: -50, // Metade da altura do logo (100 / 2 = 50)
                  child: CircleAvatar(
                    radius: 50, // Raio do círculo
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(
                      'assets/images/Logov1.1.png',
                    ), // SUBSTITUA PELO NOME DO SEU LOGO
                  ),
                ),
              ],
            ),
            // --- FIM DO CABEÇALHO ---

            // Espaço extra para compensar o logo que está "fora" do Stack
            const SizedBox(height: 60),
            // Parte 1: Cabeçalho com imagem (vamos construir a seguir)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // Título "Login"
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32), // Verde escuro
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Subtítulo
                  const Text(
                    'Digite suas credenciais para acessar',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  // Campo de Email
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Campo de Senha
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    obscureText: true, // Esconde o texto da senha
                  ),

                  // "Esqueci minha senha"
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Lógica para esqueci a senha
                      },
                      child: const Text(
                        'Esqueci minha senha',
                        style: TextStyle(color: Color(0xFF2E7D32)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Lógica de login
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF2E7D32,
                        ), // Cor de fundo verde
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Divisor "Ou"
                  Row(
                    children: [
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.grey[300]),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Ou'),
                      ),
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.grey[300]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Botão "Continuar com o Google"
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Lógica de login com Google
                      },
                      icon: Image.asset(
                        'assets/icons/google.png',
                        height: 24,
                      ), // CRIE ESSE ASSET
                      label: const Text(
                        'Continuar com o Google',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey[400]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Link para Criar Conta
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                      children: [
                        const TextSpan(text: 'Não tem uma conta? '),
                        TextSpan(
                          text: 'Criar conta',
                          style: const TextStyle(
                            color: Color(0xFF2E7D32),
                            fontWeight: FontWeight.bold,
                          ),
                          // recognizer: TapGestureRecognizer()..onTap = () {
                          //   // TODO: Navegar para a tela de criação de conta
                          // },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Links de Termos e Privacidade
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      children: [
                        const TextSpan(
                          text: 'Ao continuar, você concorda com os nossos\n',
                        ),
                        TextSpan(
                          text: 'Termos de Uso',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                          // recognizer: TapGestureRecognizer()..onTap = () {
                          //   // TODO: Abrir link dos Termos de Uso
                          // },
                        ),
                        const TextSpan(text: ' e '),
                        TextSpan(
                          text: 'Política de Privacidade',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                          // recognizer: TapGestureRecognizer()..onTap = () {
                          //   // TODO: Abrir link da Política de Privacidade
                          // },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Botões e links virão aqui...
                ],
              ),
            ),

            // Parte 2: Formulário de Login (vamos construir a seguir)
          ],
        ),
      ),
    );
  }
}
