import 'package:final_keswamas/login/login_page.dart';
import 'package:final_keswamas/model/keswamas_model.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  RegisterUser registerUser = RegisterUser();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(),
        body: SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Register",
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                    labelText: "Username",
                    prefixIcon: Icon(Icons.person_outline)),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    labelText: "Email", prefixIcon: Icon(Icons.email_outlined)),
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
                height: 10,
              ),
              TextField(
                controller: passwordConfirmController,
                decoration: const InputDecoration(
                    labelText: "Password Confirm",
                    prefixIcon: Icon(Icons.lock_person_outlined)),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 60,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: OutlinedButton(
                  onPressed: () async {
                    if (usernameController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty &&
                        emailController.text.isNotEmpty &&
                        passwordConfirmController.text.isNotEmpty) {
                      try {
                        String? result = await registerUser.register(
                            usernameController.text,
                            passwordController.text,
                            passwordConfirmController.text,
                            emailController.text);
                        if (result == "Berhasil terdaftar") {
                          toastification.show(
                            alignment: Alignment.topCenter,
                            autoCloseDuration: const Duration(seconds: 5),
                            style: ToastificationStyle.flat,
                            type: ToastificationType.success,
                            icon: const Icon(Icons.error_outline),
                            context: context,
                            title: const Text("Daftar Akun Berhasil"),
                            description: Text("$result"),
                          );
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                            return const LoginPage();
                          }));
                        } else {
                          toastification.show(
                            alignment: Alignment.topCenter,
                            autoCloseDuration: const Duration(seconds: 5),
                            style: ToastificationStyle.flat,
                            type: ToastificationType.error,
                            icon: const Icon(Icons.error_outline),
                            context: context,
                            title: const Text("Daftar Akun Gagal"),
                            description: Text("$result"),
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
                          title: const Text("Terjadi Kesalahan"),
                          description: const Text("Daftar Akun Gagal"),
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
                        title: const Text("Daftar Akun Gagal"),
                        description: const Text("Field tidak boleh kosong"),
                      );
                    }
                  },
                  style: const ButtonStyle(),
                  child: Text("Register"),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Sudah punya akun?"),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                      },
                      child: const Text("Login")),
                ],
              )
            ]),
      ),
    ));
  }
}
