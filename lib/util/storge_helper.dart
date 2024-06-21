import 'package:shared_preferences/shared_preferences.dart';

class  StorageHalper {
  final String loginStatusKey = 'loginStates';

  Future saveLoginStatus() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool(loginStatusKey, true);
  }

  Future<bool> getLoginStatus() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool? loginStatus = sp.getBool(loginStatusKey);
    return loginStatus ?? false;
  }

  Future removeLoginStatus() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.remove(loginStatusKey);
  }
}