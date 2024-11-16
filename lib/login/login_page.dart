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
        body: Container(
      child: SingleChildScrollView(
        child: SafeArea(
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
                      const Text(
                        "Login",
                        style: TextStyle(fontSize: 30),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                            labelText: "Username",
                            prefixIcon: Icon(Icons.email_outlined)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                            labelText: "Password",
                            prefixIcon: Icon(Icons.lock_outline)),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: OutlinedButton(
                          onPressed: () async {
                            if (usernameController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty) {
                              try {
                                String? result = await authService.login(
                                    usernameController.text,
                                    passwordController.text);

                                if (result == null) {
                                  toastification.show(
                                    alignment: Alignment.topCenter,
                                    autoCloseDuration:
                                        const Duration(seconds: 5),
                                    style: ToastificationStyle.flat,
                                    type: ToastificationType.success,
                                    icon: const Icon(Icons.check),
                                    context: context,
                                    title: const Text("Login Berhasil"),
                                    description: const Text(
                                        "Selamat Datang Di Keswamas App"),
                                  );
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => Dashboard(
                                              username: usernameController.text,
                                              password:
                                                  passwordController.text)));
                                } else {
                                  toastification.show(
                                    alignment: Alignment.topCenter,
                                    autoCloseDuration:
                                        const Duration(seconds: 5),
                                    style: ToastificationStyle.flat,
                                    type: ToastificationType.error,
                                    icon: const Icon(Icons.error_outline),
                                    context: context,
                                    title: const Text("Login Gagal"),
                                    description: Text(result),
                                  );
                                }
                              } catch (e) {
                                toastification.show(
                                  alignment: Alignment.topCenter,
                                  autoCloseDuration: const Duration(seconds: 5),
                                  style: ToastificationStyle.flat,
                                  type: ToastificationType.error,
                                  icon: const Icon(Icons.error_outline),
                                  context: context,
                                  title: const Text("Login Gagal"),
                                  description: const Text("Terjadi Kesalahan"),
                                );
                              }
                            } else {
                              toastification.show(
                                alignment: Alignment.topCenter,
                                autoCloseDuration: const Duration(seconds: 5),
                                style: ToastificationStyle.flat,
                                type: ToastificationType.error,
                                icon: const Icon(Icons.error_outline),
                                context: context,
                                title: const Text("Login Gagal"),
                                description: const Text(
                                    "Username dan Password tidak boleh kosong"),
                              );
                            }
                          },
                          child: Text("Login"),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Belum punya akun? "),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterPage()));
                              },
                              child: const Text("Register")),
                        ],
                      )
                    ],
                  ),
                ),
              ]),
        ),
      ),
    ));
  }
}
