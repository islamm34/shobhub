import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/base_widgets.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(6, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
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
              'Verify Your Phone',
              style: AppTypography.headline1(
                color: isDark
                    ? AppColors.darkOnBackground
                    : AppColors.lightOnBackground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We\'ve sent a 6-digit code to +1 (555) 123-****',
              style: AppTypography.bodyLarge(
                color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
              ),
            ),
            const SizedBox(height: 40),
            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 50,
                  height: 60,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor:
                          isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                          width: 2,
                        ),
                      ),
                      counterText: '',
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: AppTypography.headline3(
                      color: isDark
                          ? AppColors.darkOnBackground
                          : AppColors.lightOnBackground,
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        if (index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else {
                          _focusNodes[index].unfocus();
                        }
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            // Resend Timer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Didn\'t receive code? ',
                  style: AppTypography.bodyMedium(
                    color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Resend (30s)',
                    style: AppTypography.labelMedium(
                      color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            PremiumButton(
              label: 'Verify OTP',
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/home');
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'Change Phone Number',
                  style: AppTypography.labelMedium(
                    color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

