
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'providers/auth_provider.dart';
import 'providers/anime_provider.dart';
import 'providers/favorite_provider.dart';
import 'services/session_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('users');
  await Hive.openBox('favorites');

  runApp(const AnimeApp());
}

class AnimeApp extends StatefulWidget {
  const AnimeApp({super.key});
  @override
  State<AnimeApp> createState() => _AnimeAppState();
}

class _AnimeAppState extends State<AnimeApp> {
  String? _loggedUser;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final s = SessionService();
    final u = await s.getLoggedUser();
    setState(() {
      _loggedUser = u;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AnimeProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Anime App',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0B0B0D),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFFF6B00),
            secondary: Color(0xFFFF8C32),
          ),
          textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Poppins'),
        ),
        home: _loggedUser == null ? const LoginPage() : const HomePage(),
      ),
    );
  }
}
