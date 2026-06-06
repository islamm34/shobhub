import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/checkout/screens/add_address_screen.dart';
import '../features/checkout/screens/checkout_summary_screen.dart';
import '../features/checkout/screens/delivery_method_screen.dart';
import '../features/checkout/screens/order_success_screen.dart';
import '../features/checkout/screens/order_tracking_screen.dart';
import '../features/checkout/screens/payment_method_screen.dart';
import '../features/checkout/screens/shipping_address_screen.dart';
import '../features/home/screens/empty_search_screen.dart';
import '../features/home/screens/error_state_screen.dart';
import '../features/home/screens/no_internet_screen.dart';
import '../features/home/screens/not_found_screen.dart';
import '../features/home/screens/product_detail_screen.dart';
import '../features/home/screens/product_reviews_screen.dart';
import '../features/home/screens/sale_products_screen.dart';
import '../features/home/screens/search_screen.dart';
import '../features/profile/screens/about_app_screen.dart';
import '../features/profile/screens/edit_profile_screen.dart';
import '../features/profile/screens/empty_notifications_screen.dart';
import '../features/profile/screens/help_support_screen.dart';
import '../features/profile/screens/notifications_screen.dart';
import '../features/profile/screens/order_details_screen.dart';
import '../features/profile/screens/orders_history_screen.dart';
import '../features/profile/screens/settings_screen.dart';
import '../providers/auth_provider.dart';
import '../features/auth/splash_screen/splash_screen.dart';
import '../features/auth/onboarding_screen/onboarding_screen.dart';
import '../features/auth/welcome_screen/welcome_screen.dart';
import '../features/auth/login_screen/login_screen.dart';
import '../features/auth/register_screen/register_screen.dart';
import '../features/auth/forgot_password_screen/forgot_password_screen.dart';
import '../features/auth/reset_password_screen/reset_password_screen.dart';
import '../features/auth/otp_verification_screen/otp_verification_screen.dart';
import '../features/home/home_screen/home_screen.dart';
import '../features/home/empty_wishlist_screen/empty_wishlist_screen.dart';
import '../features/home/empty_cart_screen/empty_cart_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    // الحصول على حالة المصادقة
    final authState = ProviderScope.containerOf(
      context,
    ).read(authStateProvider);

    final isLoggedIn = authState.value != null;
    final user = authState.value; // اسم المستخدم أو بياناته

    // المسارات التي لا تحتاج تسجيل دخول (Auth Routes)
    final isAuthRoute = state.matchedLocation == '/login' ||
        state.matchedLocation == '/register' ||
        state.matchedLocation == '/splash' ||
        state.matchedLocation == '/onboarding' ||
        state.matchedLocation == '/welcome' ||
        state.matchedLocation == '/forgot-password' ||
        state.matchedLocation == '/reset-password' ||
        state.matchedLocation == '/otp-verification';

    // ✅ إذا كان المستخدم مسجل دخول ويحاول دخول شاشات تسجيل الدخول
    if (isLoggedIn && isAuthRoute) {
      print('✅ User is logged in, redirecting to Home...');
      return '/home';
    }

    // ✅ إذا كان المستخدم غير مسجل دخول ويحاول دخول شاشات protected
    if (!isLoggedIn && !isAuthRoute) {
      print('⚠️ User not logged in, redirecting to Login...');
      return '/login';  // ← أرسل للوجن مش للسبلاش
    }

    // ✅ البقاء في المسار الحالي إذا كان كل شيء مناسب
    return null;
  },
  routes: [
    // ========== Auth Routes ==========
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/welcome',
      name: 'welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      name: 'forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      name: 'reset-password',
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    GoRoute(
      path: '/otp-verification',
      name: 'otp-verification',
      builder: (context, state) => const OtpVerificationScreen(),
    ),

    // ========== Main App Routes (Protected) ==========
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/product-detail',
      name: 'product-detail',
      builder: (context, state) {
        final productId = state.extra as int?;
        return ProductDetailScreen(productId: productId);
      },
    ),
    GoRoute(
      path: '/product-reviews',
      name: 'product-reviews',
      builder: (context, state) => const ProductReviewsScreen(),
    ),
    GoRoute(
      path: '/best-sellers',
      name: 'best-sellers',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/new-arrivals',
      name: 'new-arrivals',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/category-products',
      name: 'category-products',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final category = extra?['category'] as String?;
        return SearchScreen(initialCategory: category);
      },
    ),
    GoRoute(
      path: '/wishlist',
      name: 'wishlist',
      builder: (context, state) => const WishlistScreen(),
    ),
    GoRoute(
      path: '/empty-cart',
      name: 'empty-cart',
      builder: (context, state) => const CartScreen(),
    ),

    // ========== Checkout Routes ==========
    GoRoute(
      path: '/shipping-address',
      name: 'shipping-address',
      builder: (context, state) => const ShippingAddressScreen(),
    ),
    GoRoute(
      path: '/add-address',
      name: 'add-address',
      builder: (context, state) => const AddAddressScreen(),
    ),
    GoRoute(
      path: '/delivery-method',
      name: 'delivery-method',
      builder: (context, state) => const DeliveryMethodScreen(),
    ),
    GoRoute(
      path: '/payment-method',
      name: 'payment-method',
      builder: (context, state) => const PaymentMethodScreen(),
    ),
    GoRoute(
      path: '/checkout-summary',
      name: 'checkout-summary',
      builder: (context, state) => const CheckoutSummaryScreen(),
    ),
    GoRoute(
      path: '/order-success',
      name: 'order-success',
      builder: (context, state) => const OrderSuccessScreen(),
    ),
    GoRoute(
      path: '/order-tracking',
      name: 'order-tracking',
      builder: (context, state) => const OrderTrackingScreen(),
    ),

    // ========== Product Routes ==========
    GoRoute(
      path: '/sale-products',
      name: 'sale-products',
      builder: (context, state) => const SaleProductsScreen(),
    ),

    // ========== Error Routes ==========
    GoRoute(
      path: '/no-internet',
      name: 'no-internet',
      builder: (context, state) => const NoInternetScreen(),
    ),
    GoRoute(
      path: '/error',
      name: 'error',
      builder: (context, state) => const ErrorStateScreen(),
    ),
    GoRoute(
      path: '/empty-search',
      name: 'empty-search',
      builder: (context, state) => const EmptySearchScreen(),
    ),
    GoRoute(
      path: '/not-found',
      name: 'not-found',
      builder: (context, state) => const NotFoundScreen(),
    ),

    // ========== Profile Routes ==========
    GoRoute(
      path: '/edit-profile',
      name: 'edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/orders-history',
      name: 'orders-history',
      builder: (context, state) => const OrdersHistoryScreen(),
    ),
    GoRoute(
      path: '/order-details',
      name: 'order-details',
      builder: (context, state) => const OrderDetailsScreen(),
    ),
    GoRoute(
      path: '/notifications',
      name: 'notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/empty-notifications',
      name: 'empty-notifications',
      builder: (context, state) => const EmptyNotificationsScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/help-support',
      name: 'help-support',
      builder: (context, state) => const HelpSupportScreen(),
    ),
    GoRoute(
      path: '/about-app',
      name: 'about-app',
      builder: (context, state) => const AboutAppScreen(),
    ),
  ],
);