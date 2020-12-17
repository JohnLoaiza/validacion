import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {

  Future<bool> isLoggedIn() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance.getBool('logged_in');
  }

  Future<bool> isLibreIn() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance.getBool('estadoservicio');
  }


  Future<bool> isRegisterIN() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance.getBool('registrado');

  }
  Future<bool> isLoggedInValid() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance.getBool('validOK');
  }

  Future<String> myUserID() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance.getString('userID');
  }
  Future<String> myFhotoPath() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance.getString('avatarPath');
  }
  Future<String> myPassLogin() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance.getString('password');
  }


  Future<int> TimerValidaPhone() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance.getInt('timevalidate');
  }

  Future<String> MiTelefono() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance.getString('MiTelefono');
  }

  Future<String> MiTokenFirebase() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance.getString('MiTokenFire');
  }

  void setLoggedIn(bool state) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.setBool('logged_in', state);
  }
  void setRegisterIn(bool state) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.setBool('registrado', state);
  }
  void setLoggedInValid(bool state) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.setBool('validOK', state);
  }
  void setLibreOrOcupado(bool state) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.setBool('estadoservicio', state);
  }
  void setUserID(String state) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.setString('userID', state);
  }
  void setAvatarPath(String state) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.setString('avatarPath', state);
  }
  void setPassW(String state) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.setString('password', state);
  }

  void setTimeTovalid(int time) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.setInt('timevalidate', time);
  }

  void setMiTelefono(String mite) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.setString('MiTelefono', mite);
  }

  void setMiTokenFirebase(String mite) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.setString('MiTokenFire', mite);
  }

}
