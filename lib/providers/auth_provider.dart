
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/hive_service.dart';
import '../services/session_service.dart';

class AuthProvider with ChangeNotifier {
  final HiveService _hive = HiveService();
  final SessionService _session = SessionService();

  UserModel? currentUser;

  Future<bool> register(String username, String password) async {
    if (username.isEmpty || password.isEmpty) return false;
    final user = UserModel(username: username, password: password);
    final ok = await _hive.register(user);
    return ok;
  }

  Future<bool> login(String username, String password) async {
    final u = _hive.getUser(username);
    if (u == null) return false;
    if (u.password != password) return false;
    currentUser = u;
    await _session.saveLoggedUser(username);
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    currentUser = null;
    await _session.clearSession();
    notifyListeners();
  }

  Future<void> loadFromSession() async {
    final username = await _session.getLoggedUser();
    if (username != null) {
      currentUser = _hive.getUser(username);
      notifyListeners();
    }
  }

  Future<void> updateProfile(String username, {String? nim, String? photoBase64}) async {
    final u = _hive.getUser(username);
    if (u == null) return;
    u.nim = nim ?? u.nim;
    u.photoBase64 = photoBase64 ?? u.photoBase64;
    await _hive.saveUser(u);
    currentUser = u;
    notifyListeners();
  }
}
