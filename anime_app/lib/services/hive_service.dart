
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

class HiveService {
  static Box get usersBox => Hive.box('users');
  static Box get favBox => Hive.box('favorites');

  Future<bool> register(UserModel user) async {
    final box = usersBox;
    if (box.containsKey(user.username)) return false;
    await box.put(user.username, user.toMap());
    return true;
  }

  UserModel? getUser(String username) {
    final box = usersBox;
    final m = box.get(username);
    if (m == null) return null;
    return UserModel.fromMap(Map<dynamic, dynamic>.from(m));
  }

  Future<void> saveUser(UserModel user) async {
    final box = usersBox;
    await box.put(user.username, user.toMap());
  }

  List<int> getFavorites() {
    final box = favBox;
    final list = box.get('fav_list', defaultValue: <int>[]);
    return List<int>.from(list);
  }

  Future<void> saveFavorites(List<int> ids) async {
    final box = favBox;
    await box.put('fav_list', ids);
  }
}
