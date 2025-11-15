import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/session_service.dart';
import '../models/user_model.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nimCtl = TextEditingController();
  final _session = SessionService();

  String? loggedUser;
  String? photoBase64;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.loadFromSession();

    if (!mounted) return;

    final prefsUser = await _session.getLoggedUser();
    final nim = await _session.getNim();
    final photo = await _session.getProfilePhoto();

    if (!mounted) return;

    setState(() {
      loggedUser = prefsUser;
      _nimCtl.text = nim ?? '';
      photoBase64 = photo;
      user = auth.currentUser;
    });
  }

  Future<void> _pick(bool camera) async {
    final picker = ImagePicker();
    final x = await picker.pickImage(
      source: camera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 900,
      maxHeight: 900,
    );

    if (x == null) return;

    final bytes = await x.readAsBytes();
    final b64 = base64Encode(bytes);

    await _session.saveProfilePhoto(b64);
    if (!mounted) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.currentUser != null) {
      await auth.updateProfile(auth.currentUser!.username, photoBase64: b64);
    }

    if (!mounted) return;
    setState(() => photoBase64 = b64);
  }

  void _showPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.deepOrangeAccent),
                title: const Text('Take Photo', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _pick(true);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo, color: Colors.deepOrangeAccent),
                title: const Text('Choose from Gallery', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _pick(false);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final username = auth.currentUser?.username ?? loggedUser ?? 'Guest';

    final nimDisplay = (user?.nim != null && user!.nim!.isNotEmpty)
        ? user!.nim!
        : (_nimCtl.text.isNotEmpty ? _nimCtl.text : 'No NIM');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),

      
      body: RefreshIndicator(
        color: Colors.deepOrangeAccent,
        backgroundColor: Colors.black,
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _showPicker,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: photoBase64 != null
                            ? MemoryImage(base64Decode(photoBase64!))
                            : const AssetImage('assets/images/profile_placeholder.png')
                                as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      nimDisplay,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              
              TextField(
                controller: _nimCtl,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'NIM',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.06),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text("Simpan NIM"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    await _session.saveNim(_nimCtl.text.trim());

                    if (!mounted) return;

                    final auth =
                        Provider.of<AuthProvider>(context, listen: false);

                    if (auth.currentUser != null) {
                      await auth.updateProfile(
                        auth.currentUser!.username,
                        nim: _nimCtl.text.trim(),
                      );
                    }

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tersimpan')),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    final auth =
                        Provider.of<AuthProvider>(context, listen: false);

                    await auth.logout();

                    if (!mounted) return;

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
