// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import '../utils/theme.dart';
import 'catalog_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CatalogScreen()));
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo asli Teppanku
                ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 140, height: 140, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Text('🍳', style: TextStyle(fontSize: 80)),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('TEPPANKU',
                    style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 4)),
                const SizedBox(height: 8),
                Text('Home Service Teppanyaki',
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14, letterSpacing: 1)),
                const SizedBox(height: 48),
                const CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
