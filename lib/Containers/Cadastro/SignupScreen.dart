import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importe o Firestore

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Instâncias do Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Instância do Firestore

  // Chave para o nosso formulário, usada para validar os campos
  final _formKey = GlobalKey<FormState>();

  // Controladores para os campos de texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Variável para controlar o estado de "carregando"
  bool _isLoading = false;

  // Função para lidar com o processo de cadastro
  Future<void> _register() async {
    // Primeiro, validamos o formulário
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Se a validação passou, mostramos o indicador de loading
    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Criar o usuário no Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      User? user = userCredential.user;

      // Verifica se o usuário foi criado com sucesso
      if (user != null) {
        // 2. Salvar as informações do usuário no Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': _emailController.text.trim(),
          'createdAt': Timestamp.now(), // Salva a data de criação
          // Adicione outros campos que desejar aqui (nome, telefone, etc.)
        });
        
        print("Usuário cadastrado com sucesso: ${user.uid}");
        print("Dados do usuário salvos no Firestore!");
        
        // Mostra uma mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cadastro realizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Se desejar, navegue para a tela principal após o sucesso
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
      }

    } on FirebaseAuthException catch (e) {
      // Tratamento de erros específicos do Firebase Auth
      String message;
      if (e.code == 'weak-password') {
        message = 'A senha fornecida é muito fraca.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Este e-mail já está em uso.';
      } else if (e.code == 'invalid-email') {
        message = 'O formato do e-mail é inválido.';
      } else {
        message = 'Ocorreu um erro. Tente novamente.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      // Tratamento de outros erros
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ocorreu um erro desconhecido.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Independentemente de sucesso ou falha, paramos o loading
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela de Cadastro'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Crie sua Conta',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Por favor, insira um e-mail válido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Cadastrar', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
