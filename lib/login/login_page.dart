import 'package:final_keswamas/login/register_page.dart';
import 'package:final_keswamas/pages/dashboard.dart';
import 'package:final_keswamas/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // physics: const NeverScrollableScrollPhysics(),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(0.1),
                ),
              ),
            ),
            // Main content
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo or app name could go here
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Enhanced text fields
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: usernameController,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              labelText: "Username",
                              labelStyle: const TextStyle(fontSize: 14),
                              prefixIcon:
                                  const Icon(Icons.email_outlined, size: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: const TextStyle(fontSize: 14),
                              prefixIcon:
                                  const Icon(Icons.lock_outline, size: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        // Enhanced button
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (usernameController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                try {
                                  String? result = await authService.login(
                                      usernameController.text,
                                      passwordController.text);

                                  if (result == null) {
                                    toastification.show(
                                      context: context,
                                      title: const Text("Login Berhasil"),
                                      description: const Text(
                                          "Selamat Datang Di Keswamas App"),
                                      type: ToastificationType.success,
                                      style: ToastificationStyle.flat,
                                      alignment: Alignment.topCenter,
                                      autoCloseDuration:
                                          const Duration(seconds: 5),
                                      icon: const Icon(Icons.check),
                                    );
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => Dashboard(
                                          username: usernameController.text,
                                          password: passwordController.text,
                                        ),
                                      ),
                                    );
                                  } else {
                                    toastification.show(
                                      context: context,
                                      title: const Text("Login Gagal"),
                                      description: Text(result),
                                      type: ToastificationType.error,
                                      style: ToastificationStyle.flat,
                                      alignment: Alignment.topCenter,
                                      autoCloseDuration:
                                          const Duration(seconds: 5),
                                      icon: const Icon(Icons.error_outline),
                                    );
                                  }
                                } catch (e) {
                                  toastification.show(
                                    context: context,
                                    title: const Text("Login Gagal"),
                                    description:
                                        const Text("Terjadi Kesalahan"),
                                    type: ToastificationType.error,
                                    style: ToastificationStyle.flat,
                                    alignment: Alignment.topCenter,
                                    autoCloseDuration:
                                        const Duration(seconds: 5),
                                    icon: const Icon(Icons.error_outline),
                                  );
                                }
                              } else {
                                toastification.show(
                                  context: context,
                                  title: const Text("Login Gagal"),
                                  description: const Text(
                                      "Username dan Password tidak boleh kosong"),
                                  type: ToastificationType.error,
                                  style: ToastificationStyle.flat,
                                  alignment: Alignment.topCenter,
                                  autoCloseDuration: const Duration(seconds: 5),
                                  icon: const Icon(Icons.error_outline),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.withOpacity(0.8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Belum punya akun?",
                              style: TextStyle(color: Colors.black54),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
