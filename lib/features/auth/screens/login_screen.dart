import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/secure_storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/auth_provider.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberMe = false;
  bool isLoading = false;
  String? errorMessage;

  Future<void> _login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please fill all fields';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);

      await authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );

      if (rememberMe) {
        final storage = await SecureStorageService.getInstance();
        await storage.setBool('isLoggedIn', true);
      }

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Invalid email or password';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);

      final user = await authService.signInWithGoogle();

      if (user != null) {
        final storage = await SecureStorageService.getInstance();
        await storage.setBool('isLoggedIn', true);

        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Google sign in failed. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceContainer
                        : AppColors.lightSurfaceContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: isDark
                        ? AppColors.darkOnBackground
                        : AppColors.lightOnBackground,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back',
              style: AppTypography.headline1(
                color: isDark
                    ? AppColors.darkOnBackground
                    : AppColors.lightOnBackground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to continue shopping',
              style: AppTypography.bodyLarge(
                color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
              ),
            ),
            const SizedBox(height: 32),
            if (errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.lightError.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.lightError),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.lightError,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        errorMessage!,
                        style: AppTypography.bodySmall(
                          color: AppColors.lightError,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            CustomTextField(
              label: 'Email Address',
              hint: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              prefixIcon: Icons.email_outlined,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Password',
              hint: 'Enter your password',
              obscureText: true,
              controller: passwordController,
              prefixIcon: Icons.lock_outlined,
              suffixIcon: Icons.visibility_off_outlined,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      rememberMe = !rememberMe;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: rememberMe
                                ? (isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary)
                                : (isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(6),
                          color: rememberMe
                              ? (isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary)
                              : Colors.transparent,
                        ),
                        child: rememberMe
                            ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        )
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Remember me',
                        style: AppTypography.bodyMedium(
                          color: isDark
                              ? AppColors.darkOnBackground
                              : AppColors.lightOnBackground,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/forgot-password');
                  },
                  child: Text(
                    'Forgot Password?',
                    style: AppTypography.bodyMedium(
                      color: isDark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // ✅ زر Sign In - تم إصلاح المشكلة
            PremiumButton(
              label: isLoading ? 'Loading...' : 'Sign In',
              onPressed: () {
                if (!isLoading) {
                  _login();
                }
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: AppTypography.bodyMedium(
                    color: isDark
                        ? AppColors.neutral_400
                        : AppColors.neutral_600,
                  ),
                  children: [
                    TextSpan(
                      text: 'Sign Up',
                      style: AppTypography.bodyMedium(
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).pushNamed('/register');
                        },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Or continue with',
                    style: AppTypography.bodySmall(
                      color: AppColors.neutral_500,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (!isLoading) {
                        _loginWithGoogle();
                      }
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceContainer
                            : AppColors.lightSurfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.g_mobiledata, size: 28),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceContainer
                          : AppColors.lightSurfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                    ),
                    child: const Center(child: Icon(Icons.apple, size: 28)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}