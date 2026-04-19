import 'package:safe_space/model/profil.dart';
import 'package:safe_space/services/firebase_auth_service.dart';
import 'package:safe_space/static/firebase_auth_status.dart';
import 'package:flutter/widgets.dart';

class FirebaseAuthProvider extends ChangeNotifier{
  final Firebaseauthservice _service;

  FirebaseAuthProvider(this._service);

  String? _message;
  Profil? _profil;
  FirebaseAuthStatus _authStatus = FirebaseAuthStatus.unauthenticated;

  Profil? get profil => _profil;
  String? get message => _message;
  FirebaseAuthStatus get authStatus => _authStatus;

  Future createAccount(String email, String password) async{
    try{
      _authStatus = FirebaseAuthStatus.creatingAccount;
      notifyListeners();

      await _service.createUser(email, password);

      _authStatus = FirebaseAuthStatus.accountCreated;
      _message = "Akun berhasil dibuat.";
      notifyListeners();
    } catch (e){
      _message = e.toString().replaceFirst('Exception: ', '');
      _authStatus = FirebaseAuthStatus.error;
      notifyListeners();
    }
  }

  Future signInUser(String email, String password) async{
    try{
      _authStatus = FirebaseAuthStatus.authenticating;
      notifyListeners();

      final result = await _service.signInUser(email, password);

      _profil = Profil(
        name: result.user?.displayName,
        email: result.user?.email,
        photoUrl: result.user?.photoURL,
      );

      _authStatus = FirebaseAuthStatus.authenticated;
      _message = "Berhasil masuk.";
      notifyListeners();
    } catch (e){
      _message = e.toString().replaceFirst('Exception: ', '');
      _authStatus = FirebaseAuthStatus.error;
      notifyListeners();
    }
  }

  Future signOutUser() async{
    try{
      _authStatus = FirebaseAuthStatus.signingOut;
      notifyListeners();

      await _service.signOut();

      _authStatus = FirebaseAuthStatus.unauthenticated;
      _message = "Keluar dari ruang obrolan.";
      notifyListeners();
    } catch (e){
      _message = e.toString().replaceFirst('Exception: ', '');
      _authStatus = FirebaseAuthStatus.error;
      notifyListeners();
    }
  }

  Future updateProfil() async{
    final user = await _service.userChanges();
    _profil = Profil(
      name: user?.displayName,
      email: user?.email,
      photoUrl: user?.photoURL,
    );
    notifyListeners();
  }
}