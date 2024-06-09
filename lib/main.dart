import 'package:flutter/material.dart';
import 'package:squadify/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'squadify',
      theme: ThemeData(
       
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}




