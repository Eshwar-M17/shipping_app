import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shipping_models.dart';
import '../theme/app_theme.dart';
import '../widgets/address_form.dart';
import '../widgets/package_details_form.dart';
import '../widgets/courier_selection.dart';
import '../widgets/payment_summary.dart';
import '../services/shipping_api_service.dart';

// Provider for the current step in the booking flow
final currentStepProvider = StateProvider<int>((ref) => 0);

// Providers for addresses
final pickupAddressProvider = StateProvider<Address?>((ref) => null);
final deliveryAddressProvider = StateProvider<Address?>((ref) => null);

// Provider for payment method
final paymentMethodProvider = StateProvider<String>(
  (ref) => 'Cash On Delivery',
);

// Dummy addresses for testing
final Address dummyPickupAddress = Address(
  name: 'Raj Kumar',
  street: '123 Main Street',
  street2: 'Apartment 4B',
  city: 'Mumbai',
  state: 'Maharashtra',
  postalCode: '400001',
  phone: '9876543210',
);

final Address dummyDeliveryAddress = Address(
  name: 'Priya Singh',
  street: '456 Park Avenue',
  street2: 'Floor 3',
  city: 'Delhi',
  state: 'Delhi',
  postalCode: '110001',
  phone: '8765432109',
);

class BookShipmentScreen extends ConsumerStatefulWidget {
  const BookShipmentScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BookShipmentScreen> createState() => _BookShipmentScreenState();
}

class _BookShipmentScreenState extends ConsumerState<BookShipmentScreen> {
  // Use GlobalKeys for each form step to access their validation state
  final _packageFormKey = GlobalKey<FormState>();
  final _addressFormKey = GlobalKey<FormState>();
  final _paymentFormKey = GlobalKey<FormState>();

  // Track the order placement state
  bool _isPlacingOrder = false;

