import 'package:firebase_auth/firebase_auth.dart';

class Firebaseauthservice {
  final FirebaseAuth _auth;

  Firebaseauthservice(
    FirebaseAuth? auth,
  ) : _auth = auth ??= FirebaseAuth.instance;

  Future<UserCredential> createUser(String email, String password) async{
    try{
      final result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      return result;
    } on FirebaseAuthException catch (e){
      final errorMessage = switch (e.code){
        "email-already-in-use" =>
          "Email sudah terdaftar. Silahkan gunakan email lain.",
        "invalid-email" =>
          "Format email tidak valid.",
        "operation-not-allowed" =>
          "Terjadi kesalahan pada server. Silahkan coba lagi nanti",
        "weak-password" =>
         "Kata sandi lemah. Gunakan minimal 6 karakter",
        _ => "Pendaftaran gagal. Silahkan coba lagi nanti",
      };
      throw Exception(errorMessage);
    } catch(e){
      throw Exception(e);
    }
  }

  Future<UserCredential> signInUser(String email, String password) async{
    try{
      final result = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      return result;
    } on FirebaseException catch (e){
      final errorMessage = switch (e.code){
        "invalid-email" => "Format email tidak valid.",
        "user-disabled" => "Akun ini telah dinonaktifkan.",
        "user-not-found" => "Email tidak terdaftar.",
        "wrong-password" => "Email atau kata sandi salah",
        _ => "Gagal masuk. Silahkan coba lagi",
      };
      throw Exception(errorMessage);
    } catch(e){
      throw Exception(e);
    }
  }

  Future<void> signOut() async{
    try{
      await _auth.signOut();
    } catch (e){
      throw Exception("Gagal keluar. Silahkan coba lagi.");
    }
  }

  Future<User?> userChanges() => _auth.userChanges().first;
}