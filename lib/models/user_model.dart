
class UserModel {
  final String username;
  final String password;
  String? nim;
  String? photoBase64;

  UserModel({required this.username, required this.password, this.nim, this.photoBase64});

  Map<String, dynamic> toMap() => {
        'username': username,
        'password': password,
        'nim': nim,
        'photoBase64': photoBase64,
      };

  factory UserModel.fromMap(Map<dynamic, dynamic> m) {
    return UserModel(
      username: m['username'] ?? '',
      password: m['password'] ?? '',
      nim: m['nim'],
      photoBase64: m['photoBase64'],
    );
  }
}
