class AppConstants {
  // App Info
  static const String appName = 'ShopHub';
  static const String appVersion = '1.0.0';

  // Padding and Margin
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;

  // Border Radius
  static const double defaultBorderRadius = 12.0;
  static const double largeBorderRadius = 20.0;

  // Animation Duration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // API Endpoints (Mock)
  static const String baseUrl = 'https://api.shophub.com/';

  // Mock data limits
  static const int itemsPerPage = 20;
  static const int maxProductsInCart = 999;

  // Validation
  static const int minPasswordLength = 8;
  static const int minNameLength = 2;

  // Prices
  static const double defaultShippingCost = 50.0;
  static const double freeShippingThreshold = 500.0;
  static const double taxPercentage = 0.18;

  // URL Patterns (Mock)
  static const String productImageBase = 'https://via.placeholder.com/';
  static const String profileImageBase = 'https://via.placeholder.com/';
}

class AppStrings {
  // Common
  static const String appName = 'ShopHub';
  static const String welcome = 'Welcome';
  static const String login = 'Login';
  static const String logout = 'Logout';
  static const String signup = 'Sign Up';
  static const String register = 'Register';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String save = 'Save';
  static const String search = 'Search';
  static const String settings = 'Settings';
  static const String profile = 'Profile';
  static const String home = 'Home';
  static const String categories = 'Categories';
  static const String cart = 'Cart';
  static const String wishlist = 'Wishlist';
  static const String orders = 'Orders';
  static const String notification = 'Notifications';

  // Authentication
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String rememberMe = 'Remember Me';
  static const String dontHaveAccount = "Don't have an account?";
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String continueText = 'Continue';
  static const String signInWithGoogle = 'Sign in with Google';
  static const String signInWithApple = 'Sign in with Apple';

  // Shopping
  static const String products = 'Products';
  static const String newArrivals = 'New Arrivals';
  static const String bestSellers = 'Best Sellers';
  static const String onSale = 'On Sale';
  static const String reviews = 'Reviews';
  static const String addToCart = 'Add to Cart';
  static const String addToWishlist = 'Add to Wishlist';
  static const String removeFromWishlist = 'Remove from Wishlist';
  static const String quantity = 'Quantity';
  static const String price = 'Price';
  static const String discount = 'Discount';
  static const String shipping = 'Shipping';
  static const String tax = 'Tax';
  static const String total = 'Total';
  static const String subtotal = 'Subtotal';
  static const String estimatedTotal = 'Estimated Total';

  // Checkout
  static const String checkout = 'Checkout';
  static const String shippingAddress = 'Shipping Address';
  static const String billingAddress = 'Billing Address';
  static const String paymentMethod = 'Payment Method';
  static const String orderSummary = 'Order Summary';
  static const String placeOrder = 'Place Order';
  static const String continueCheckout = 'Continue';
  static const String applyCoupon = 'Apply Coupon';
  static const String coupon = 'Coupon Code';

  // Order
  static const String orderConfirmation = 'Order Confirmation';
  static const String orderTracking = 'Order Tracking';
  static const String delivered = 'Delivered';
  static const String processing = 'Processing';
  static const String shipped = 'Shipped';

  // Profile
  static const String editProfile = 'Edit Profile';
  static const String firstName = 'First Name';
  static const String lastName = 'Last Name';
  static const String phone = 'Phone Number';
  static const String address = 'Address';
  static const String city = 'City';
  static const String state = 'State';
  static const String zipCode = 'Zip Code';
  static const String country = 'Country';

  // Messages
  static const String success = 'Success';
  static const String error = 'Error';
  static const String warning = 'Warning';
  static const String loading = 'Loading...';
  static const String noInternet = 'No Internet Connection';
  static const String tryAgain = 'Try Again';
  static const String emptyCart = 'Your cart is empty';
  static const String emptyWishlist = 'Your wishlist is empty';
  static const String emptyOrders = 'No orders yet';
  static const String emptyNotifications = 'No notifications';
}

class AppAssets {
  // Logos
  static const String appLogo = 'assets/images/logo.png';
  static const String appLogoWhite = 'assets/images/logo_white.png';

  // Icons
  static const String iconHome = 'assets/icons/home.svg';
  static const String iconCategories = 'assets/icons/categories.svg';
  static const String iconSearch = 'assets/icons/search.svg';
  static const String iconCart = 'assets/icons/cart.svg';
  static const String iconWishlist = 'assets/icons/wishlist.svg';
  static const String iconProfile = 'assets/icons/profile.svg';

  // Images
  static const String bannerImage = 'assets/images/banner.png';
  static const String emptyCartImage = 'assets/images/empty_cart.png';
  static const String emptyWishlistImage = 'assets/images/empty_wishlist.png';
  static const String noInternetImage = 'assets/images/no_internet.png';
  static const String errorImage = 'assets/images/error.png';

  // Background
  static const String bgWave = 'assets/images/wave_bg.png';
  static const String bgGradient = 'assets/images/gradient_bg.png';
}
