import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _userCtl = TextEditingController();
  final _passCtl = TextEditingController();
  bool _loading = false;
  String? _message;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black, 
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                Text(
                  "Register Account",
                  style: TextStyle(
                    color: Colors.deepOrangeAccent,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 26),

                
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.deepOrangeAccent, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      
                      TextField(
                        controller: _userCtl,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Username",
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      
                      TextField(
                        controller: _passCtl,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      
                      if (_message != null)
                        Text(
                          _message!,
                          style: TextStyle(
                            color: _message!.contains("successful")
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            fontSize: 14,
                          ),
                        ),

                      const SizedBox(height: 10),

                     
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading
                              ? null
                              : () async {
                                  setState(() {
                                    _loading = true;
                                    _message = null;
                                  });

                                  final ok = await auth.register(
                                    _userCtl.text.trim(),
                                    _passCtl.text.trim(),
                                  );

                                  setState(() => _loading = false);

                                  if (ok) {
                                    setState(() {
                                      _message =
                                          'Register successful. Redirecting...';
                                    });

                                    await Future.delayed(
                                        const Duration(seconds: 1));
                                    if (!mounted) return;
                                    Navigator.pop(context);
                                  } else {
                                    setState(() {
                                      _message = 'Username already exists';
                                    });
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrangeAccent,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: _loading
                              ? const CircularProgressIndicator(
                                  color: Colors.black,
                                )
                              : const Text(
                                  "Register",
                                  style: TextStyle(
                                      fontSize: 17, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
