
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _logged = 'loggedInUser';
  static const _profile = 'profilePhotoBase64';
  static const _nim = 'userNim';

  Future<void> saveLoggedUser(String username) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_logged, username);
  }

  Future<String?> getLoggedUser() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_logged);
  }

  Future<void> clearSession() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_logged);
  }

  Future<void> saveProfilePhoto(String b64) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_profile, b64);
  }

  Future<String?> getProfilePhoto() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_profile);
  }

  Future<void> saveNim(String nim) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_nim, nim);
  }

  Future<String?> getNim() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_nim);
  }
}
