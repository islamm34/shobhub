import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/onboarding_screen.dart';
import '../features/auth/screens/welcome_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/auth/screens/reset_password_screen.dart';
import '../features/auth/screens/otp_verification_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/home/screens/search_screen.dart';
import '../features/home/screens/product_detail_screen.dart';
import '../features/home/screens/product_reviews_screen.dart';
import '../features/home/screens/empty_wishlist_screen.dart';
import '../features/home/screens/empty_cart_screen.dart';
import '../features/home/screens/sale_products_screen.dart';
import '../features/home/screens/no_internet_screen.dart';
import '../features/home/screens/error_state_screen.dart';
import '../features/home/screens/empty_search_screen.dart';
import '../features/home/screens/not_found_screen.dart';
import '../features/checkout/screens/shipping_address_screen.dart';
import '../features/checkout/screens/payment_method_screen.dart';
import '../features/checkout/screens/delivery_method_screen.dart';
import '../features/checkout/screens/checkout_summary_screen.dart';
import '../features/checkout/screens/order_success_screen.dart';
import '../features/checkout/screens/order_tracking_screen.dart';
import '../features/checkout/screens/add_address_screen.dart';
import '../features/profile/screens/edit_profile_screen.dart';
import '../features/profile/screens/orders_history_screen.dart';
import '../features/profile/screens/order_details_screen.dart';
import '../features/profile/screens/notifications_screen.dart';
import '../features/profile/screens/empty_notifications_screen.dart';
import '../features/profile/screens/settings_screen.dart';
import '../features/profile/screens/help_support_screen.dart';
import '../features/profile/screens/about_app_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    final authState = ProviderScope.containerOf(
      context,
    ).read(authStateProvider);
    final isLoggedIn = authState.value != null;

    final isAuthRoute =
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register' ||
        state.matchedLocation == '/splash' ||
        state.matchedLocation == '/onboarding' ||
        state.matchedLocation == '/welcome';

    if (isLoggedIn && isAuthRoute) {
      return '/home';
    }

    if (!isLoggedIn && !isAuthRoute) {
      return '/splash';
    }

    return null;
  },
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    GoRoute(
      path: '/otp-verification',
      builder: (context, state) => const OtpVerificationScreen(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
    GoRoute(
      path: '/product-detail',
      builder: (context, state) {
        // ✅ استلام المنتج ID بشكل صحيح
        final productId = state.extra as int?;
        return ProductDetailScreen(productId: productId);
      },
    ),
    GoRoute(
      path: '/product-reviews',
      builder: (context, state) => const ProductReviewsScreen(),
    ),
    GoRoute(
      path: '/best-sellers',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/new-arrivals',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/category-products',
      builder: (context, state) {
        // ✅ استلام بيانات التصنيف بشكل صحيح
        final extra = state.extra as Map<String, dynamic>?;
        final category = extra?['category'] as String?;
        return SearchScreen(initialCategory: category);
      },
    ),
    GoRoute(
      path: '/wishlist',
      builder: (context, state) => const WishlistScreen(),
    ),
    GoRoute(
      path: '/empty-cart',
      builder: (context, state) => const EmptyCartScreen(),
    ),
    GoRoute(
      path: '/sale-products',
      builder: (context, state) => const SaleProductsScreen(),
    ),
    GoRoute(
      path: '/no-internet',
      builder: (context, state) => const NoInternetScreen(),
    ),
    GoRoute(
      path: '/error',
      builder: (context, state) => const ErrorStateScreen(),
    ),
    GoRoute(
      path: '/empty-search',
      builder: (context, state) => const EmptySearchScreen(),
    ),
    GoRoute(
      path: '/not-found',
      builder: (context, state) => const NotFoundScreen(),
    ),
    GoRoute(
      path: '/shipping-address',
      builder: (context, state) => const ShippingAddressScreen(),
    ),
    GoRoute(
      path: '/add-address',
      builder: (context, state) => const AddAddressScreen(),
    ),
    GoRoute(
      path: '/delivery-method',
      builder: (context, state) => const DeliveryMethodScreen(),
    ),
    GoRoute(
      path: '/payment-method',
      builder: (context, state) => const PaymentMethodScreen(),
    ),
    GoRoute(
      path: '/checkout-summary',
      builder: (context, state) => const CheckoutSummaryScreen(),
    ),
    GoRoute(
      path: '/order-success',
      builder: (context, state) => const OrderSuccessScreen(),
    ),
    GoRoute(
      path: '/order-tracking',
      builder: (context, state) => const OrderTrackingScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/orders-history',
      builder: (context, state) => const OrdersHistoryScreen(),
    ),
    GoRoute(
      path: '/order-details',
      builder: (context, state) => const OrderDetailsScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/empty-notifications',
      builder: (context, state) => const EmptyNotificationsScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/help-support',
      builder: (context, state) => const HelpSupportScreen(),
    ),
    GoRoute(
      path: '/about-app',
      builder: (context, state) => const AboutAppScreen(),
    ),
  ],
);
