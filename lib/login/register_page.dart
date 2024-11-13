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
        padding: EdgeInsets.all(20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Register",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    labelText: "Username",
                    prefixIcon: Icon(Icons.person_outline)),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: "Email", prefixIcon: Icon(Icons.email_outlined)),
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
                height: 10,
              ),
              TextField(
                controller: passwordConfirmController,
                decoration: InputDecoration(
                    labelText: "Password Confirm",
                    prefixIcon: Icon(Icons.lock_person_outlined)),
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
                        passwordController.text.isNotEmpty &&
                        emailController.text.isNotEmpty &&
                        passwordConfirmController.text.isNotEmpty) {
                      try {
                        String? result = await registerUser.register(
                            usernameController.text,
                            passwordController.text,
                            passwordConfirmController.text,
                            emailController.text);
                        toastification.show(
                          alignment: Alignment.topCenter,
                          autoCloseDuration: const Duration(seconds: 5),
                          style: ToastificationStyle.flat,
                          type: ToastificationType.success,
                          context: context,
                          title: Text("$result"),
                          description: Text("Field tidak boleh kosong"),
                        );
                      } catch (e) {
                        toastification.show(
                          alignment: Alignment.topCenter,
                          autoCloseDuration: const Duration(seconds: 5),
                          style: ToastificationStyle.flat,
                          type: ToastificationType.error,
                          icon: Icon(Icons.error_outline),
                          context: context,
                          title: Text("Terjadi Kesalahan"),
                          description: Text("Daftar Akun Gagal"),
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
                        title: Text("Daftar Akun Gagal"),
                        description: Text("Field tidak boleh kosong"),
                      );
                    }
                  },
                  child: Text("Register"),
                  style: ButtonStyle(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sudah punya akun?"),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                      },
                      child: Text("Login")),
                ],
              )
            ]),
      ),
    ));
  }
}
