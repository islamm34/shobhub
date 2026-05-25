import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/auth_provider.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool agreeToTerms = false;
  bool isLoading = false;
  String? errorMessage;

  Future<void> _register() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please fill all fields';
      });
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        errorMessage = 'Passwords do not match';
      });
      return;
    }

    if (passwordController.text.length < 6) {
      setState(() {
        errorMessage = 'Password must be at least 6 characters';
      });
      return;
    }

    if (!agreeToTerms) {
      setState(() {
        errorMessage = 'Please agree to terms & conditions';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.createUserWithEmailAndPassword(
        emailController.text,
        passwordController.text,
        nameController.text,
      );

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Registration failed. Please try again.';
        isLoading = false;
      });
    }
  }

  Future<void> _registerWithGoogle() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.signInWithGoogle();

      if (user != null && mounted) {
        // إذا كان المستخدم جديداً، سيتم إنشاء حساب تلقائياً
        // وإذا كان موجوداً سيسجل الدخول مباشرة
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Google sign up failed. Please try again.';
        isLoading = false;
      });
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
                onTap: () => Navigator.pop(context),
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
              'Create Account',
              style: AppTypography.headline1(
                color: isDark
                    ? AppColors.darkOnBackground
                    : AppColors.lightOnBackground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Join us and start shopping',
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
                    Icon(Icons.error_outline, color: AppColors.lightError, size: 20),
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
              label: 'Full Name',
              hint: 'Enter your full name',
              controller: nameController,
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 20),
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
              hint: 'Create a password',
              obscureText: true,
              controller: passwordController,
              prefixIcon: Icons.lock_outlined,
              suffixIcon: Icons.visibility_off_outlined,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Confirm Password',
              hint: 'Confirm your password',
              obscureText: true,
              controller: confirmPasswordController,
              prefixIcon: Icons.lock_outlined,
              suffixIcon: Icons.visibility_off_outlined,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => setState(() => agreeToTerms = !agreeToTerms),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: agreeToTerms
                            ? (isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary)
                            : (isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(6),
                      color: agreeToTerms
                          ? (isDark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary)
                          : Colors.transparent,
                    ),
                    child: agreeToTerms
                        ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'I agree to the ',
                        style: AppTypography.bodyMedium(
                          color: isDark
                              ? AppColors.darkOnBackground
                              : AppColors.lightOnBackground,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: AppTypography.bodyMedium(
                              color: isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            PremiumButton(
              label: isLoading ? 'Creating Account...' : 'Create Account',
              onPressed: isLoading ?  _register: _register,
            ),
            const SizedBox(height: 20),
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: AppTypography.bodyMedium(
                    color:
                    isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                  ),
                  children: [
                    TextSpan(
                      text: 'Sign In',
                      style: AppTypography.bodyMedium(
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap =
                            () => Navigator.of(context).pushNamed('/login'),
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
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Or sign up with',
                    style: AppTypography.bodySmall(
                      color: isDark ? AppColors.neutral_500 : AppColors.neutral_500,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _registerWithGoogle,
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
                    child: const Center(
                      child: Icon(Icons.apple, size: 28),
                    ),
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}