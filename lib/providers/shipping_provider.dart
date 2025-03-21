import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shipping_models.dart' as models;
import '../services/shipping_api_service.dart';

// Cache key generator for shipping rates
String _generateCacheKey(
  models.Package package,
  String pickup,
  String delivery,
) {
  return '${package.weight}-$pickup-$delivery';
}

// Provider for the shipping API service
final shippingApiServiceProvider = Provider<ShippingApiService>((ref) {
  return ShippingApiService();
});

// Provider for available couriers
final availableCouriersProvider =
    StateNotifierProvider<CouriersNotifier, List<models.CourierProvider>>((
      ref,
    ) {
      return CouriersNotifier(ref.read(shippingApiServiceProvider));
    });

// Provider for selected courier
final selectedCourierProvider = StateProvider<models.CourierProvider?>(
  (ref) => null,
);

// Provider for loading state
final isLoadingCouriersProvider = StateProvider<bool>((ref) => false);

// Provider for error state
final courierErrorProvider = StateProvider<String?>((ref) => null);

// Provider for total price calculation
final totalPriceProvider = Provider<double>((ref) {
  final selectedCourier = ref.watch(selectedCourierProvider);
  final package = ref.watch(packageProvider);

  if (selectedCourier == null || package == null) return 0.0;

  return selectedCourier.calculateTotal(package.weight);
});

// Provider for package details
final packageProvider = StateProvider<models.Package?>((ref) => null);

// Provider to track if we're creating a new order
final isNewOrderProvider = StateProvider<bool>((ref) => true);

// Notifier for managing couriers
class CouriersNotifier extends StateNotifier<List<models.CourierProvider>> {
  final ShippingApiService _apiService;
  final Map<String, List<models.CourierProvider>> _cache = {};

  CouriersNotifier(this._apiService) : super([]);

  Future<void> fetchShippingRates({
    required models.Package package,
    required String pickupPostalCode,
    required String deliveryPostalCode,
  }) async {
    final cacheKey = _generateCacheKey(
      package,
      pickupPostalCode,
      deliveryPostalCode,
    );

    // Check cache first
    if (_cache.containsKey(cacheKey)) {
      state = _cache[cacheKey]!;
      return;
    }

    try {
      final rates = await _apiService.fetchShippingRates(
        package: package,
        pickupPostalCode: pickupPostalCode,
        deliveryPostalCode: deliveryPostalCode,
      );

      // Update cache
      _cache[cacheKey] = rates;
      state = rates;
    } catch (e) {
      state = [];
      rethrow;
    }
  }

  void resetCouriers() {
    state = [];
  }
}

class ShippingProvider with ChangeNotifier {
  final ShippingApiService _apiService = ShippingApiService();

  // State variables
  List<models.CourierProvider> _availableCouriers = [];
  models.CourierProvider? _selectedCourier;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<models.CourierProvider> get availableCouriers => _availableCouriers;
  models.CourierProvider? get selectedCourier => _selectedCourier;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Set selected courier
  void selectCourier(models.CourierProvider courier) {
    _selectedCourier = courier;
    notifyListeners();
  }

  // Calculate shipping rates
  Future<void> calculateRates({
    required models.Package package,
    required String pickupPostalCode,
    required String deliveryPostalCode,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final rates = await _apiService.fetchShippingRates(
        package: package,
        pickupPostalCode: pickupPostalCode,
        deliveryPostalCode: deliveryPostalCode,
      );

      _availableCouriers = rates;
      if (rates.isNotEmpty && _selectedCourier == null) {
        _selectedCourier = rates.first;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
