import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // انتظار قليلاً لإظهار شاشة Splash
    await Future.delayed(const Duration(seconds: 2));

    // ✅ التحقق من حالة تسجيل الدخول من Firebase
    final authState = ref.read(authStateProvider);

    if (mounted) {
      authState.when(
        data: (user) {
          if (user != null) {
            // المستخدم مسجل دخوله → اذهب للرئيسية
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            // المستخدم غير مسجل → اذهب للترحيب
            Navigator.pushReplacementNamed(context, '/onboarding');
          }
        },
        loading: () {
          // لا تفعل شيء، انتظر
        },
        error: (error, _) {
          // في حالة الخطأ، اذهب للترحيب
          Navigator.pushReplacementNamed(context, '/onboarding');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 100),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text('Loading...'),
          ],
        ),
      ),
    );
  }
}