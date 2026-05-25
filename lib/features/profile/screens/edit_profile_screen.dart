import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/models/dummy_models.dart';
import '../../../shared/widgets/base_widgets.dart';
import '../../../shared/widgets/component_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final user = DummyDataProvider.currentUser;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: user.name);
    emailController = TextEditingController(text: user.email);
    phoneController = TextEditingController(text: user.phone);
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });

        // Visual feedback
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profile picture updated'),
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkSuccess
                  : AppColors.lightSuccess,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to pick image'),
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkError
                : AppColors.lightError,
          ),
        );
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });

        // Visual feedback
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Photo captured and set as profile picture'),
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkSuccess
                  : AppColors.lightSuccess,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to capture photo'),
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkError
                : AppColors.lightError,
          ),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkBackground
                : AppColors.lightBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose Photo Source',
                style: AppTypography.headline4(
                  color: isDark
                      ? AppColors.darkOnBackground
                      : AppColors.lightOnBackground,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _pickImageFromGallery();
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? AppColors.darkSurfaceContainer
                                : AppColors.lightSurfaceContainer,
                          ),
                          child: Icon(
                            Icons.photo_library_rounded,
                            size: 40,
                            color: isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Gallery',
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
                      Navigator.pop(context);
                      _pickImageFromCamera();
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? AppColors.darkSurfaceContainer
                                : AppColors.lightSurfaceContainer,
                          ),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            size: 40,
                            color: isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Camera',
                          style: AppTypography.bodyMedium(
                            color: isDark
                                ? AppColors.darkOnBackground
                                : AppColors.lightOnBackground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PremiumAppBar(title: 'Edit Profile', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Picture
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? AppColors.darkSurfaceContainer
                            : AppColors.lightSurfaceContainer,
                      ),
                      child: _selectedImage != null
                          ? ClipOval(
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: 50,
                              color: isDark
                                  ? AppColors.darkOnBackground
                                  : AppColors.lightOnBackground,
                            ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary,
                        boxShadow: [
                          BoxShadow(
                            color:
                                (isDark
                                        ? AppColors.darkPrimary
                                        : AppColors.lightPrimary)
                                    .withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
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
              label: 'Phone Number',
              hint: 'Enter your phone',
              keyboardType: TextInputType.phone,
              controller: phoneController,
              prefixIcon: Icons.phone_outlined,
            ),
            const SizedBox(height: 32),
            PremiumButton(
              label: 'Save Changes',
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Profile updated successfully'),
                    backgroundColor: isDark
                        ? AppColors.darkSuccess
                        : AppColors.lightSuccess,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
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
    phoneController.dispose();
    super.dispose();
  }
}
