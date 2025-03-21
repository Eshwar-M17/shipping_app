import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shipping_models.dart';
import '../theme/app_theme.dart';
import '../services/shipping_api_service.dart';

class PackageDetailsForm extends ConsumerStatefulWidget {
  const PackageDetailsForm({Key? key}) : super(key: key);

  @override
  ConsumerState<PackageDetailsForm> createState() => _PackageDetailsFormState();
}

class _PackageDetailsFormState extends ConsumerState<PackageDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  final _weightController = TextEditingController();
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();

  String _selectedCategory = 'Standard Box';
  double _volumetricWeight = 0.0;
  bool _isCalculatingRates = false;

  final List<String> packageTypes = [
    'Standard Box',
    'Document Envelope',
    'Fragile Package',
    'Electronics',
    'Clothing',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with some default values
    _weightController.text = '1.0';
    _lengthController.text = '30';
    _widthController.text = '20';
    _heightController.text = '10';

    // Calculate volumetric weight on start
    _calculateVolumetricWeight();

    // Create initial package
    _createPackage();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _calculateVolumetricWeight() {
    if (_lengthController.text.isNotEmpty &&
        _widthController.text.isNotEmpty &&
        _heightController.text.isNotEmpty) {
      final length = double.parse(_lengthController.text);
      final width = double.parse(_widthController.text);
      final height = double.parse(_heightController.text);

      setState(() {
        _volumetricWeight = (length * width * height) / 5000;
      });
    }
  }

  void _createPackage() {
    if (_formKey.currentState?.validate() ?? false) {
      final package = Package(
        weight: double.tryParse(_weightController.text) ?? 0,
        length: double.tryParse(_lengthController.text) ?? 0,
        width: double.tryParse(_widthController.text) ?? 0,
        height: double.tryParse(_heightController.text) ?? 0,
        volumetricWeight: _volumetricWeight,
        category: _selectedCategory,
      );

      // Update package provider
      ref.read(packageProvider.notifier).state = package;
    }
  }

  void _calculateShippingRates() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isCalculatingRates = true;
      });

      try {
        final package = Package(
          weight: double.tryParse(_weightController.text) ?? 0,
          length: double.tryParse(_lengthController.text) ?? 0,
          width: double.tryParse(_widthController.text) ?? 0,
          height: double.tryParse(_heightController.text) ?? 0,
          volumetricWeight: _volumetricWeight,
          category: _selectedCategory,
        );

        // Update package provider
        ref.read(packageProvider.notifier).state = package;

        final apiService = ref.read(shippingApiServiceProvider);

        // Get user's postcodes (simplified for now)
        const pickupPostalCode = '110001'; // Example Delhi
        const deliveryPostalCode = '400001'; // Example Mumbai

        // Fetch shipping rates
        await ref
            .read(availableCouriersProvider.notifier)
            .fetchShippingRates(
              package: package,
              pickupPostalCode: pickupPostalCode,
              deliveryPostalCode: deliveryPostalCode,
            );

        // Check if rates were fetched successfully
        final couriers = ref.read(availableCouriersProvider);
        if (couriers.isEmpty) {
          // Show error if no rates found
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'No shipping rates available for this package. Please check your details or try again later.',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Found ${couriers.length} courier options for your package',
                ),
                backgroundColor: AppTheme.successColor,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isCalculatingRates = false;
          });
        }
      }
    }
  }

  Widget _buildSectionTitle(String title, {String? tooltip}) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        if (tooltip != null) ...[
          const SizedBox(width: 4),
          Tooltip(
            message: tooltip,
            child: const Icon(
              Icons.info_outline,
              color: AppTheme.secondaryTextColor,
              size: 16,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoNote(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: AppTheme.secondaryTextColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: AppTheme.boxShadow,
      ),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Package illustration
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(
                      alpha: (0.1 * 255).roundToDouble(),
                      red: AppTheme.primaryColor.red.toDouble(),
                      green: AppTheme.primaryColor.green.toDouble(),
                      blue: AppTheme.primaryColor.blue.toDouble(),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 48,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Package Information',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Package Type selection
              _buildSectionTitle(
                'Package Type',
                tooltip: 'Select the type of package you are shipping',
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                    _createPackage();
                  }
                },
                items:
                    packageTypes.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 24),

              // Weight Section
              _buildSectionTitle('Weight'),
              _buildInfoNote('How much does your package weigh?'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                  suffixText: 'kg',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the weight';
                  }
                  final weight = double.tryParse(value);
                  if (weight == null || weight <= 0) {
                    return 'Please enter a valid weight';
                  }
                  return null;
                },
                onChanged: (value) {
                  _createPackage();
                },
              ),
              const SizedBox(height: 24),

              // Dimensions Section
              _buildSectionTitle('Dimensions'),
              _buildInfoNote('Length × Width × Height in centimeters (cm)'),
              const SizedBox(height: 12),

              // Dimensions Row
              Row(
                children: [
                  // Length
                  Expanded(
                    child: TextFormField(
                      controller: _lengthController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Length',
                        border: OutlineInputBorder(),
                        suffixText: 'cm',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        final length = double.tryParse(value);
                        if (length == null || length <= 0) {
                          return 'Invalid';
                        }
                        return null;
                      },
                      onChanged: (_) {
                        _calculateVolumetricWeight();
                        _createPackage();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Width
                  Expanded(
                    child: TextFormField(
                      controller: _widthController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Width',
                        border: OutlineInputBorder(),
                        suffixText: 'cm',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        final width = double.tryParse(value);
                        if (width == null || width <= 0) {
                          return 'Invalid';
                        }
                        return null;
                      },
                      onChanged: (_) {
                        _calculateVolumetricWeight();
                        _createPackage();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Height
                  Expanded(
                    child: TextFormField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Height',
                        border: OutlineInputBorder(),
                        suffixText: 'cm',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        final height = double.tryParse(value);
                        if (height == null || height <= 0) {
                          return 'Invalid';
                        }
                        return null;
                      },
                      onChanged: (_) {
                        _calculateVolumetricWeight();
                        _createPackage();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Volumetric weight info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(
                    alpha: (0.05 * 255).roundToDouble(),
                    red: AppTheme.primaryColor.red.toDouble(),
                    green: AppTheme.primaryColor.green.toDouble(),
                    blue: AppTheme.primaryColor.blue.toDouble(),
                  ),
                  borderRadius: BorderRadius.circular(8),
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
                    const Text(
                      'Volumetric Weight:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_volumetricWeight.toStringAsFixed(2)} kg',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Shipping cost is calculated based on the higher of actual weight or volumetric weight.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
