import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/wishlist_item.dart';
import 'core/theme/app_theme.dart';
import 'core/services/api_service.dart';
import 'core/services/secure_storage_service.dart';
import 'features/home/screens/empty_wishlist_screen.dart';
import 'features/home/screens/sale_products_screen.dart';
import 'providers/wishlist_provider.dart';
import 'providers/auth_provider.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/onboarding_screen.dart';
import 'features/auth/screens/welcome_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/auth/screens/forgot_password_screen.dart';
import 'features/auth/screens/reset_password_screen.dart';
import 'features/auth/screens/otp_verification_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/home/screens/search_screen.dart';
import 'features/home/screens/category_products_screen.dart';
import 'features/home/screens/product_detail_screen.dart';
import 'features/home/screens/product_reviews_screen.dart';
import 'features/home/screens/empty_cart_screen.dart';
import 'features/home/screens/no_internet_screen.dart';
import 'features/home/screens/error_state_screen.dart';
import 'features/home/screens/empty_search_screen.dart';
import 'features/home/screens/not_found_screen.dart';
import 'features/checkout/screens/shipping_address_screen.dart';
import 'features/checkout/screens/payment_method_screen.dart';
import 'features/checkout/screens/delivery_method_screen.dart';
import 'features/checkout/screens/checkout_summary_screen.dart';
import 'features/checkout/screens/order_success_screen.dart';
import 'features/checkout/screens/order_tracking_screen.dart';
import 'features/checkout/screens/add_address_screen.dart';
import 'features/profile/screens/edit_profile_screen.dart';
import 'features/profile/screens/orders_history_screen.dart';
import 'features/profile/screens/order_details_screen.dart';
import 'features/profile/screens/notifications_screen.dart';
import 'features/profile/screens/empty_notifications_screen.dart';
import 'features/profile/screens/settings_screen.dart';
import 'features/profile/screens/help_support_screen.dart';
import 'features/profile/screens/about_app_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ تهيئة Hive
  await Hive.initFlutter();
  Hive.registerAdapter(WishlistItemAdapter());
  await Hive.openBox('wishlist_box');

  // ✅ تهيئة Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // تهيئة ApiService
  final apiService = ApiService();
  await apiService.init();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    // ✅ الاستماع إلى حالة تسجيل الدخول
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'ShopHub - Ecommerce App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // ✅ تحديد الشاشة الابتدائية بناءً على حالة تسجيل الدخول
      home: authState.when(
        data: (user) {
          if (user != null) {
            // المستخدم مسجل دخوله → اذهب إلى HomeScreen
            return const HomeScreen();
          } else {
            // المستخدم غير مسجل → اذهب إلى SplashScreen
            return const SplashScreen();
          }
        },
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, _) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(authStateProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case '/onboarding':
            return MaterialPageRoute(builder: (_) => const OnboardingScreen());
          case '/welcome':
            return MaterialPageRoute(builder: (_) => const WelcomeScreen());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/register':
            return MaterialPageRoute(builder: (_) => const RegisterScreen());
          case '/forgot-password':
            return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
          case '/reset-password':
            return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
          case '/otp-verification':
            return MaterialPageRoute(builder: (_) => const OtpVerificationScreen());
          case '/home':
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case '/search':
            return MaterialPageRoute(builder: (_) => const SearchScreen());
          case '/category-products':
            final args = settings.arguments as Map<String, dynamic>?;
            final categorySlug = args?['category'] as String? ?? '';
            final categoryName = args?['categoryName'] as String? ?? 'Products';
            return MaterialPageRoute(
              builder: (_) => CategoryProductsScreen(
                categorySlug: categorySlug,
                categoryName: categoryName,
              ),
            );
          case '/product-detail':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (_) => ProductDetailScreen(productId: args?['productId']),
            );
          case '/product-reviews':
            return MaterialPageRoute(builder: (_) => const ProductReviewsScreen());
          case '/wishlist':
            return MaterialPageRoute(builder: (_) => const WishlistScreen());
          case '/sale-products':
            return MaterialPageRoute(builder: (_) => const SaleProductsScreen());
          case '/best-sellers':
            return MaterialPageRoute(builder: (_) => const SearchScreen());
          case '/new-arrivals':
            return MaterialPageRoute(builder: (_) => const SearchScreen());
          case '/empty-cart':
            return MaterialPageRoute(builder: (_) => const EmptyCartScreen());
          case '/no-internet':
            return MaterialPageRoute(builder: (_) => const NoInternetScreen());
          case '/error':
            return MaterialPageRoute(builder: (_) => const ErrorStateScreen());
          case '/empty-search':
            return MaterialPageRoute(builder: (_) => const EmptySearchScreen());
          case '/not-found':
            return MaterialPageRoute(builder: (_) => const NotFoundScreen());
          case '/shipping-address':
            return MaterialPageRoute(builder: (_) => const ShippingAddressScreen());
          case '/add-address':
            return MaterialPageRoute(builder: (_) => const AddAddressScreen());
          case '/delivery-method':
            return MaterialPageRoute(builder: (_) => const DeliveryMethodScreen());
          case '/payment-method':
            return MaterialPageRoute(builder: (_) => const PaymentMethodScreen());
          case '/checkout-summary':
            return MaterialPageRoute(builder: (_) => const CheckoutSummaryScreen());
          case '/order-success':
            return MaterialPageRoute(builder: (_) => const OrderSuccessScreen());
          case '/order-tracking':
            return MaterialPageRoute(builder: (_) => const OrderTrackingScreen());
          case '/edit-profile':
            return MaterialPageRoute(builder: (_) => const EditProfileScreen());
          case '/orders-history':
            return MaterialPageRoute(builder: (_) => const OrdersHistoryScreen());
          case '/order-details':
            return MaterialPageRoute(builder: (_) => const OrderDetailsScreen());
          case '/notifications':
            return MaterialPageRoute(builder: (_) => const NotificationsScreen());
          case '/empty-notifications':
            return MaterialPageRoute(builder: (_) => const EmptyNotificationsScreen());
          case '/settings':
            return MaterialPageRoute(builder: (_) => const SettingsScreen());
          case '/help-support':
            return MaterialPageRoute(builder: (_) => const HelpSupportScreen());
          case '/about-app':
            return MaterialPageRoute(builder: (_) => const AboutAppScreen());
          default:
            return MaterialPageRoute(builder: (_) => const NotFoundScreen());
        }
      },
    );
  }
}