import 'package:final_keswamas/login/login_page.dart';
import 'package:final_keswamas/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Keswamas',
        theme: ThemeData(
          textTheme: GoogleFonts.comfortaaTextTheme(),
        ),
        home: const SplashScreen());
  }
}
