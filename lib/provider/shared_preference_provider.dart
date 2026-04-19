import 'package:safe_space/services/shared_preferences_service.dart';
import 'package:flutter/widgets.dart';

class SharedPreferenceProvider extends ChangeNotifier{
  final SharedPreferencesService _service;

  SharedPreferenceProvider(this._service);

  bool _isLogin = false;
  bool get isLogin => _service.isLogin ?? false;

  Future login() async{
    await _service.login();
    _isLogin = true;
    notifyListeners();
  }

  Future logout() async{
    await _service.logout();
    _isLogin = false;
    notifyListeners();
  }
}