  @override
  void initState() {
    super.initState();

    // Check if we're creating a new order
    // If so, reset all form data
    if (ref.read(isNewOrderProvider)) {
      _resetForm();

      // Initialize dummy data after the widget tree is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Add dummy addresses for development/testing
        // Comment these lines out for production
        ref.read(pickupAddressProvider.notifier).state = dummyPickupAddress;
        ref.read(deliveryAddressProvider.notifier).state = dummyDeliveryAddress;
      });
    }
  }

  // Reset all form data to create a new order
  void _resetForm() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Reset current step to the beginning
      ref.read(currentStepProvider.notifier).state = 0;

      // Clear all address data
      ref.read(pickupAddressProvider.notifier).state = null;
      ref.read(deliveryAddressProvider.notifier).state = null;

      // Reset courier selection
      ref.read(selectedCourierProvider.notifier).state = null;
      ref.read(availableCouriersProvider.notifier).resetCouriers();

      // Clear package data
      ref.read(packageProvider.notifier).state = null;

      // Reset payment method to default
      ref.read(paymentMethodProvider.notifier).state = 'Cash On Delivery';

      // Mark as a new order
      ref.read(isNewOrderProvider.notifier).state = true;

      // For development/testing, add dummy addresses (optional)
      // Comment these out for production
      ref.read(pickupAddressProvider.notifier).state = dummyPickupAddress;
      ref.read(deliveryAddressProvider.notifier).state = dummyDeliveryAddress;
    });
  }

  // // Save the order to the database (simulated for now)
  // Future<ShippingOrder> _saveOrder() async {
  //   final package = ref.read(packageProvider);
  //   final pickupAddress = ref.read(pickupAddressProvider);
  //   final deliveryAddress = ref.read(deliveryAddressProvider);
  //   final courier = ref.read(selectedCourierProvider);
  //   final totalPrice = ref.read(totalPriceProvider);
  //   final paymentMethod = ref.read(paymentMethodProvider);

  //   if (package == null ||
  //       pickupAddress == null ||
  //       deliveryAddress == null ||
  //       courier == null) {
  //     throw Exception('Missing required order information');
  //   }

  //   // Create an order object
  //   final order = ShippingOrder(
  //     id: DateTime.now().millisecondsSinceEpoch, // Generate a unique ID
  //     package: package,
  //     pickupAddress: pickupAddress,
  //     deliveryAddress: deliveryAddress,
  //     courier: courier,
  //     totalPrice: totalPrice,
  //     status: 'pending',
  //     createdAt: DateTime.now(),
  //   );

  //   // Add to our local state management
  //   ref.read(completedOrdersProvider.notifier).addOrder(order);

  //   // Try to save to API if available
  //   final apiService = ref.read(shippingApiServiceProvider);
  //   try {
  //     final serverOrder = await apiService.createOrder(
  //       package: package,
  //       pickupAddress: pickupAddress,
  //       deliveryAddress: deliveryAddress,
  //       courierId: courier.id,
  //       totalPrice: totalPrice,
  //     );
  //     return serverOrder;
  //   } catch (e) {
  //     // If API fails, still return our local order
  //     print('Error saving to API, using local order: ${order.id}');
  //     return order;
  //   }
  // }

  // Create a package from current form data
  void _createPackage() {
    final packageState = ref.read(packageProvider);
    if (packageState != null) {
      // Package already exists in the provider
      return;
    }

    // Get package details form state
    final packageForm = _packageFormKey.currentState;
    if (packageForm?.validate() ?? false) {
      // Let the package details form handle creating the package
      // This is already done in the PackageDetailsForm widget
    }
  }

  // Calculate shipping rates based on package and address information
  void _calculateShippingRates() {
    final package = ref.read(packageProvider);
    final pickupAddress = ref.read(pickupAddressProvider);
    final deliveryAddress = ref.read(deliveryAddressProvider);

    if (package == null || pickupAddress == null || deliveryAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Missing package or address information'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading state
    ref.read(isLoadingCouriersProvider.notifier).state = true;

    // Use the pickup and delivery pincodes to calculate rates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(availableCouriersProvider.notifier)
          .fetchShippingRates(
            package: package,
            pickupPostalCode: pickupAddress.postalCode,
            deliveryPostalCode: deliveryAddress.postalCode,
          )
          .then((_) {
            // Check if rates were fetched
            final couriers = ref.read(availableCouriersProvider);
            if (couriers.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'No shipping rates available for this route. Please try a different address.',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          })
          .catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error calculating rates: ${error.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          });
    });
  }

  // Handle package details validation
  bool _validatePackageDetails() {
    final package = ref.read(packageProvider);
    return package != null &&
        package.weight > 0 &&
        package.length > 0 &&
        package.width > 0 &&
        package.height > 0;
  }

  // Handle order placement
  Future<void> _placeOrder() async {
    setState(() {
      _isPlacingOrder = true;
    });

    try {
      // Call the existing order saving logic that's already set up

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order placed successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Reset the form for a new order
      _resetForm();

      // Navigate to orders screen if it exists, otherwise go back to home
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error placing order: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isPlacingOrder = false;
      });
    }
  }

  // Handle navigation to the next step
  void _navigateToNextStep() async {
    int currentStep = ref.read(currentStepProvider);

    // Validate current step
    bool isValid = false;

    switch (currentStep) {
      case 0: // Package Details
        isValid = _validatePackageDetails();
        break;

      case 1: // Addresses
        final pickupAddress = ref.read(pickupAddressProvider);
        final deliveryAddress = ref.read(deliveryAddressProvider);
        isValid = pickupAddress != null && deliveryAddress != null;

        // If both addresses are valid, calculate shipping rates
        if (isValid) {
          _calculateShippingRates();
        }
        break;

      case 2: // Shipping Rates
        final selectedCourier = ref.read(selectedCourierProvider);
        isValid = selectedCourier != null;
        break;

      case 3: // Payment & Review
        final paymentMethod = ref.read(paymentMethodProvider);
        isValid = paymentMethod.isNotEmpty;

        // Place the order when completing the final step
        if (isValid) {
          await _placeOrder();
          return; // Exit after placing order
        }
        break;
    }

    if (isValid) {
      // Move to the next step
      ref.read(currentStepProvider.notifier).state = currentStep + 1;
    } else {
      // Show validation error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please complete all required fields before continuing',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _currentStep = ref.watch(currentStepProvider);

    // Create step titles and descriptions with 4 steps instead of 3
    final List<Map<String, String>> steps = [
      {'title': 'Package', 'subtitle': 'Package details'},
      {'title': 'Addresses', 'subtitle': 'Pickup & delivery'},
      {'title': 'Shipping', 'subtitle': 'Rates & courier'},
      {'title': 'Payment', 'subtitle': 'Review & pay'},
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Ship a Package'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Show help info
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Shipping Information'),
                      content: const Text(
                        'Fill in the required information to calculate shipping rates and book your shipment. '
                        'You can compare rates from multiple courier partners.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Got it'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Custom progress stepper with titles
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(5, 0, 0, 0),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Progress indicator
                  Row(
                    children: List.generate(
                      steps.length,
                      (index) => Expanded(
                        child: Container(
                          height: 4,
                          margin: EdgeInsets.only(
                            right: index < steps.length - 1 ? 8 : 0,
                          ),
                          decoration: BoxDecoration(
                            color:
                                _currentStep >= index
                                    ? AppTheme.primaryColor
                                    : const Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Step indicators with titles
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      steps.length,
                      (index) => _buildStepIndicator(
                        context,
                        index,
                        _currentStep,
                        title: steps[index]['title'] ?? '',
                        subtitle: steps[index]['subtitle'] ?? '',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main content based on current step
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child:
                    _currentStep == 0
                        ? _buildPackageDetailsContent()
                        : _currentStep == 1
                        ? _buildAddressesContent()
                        : _currentStep == 2
                        ? _buildShippingRatesContent()
                        : _buildPaymentContent(),
              ),
            ),

            // Bottom button bar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(5, 0, 0, 0),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  _currentStep > 0
                      ? SizedBox(
                        width: 120,
                        child: OutlinedButton(
                          onPressed: () {
                            ref.read(currentStepProvider.notifier).state =
                                _currentStep - 1;
                          },
                          style: AppTheme.outlinedButtonStyle,
                          child: const Text('Back'),
                        ),
                      )
                      : const SizedBox(width: 120),
                  // Continue button
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: ElevatedButton(
                        onPressed:
                            _isPlacingOrder
                                ? null // Disable button when placing an order
                                : _navigateToNextStep,
                        style: AppTheme.elevatedButtonStyle,
                        child:
                            _isPlacingOrder
                                ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text('Processing...'),
                                  ],
                                )
                                : Text(
                                  _currentStep < 3 ? 'Continue' : 'Place Order',
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(
    BuildContext context,
    int index,
    int currentStep, {
    required String title,
    required String subtitle,
  }) {
    bool isCompleted = currentStep > index;
    bool isActive = currentStep == index;

    return Expanded(
      child: Column(
        children: [
          // Circle indicator
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isCompleted || isActive
                      ? AppTheme.primaryColor
                      : Colors.white,
              border: Border.all(
                color:
                    isCompleted || isActive
                        ? AppTheme.primaryColor
                        : const Color(0xFFDDDDDD),
                width: 2,
              ),
            ),
            child: Center(
              child:
                  isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : Text(
                        '${index + 1}',
                        style: TextStyle(
                          color:
                              isActive
                                  ? Colors.white
                                  : AppTheme.secondaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
            ),
          ),
          const SizedBox(height: 8),
          // Step title
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color:
                  isActive ? AppTheme.textColor : AppTheme.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          // Step subtitle
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPackageDetailsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Package details section
        _buildSectionHeader(context, 'Package Details'),
        const SizedBox(height: 16),

        // Package details form
        Form(key: _packageFormKey, child: const PackageDetailsForm()),
        const SizedBox(height: 24),

        // Information about the process
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(
              alpha: (0.05 * 255).roundToDouble(),
              red: AppTheme.primaryColor.red.toDouble(),
              green: AppTheme.primaryColor.green.toDouble(),
              blue: AppTheme.primaryColor.blue.toDouble(),
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.primaryColor.withValues(
                alpha: (0.2 * 255).roundToDouble(),
                red: AppTheme.primaryColor.red.toDouble(),
                green: AppTheme.primaryColor.green.toDouble(),
                blue: AppTheme.primaryColor.blue.toDouble(),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, color: AppTheme.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'What happens next?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                '1. Enter pickup and delivery addresses',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 4),
              const Text(
                '2. Choose from available shipping options',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 4),
              const Text(
                '3. Review and place your order',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressesContent() {
    return Consumer(
      builder: (context, ref, child) {
        // Get the current values from the providers
        final pickupAddress = ref.watch(pickupAddressProvider);
        final deliveryAddress = ref.watch(deliveryAddressProvider);

        return Form(
          key: _addressFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pickup Address Section with colored header
              const SizedBox(height: 16),
              AddressForm(
                isPickup: true,
                initialAddress: pickupAddress,
                onAddressCreated: (address) {
                  ref.read(pickupAddressProvider.notifier).state = address;
                },
              ),

              // Delivery Address Section with colored header
              const SizedBox(height: 16),
              AddressForm(
                isPickup: false,
                initialAddress: deliveryAddress,
                onAddressCreated: (address) {
                  ref.read(deliveryAddressProvider.notifier).state = address;
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShippingRatesContent() {
    return Consumer(
      builder: (context, ref, child) {
        final isLoadingCouriers = ref.watch(isLoadingCouriersProvider);
        final availableCouriers = ref.watch(availableCouriersProvider);
        final selectedCourier = ref.watch(selectedCourierProvider);
        final package = ref.watch(packageProvider);
        final pickupAddress = ref.watch(pickupAddressProvider);
        final deliveryAddress = ref.watch(deliveryAddressProvider);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shipping summary header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(
                  alpha: (0.1 * 255).roundToDouble(),
                  red: AppTheme.primaryColor.red.toDouble(),
                  green: AppTheme.primaryColor.green.toDouble(),
                  blue: AppTheme.primaryColor.blue.toDouble(),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.local_shipping,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Shipping Options',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Package & address summary
                  if (package != null &&
                      pickupAddress != null &&
                      deliveryAddress != null) ...[
                    _buildInfoRow(
                      'Package',
                      '${package.weight} kg • ${package.length}×${package.width}×${package.height} cm',
                      Icons.inventory_2_outlined,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'From',
                      '${pickupAddress.name}, ${pickupAddress.city}, ${pickupAddress.postalCode}',
                      Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'To',
                      '${deliveryAddress.name}, ${deliveryAddress.city}, ${deliveryAddress.postalCode}',
                      Icons.location_on,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Shipping rates section title
            _buildSectionHeader(context, 'Available Shipping Options'),
            const SizedBox(height: 16),

            // Loading or courier selection
            if (isLoadingCouriers)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Calculating shipping rates...'),
                  ],
                ),
              )
            else if (availableCouriers.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.not_interested,
                      size: 48,
                      color: AppTheme.secondaryTextColor.withValues(
                        alpha: (0.5 * 255).roundToDouble(),
                        red: AppTheme.secondaryTextColor.red.toDouble(),
                        green: AppTheme.secondaryTextColor.green.toDouble(),
                        blue: AppTheme.secondaryTextColor.blue.toDouble(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No shipping rates available',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please try a different package or address',
                      style: TextStyle(color: AppTheme.secondaryTextColor),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _calculateShippingRates,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            else
              CourierSelection(
                availableCouriers: availableCouriers,
                selectedCourier: selectedCourier,
              ),

            const SizedBox(height: 24),

            // Estimated delivery section
            if (selectedCourier != null) ...[
              _buildSectionHeader(context, 'Delivery Information'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(
                      alpha: (0.1 * 255).roundToDouble(),
                      red: AppTheme.primaryColor.red.toDouble(),
                      green: AppTheme.primaryColor.green.toDouble(),
                      blue: AppTheme.primaryColor.blue.toDouble(),
                    ),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      'Estimated Delivery',
                      selectedCourier.estimatedDelivery,
                      Icons.calendar_today,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      'Courier',
                      selectedCourier.name,
                      Icons.local_shipping_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      'Rating',
                      '${selectedCourier.rating}/5',
                      Icons.star,
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppTheme.secondaryTextColor),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.secondaryTextColor,
                ),
              ),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentContent() {
    return Consumer(
      builder: (context, ref, child) {
        final package = ref.watch(packageProvider);
        final selectedCourier = ref.watch(selectedCourierProvider);
        final totalPrice = ref.watch(totalPriceProvider);
        final paymentMethod = ref.watch(paymentMethodProvider);

        return Form(
          key: _paymentFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context, 'Order Summary'),
              const SizedBox(height: 16),
              PaymentSummary(
                package: package,
                courier: selectedCourier,
                total: totalPrice,
                paymentMethod: paymentMethod,
                onPaymentMethodChanged: (method) {
                  ref.read(paymentMethodProvider.notifier).state = method;
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.headlineMedium);
  }
}
