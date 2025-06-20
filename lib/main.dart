import 'package:flutter/material.dart';
import 'views/home_view.dart';

void main() {
  runApp(const LeafGuardApp());
}

class LeafGuardApp extends StatelessWidget {
  const LeafGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LeafGuard',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF292D3E),
        primaryColor: Color(0xFF82AAFF),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF292D3E),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF82AAFF),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: const HomeView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
