import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_glassmorphism.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double borderRadius;
  final double opacity;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final List<BoxShadow>? customShadow;

  const GlassContainer({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.borderRadius = 16,
    this.opacity = 0.1,
    this.onTap,
    this.backgroundColor,
    this.customShadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ??
        (isDark ? AppColors.darkSurface : AppColors.lightSurface);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: bgColor.withOpacity(opacity),
          border: Border.all(
            color: isDark
                ? AppColors.darkBorder.withOpacity(0.5)
                : AppColors.lightBorder.withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: customShadow ?? AppShadows.elevationMd,
        ),
        child: child,
      ),
    );
  }
}

class PremiumButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final double? width;
  final double? height;
  final IconData? icon;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;

  const PremiumButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.width,
    this.height = 48,
    this.icon,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

enum ButtonVariant { primary, secondary, outline, ghost, danger }

class _PremiumButtonState extends State<PremiumButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  Color _getBackgroundColor(bool isDark) {
    if (widget.backgroundColor != null) return widget.backgroundColor!;

    switch (widget.variant) {
      case ButtonVariant.primary:
      case ButtonVariant.secondary:
        return Colors.transparent;
      case ButtonVariant.outline:
      case ButtonVariant.ghost:
        return Colors.transparent;
      case ButtonVariant.danger:
        return AppColors.lightError;
    }
  }

  Color _getTextColor(bool isDark) {
    if (widget.textColor != null) return widget.textColor!;

    switch (widget.variant) {
      case ButtonVariant.primary:
      case ButtonVariant.secondary:
      case ButtonVariant.danger:
        return Colors.white;
      case ButtonVariant.outline:
        return isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
      case ButtonVariant.ghost:
        return isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground;
    }
  }

  Color _getBorderColor(bool isDark) {
    switch (widget.variant) {
      case ButtonVariant.outline:
        return isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = _getBackgroundColor(isDark);
    final textColor = _getTextColor(isDark);
    final borderColor = _getBorderColor(isDark);

    Widget buttonContent = ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: widget.variant == ButtonVariant.primary ||
                widget.variant == ButtonVariant.secondary
                ? GlassmorphismEffects.luxuryGradient(isDark: isDark)
                : null,
            color: widget.variant != ButtonVariant.primary &&
                widget.variant != ButtonVariant.secondary
                ? bgColor
                : null,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderColor,
              width: 1.5,
            ),
            boxShadow: widget.variant == ButtonVariant.primary ||
                widget.variant == ButtonVariant.secondary
                ? [
              BoxShadow(
                color: isDark
                    ? AppColors.darkPrimary.withOpacity(0.3)
                    : AppColors.lightPrimary.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
                spreadRadius: -1,
              ),
            ]
                : null,
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(textColor),
                strokeWidth: 2,
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: textColor, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.label,
                  style: AppTypography.button(color: textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return buttonContent;
  }
}

class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final List<BoxShadow>? shadow;
  final Border? border;

  const PremiumCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.borderRadius = 16,
    this.onTap,
    this.backgroundColor,
    this.shadow,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ??
        (isDark ? AppColors.darkSurface : AppColors.lightSurface);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        margin: margin,
        decoration: border != null
            ? BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: shadow ?? AppShadows.elevationMd,
          border: border,
        )
            : BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: shadow ?? AppShadows.elevationMd,
          border: Border.all(
            color: isDark
                ? AppColors.darkBorder.withOpacity(0.5)
                : AppColors.lightBorder.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: child,
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final bool obscureText;
  final int maxLines;
  final int minLines;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? prefixIconSvg;
  final String? suffixIconSvg;
  final VoidCallback? onSuffixIconPressed;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    Key? key,
    required this.label,
    this.hint = '',
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconSvg,
    this.suffixIconSvg,
    this.onSuffixIconPressed,
    this.controller,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTypography.labelLarge(
            color: isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          focusNode: _focusNode,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hint,
            filled: true,
            fillColor: fillColor,
            prefixIcon: widget.prefixIconSvg != null
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      widget.prefixIconSvg!,
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                        BlendMode.srcIn,
                      ),
                    ),
                  )
                : (widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        size: 20,
                        color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                      )
                    : null),
            suffixIcon: widget.suffixIconSvg != null
                ? GestureDetector(
                    onTap: widget.onSuffixIconPressed ??
                        () {
                          if (widget.obscureText) {
                            setState(() => _obscureText = !_obscureText);
                          }
                        },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        widget.suffixIconSvg!,
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  )
                : (widget.suffixIcon != null
                    ? GestureDetector(
                        onTap: widget.onSuffixIconPressed ??
                            () {
                              if (widget.obscureText) {
                                setState(() => _obscureText = !_obscureText);
                              }
                            },
                        child: Icon(
                          widget.suffixIcon,
                          size: 20,
                          color: isDark ? AppColors.neutral_400 : AppColors.neutral_600,
                        ),
                      )
                    : null),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _isFocused
                    ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                    : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                width: _isFocused ? 2 : 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                width: 2,
              ),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}

class PremiumChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? selectedColor;

  const PremiumChip({
    Key? key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
    this.selectedColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isSelected
        ? (selectedColor ?? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary))
        : (isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer);
    final textColor = isSelected
        ? Colors.white
        : (isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? GlassmorphismEffects.luxuryGradient(isDark: isDark)
              : null,
          color: !isSelected ? bgColor : null,
          borderRadius: BorderRadius.circular(24),
          border: !isSelected
              ? Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          )
              : null,
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: isDark
                  ? AppColors.darkPrimary.withOpacity(0.3)
                  : AppColors.lightPrimary.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: textColor),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppTypography.labelMedium(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}