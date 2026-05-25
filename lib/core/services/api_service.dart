import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../models/api_response.dart';
import '../../models/category_model.dart';
import '../../models/product_model.dart';


class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  static const String baseUrl = 'https://dummyjson.com';

  Future<void> init() async {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('📡 Request: ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ Response: ${response.statusCode} ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (error, handler) {
        print('❌ Error: ${error.message}');
        return handler.next(error);
      },
    ));
  }

  // ✅ دالة التحقق من الاتصال بالإنترنت
  Future<bool> hasInternet() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  // جلب المنتجات مع التحميل اللانهائي
  Future<ProductsResponse?> fetchProducts({int limit = 30, int skip = 0}) async {
    try {
      final hasConnection = await hasInternet();
      if (!hasConnection) {
        throw Exception('No internet connection');
      }

      final response = await _dio.get('/products', queryParameters: {
        'limit': limit,
        'skip': skip,
      });

      if (response.statusCode == 200) {
        return ProductsResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error fetching products: $e');
      return null;
    }
  }

  // جلب التصنيفات
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final hasConnection = await hasInternet();
      if (!hasConnection) {
        throw Exception('No internet connection');
      }

      final response = await _dio.get('/products/categories');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  // جلب تفاصيل المنتج
  Future<ProductModel?> fetchProductDetails(int id) async {
    try {
      final hasConnection = await hasInternet();
      if (!hasConnection) {
        throw Exception('No internet connection');
      }

      final response = await _dio.get('/products/$id');

      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error fetching product details: $e');
      return null;
    }
  }

  // البحث عن المنتجات
  Future<ProductsResponse?> searchProducts(String query) async {
    try {
      final hasConnection = await hasInternet();
      if (!hasConnection) {
        throw Exception('No internet connection');
      }

      final response = await _dio.get('/products/search', queryParameters: {
        'q': query,
      });

      if (response.statusCode == 200) {
        return ProductsResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error searching products: $e');
      return null;
    }
  }

  // ✅ جلب المنتجات حسب التصنيف (أضف هذه الدالة)
  Future<ProductsResponse?> fetchProductsByCategory(String category) async {
    try {
      final hasConnection = await hasInternet();
      if (!hasConnection) {
        throw Exception('No internet connection');
      }

      final response = await _dio.get('/products/category/$category');

      if (response.statusCode == 200) {
        return ProductsResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error fetching products by category: $e');
      return null;
    }
  }
}