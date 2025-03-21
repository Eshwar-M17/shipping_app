import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/shipping_models.dart';

// Provider definition for the ShippingApiService
final shippingApiServiceProvider = Provider<ShippingApiService>((ref) {
  return ShippingApiService();
});

// Provider for available couriers list
final availableCouriersProvider =
    StateNotifierProvider<CouriersNotifier, List<CourierProvider>>((ref) {
      return CouriersNotifier(ref);
    });

// Provider for the selected courier
final selectedCourierProvider = StateProvider<CourierProvider?>((ref) {
  return null;
});

// Provider for shipping rates loading state
final isLoadingCouriersProvider = StateProvider<bool>((ref) {
  return false;
});

// Provider for package data
final packageProvider = StateProvider<Package?>((ref) {
  return null;
});

// Provider for calculating total price
final totalPriceProvider = Provider<double>((ref) {
  final courier = ref.watch(selectedCourierProvider);
  final package = ref.watch(packageProvider);

  if (courier == null || package == null) return 0;

  final chargeableWeight =
      package.weight > package.volumetricWeight
          ? package.weight
          : package.volumetricWeight;

  return courier.basePrice + (courier.pricePerKg * chargeableWeight);
});

// Provider to check if we're creating a new order
final isNewOrderProvider = StateProvider<bool>((ref) => true);

// Notifier for managing couriers state
class CouriersNotifier extends StateNotifier<List<CourierProvider>> {
  final Ref _ref;

  CouriersNotifier(this._ref) : super([]);

  Future<void> fetchShippingRates({
    required Package package,
    required String pickupPostalCode,
    required String deliveryPostalCode,
  }) async {
    final apiService = _ref.read(shippingApiServiceProvider);
    _ref.read(isLoadingCouriersProvider.notifier).state = true;

    try {
      final rates = await apiService.fetchShippingRates(
        package: package,
        pickupPostalCode: pickupPostalCode,
        deliveryPostalCode: deliveryPostalCode,
      );

      state = rates;

      // Select first courier by default if available
      if (rates.isNotEmpty && _ref.read(selectedCourierProvider) == null) {
        _ref.read(selectedCourierProvider.notifier).state = rates.first;
      }
    } catch (e) {
      print('Error in CouriersNotifier: $e');
      state = [];
    } finally {
      _ref.read(isLoadingCouriersProvider.notifier).state = false;
    }
  }

  // Reset the couriers state
  void resetCouriers() {
    state = [];
    _ref.read(selectedCourierProvider.notifier).state = null;
  }
}

class ShippingApiService {
  // Base URLs options for your API
  static const String wifiIpBaseUrl =
      'http://192.168.1.X:5000/api'; // Replace X with your actual IP
  static const String emulatorBaseUrl =
      'http://10.0.2.2:5000/api'; // For Android emulator
  static const String localhostBaseUrl =
      'http://localhost:5000/api'; // For web/iOS

  // Automatically select the appropriate URL based on platform
  late final String baseUrl;

  ShippingApiService() {
    if (kIsWeb) {
      // Web uses localhost
      baseUrl = localhostBaseUrl;
    } else if (Platform.isAndroid) {
      // Android emulator needs the special 10.0.2.2 IP
      baseUrl = emulatorBaseUrl;
    } else {
      // iOS simulator or desktop can use localhost
      baseUrl = localhostBaseUrl;
    }
    print('ShippingApiService initialized with baseUrl: $baseUrl');
  }

  // HTTP Client for making requests with timeout
  final http.Client _client = http.Client();

  // Fetch shipping rates based on package details and locations
  Future<List<CourierProvider>> fetchShippingRates({
    required Package package,
    required String pickupPostalCode,
    required String deliveryPostalCode,
  }) async {
    try {
      print('Attempting to fetch shipping rates from: $baseUrl/shipping/rates');

      // Create request payload
      final Map<String, dynamic> payload = {
        'weight': package.weight,
        'dimensions': {
          'length': package.length,
          'width': package.width,
          'height': package.height,
        },
        'pickup_postal_code': pickupPostalCode,
        'delivery_postal_code': deliveryPostalCode,
      };

      print('Request payload: ${jsonEncode(payload)}');

      // Make API request with timeout
      final response = await _client
          .post(
            Uri.parse('$baseUrl/shipping/rates'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              print('API request timed out.');
              throw TimeoutException('API request timed out');
            },
          );

      print('Response received with status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Response data: $responseData');

        if (responseData['success'] == true && responseData['data'] != null) {
          final Map<String, dynamic> data = responseData['data'];
          final List<dynamic> rates = data['rates'] as List<dynamic>;
          return rates.map((json) => CourierProvider.fromJson(json)).toList();
        } else {
          throw Exception(
            'Failed to fetch shipping rates: ${responseData['message']}',
          );
        }
      } else {
        throw Exception(
          'Failed to fetch shipping rates: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching shipping rates: $e');
      rethrow;
    }
  }
}
