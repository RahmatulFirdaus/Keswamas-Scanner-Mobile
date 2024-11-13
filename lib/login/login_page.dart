import 'package:final_keswamas/login/register_page.dart';
import 'package:final_keswamas/pages/dashboard.dart';
import 'package:final_keswamas/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

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
        body: SafeArea(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Login",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    labelText: "Username",
                    prefixIcon: Icon(Icons.email_outlined)),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock_outline)),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 60,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: OutlinedButton(
                  onPressed: () async {
                    if (usernameController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      try {
                        String? result = await authService.login(
                            usernameController.text, passwordController.text);

                        if (result == null) {
                          toastification.show(
                            alignment: Alignment.topCenter,
                            autoCloseDuration: const Duration(seconds: 5),
                            style: ToastificationStyle.flat,
                            type: ToastificationType.success,
                            icon: Icon(Icons.error_outline),
                            context: context,
                            title: Text("Login Berhasil"),
                            description: Text("Selamat Datang Di Keswamas App"),
                          );
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const Dashboard()));
                        } else {
                          toastification.show(
                            alignment: Alignment.topCenter,
                            autoCloseDuration: const Duration(seconds: 5),
                            style: ToastificationStyle.flat,
                            type: ToastificationType.error,
                            icon: Icon(Icons.error_outline),
                            context: context,
                            title: Text("Login Gagal"),
                            description: Text(result),
                          );
                        }
                      } catch (e) {
                        toastification.show(
                          alignment: Alignment.topCenter,
                          autoCloseDuration: const Duration(seconds: 5),
                          style: ToastificationStyle.flat,
                          type: ToastificationType.error,
                          icon: Icon(Icons.error_outline),
                          context: context,
                          title: Text("Login Gagal"),
                          description: Text("Terjadi Kesalahan"),
                        );
                      }
                    } else {
                      toastification.show(
                        alignment: Alignment.topCenter,
                        autoCloseDuration: const Duration(seconds: 5),
                        style: ToastificationStyle.flat,
                        type: ToastificationType.error,
                        icon: Icon(Icons.error_outline),
                        context: context,
                        title: Text("Login Gagal"),
                        description:
                            Text("Username dan Password tidak boleh kosong"),
                      );
                    }
                  },
                  child: Text("Login"),
                  style: ButtonStyle(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Belum punya akun? "),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const RegisterPage()));
                      },
                      child: Text("Register")),
                ],
              )
            ]),
      ),
    ));
  }
}
