import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Inicia o fluxo de login com o Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // O usuário cancelou o login
        return null;
      }

      // Obtém os detalhes de autenticação da solicitação
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Cria uma credencial para o Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Faz o login no Firebase com a credencial
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}