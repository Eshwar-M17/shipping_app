import 'package:flutter/material.dart';
import '../models/shipping_models.dart';
import '../theme/app_theme.dart';

class AddressForm extends StatefulWidget {
  final bool isPickup;
  final Function(Address) onAddressCreated;
  final Address? initialAddress;

  const AddressForm({
    Key? key,
    required this.isPickup,
    required this.onAddressCreated,
    this.initialAddress,
  }) : super(key: key);

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();

  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _contactPhoneController = TextEditingController();

  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialAddress != null) {
      _addressLine1Controller.text = widget.initialAddress!.street;
      _addressLine2Controller.text = widget.initialAddress!.street2;
      _cityController.text = widget.initialAddress!.city;
      _stateController.text = widget.initialAddress!.state;
      _pincodeController.text = widget.initialAddress!.postalCode;
      _contactNameController.text = widget.initialAddress!.name;
      _contactPhoneController.text = widget.initialAddress!.phone;
    }
  }

  @override
  void dispose() {
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _contactNameController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }

  void _submitForm() {
    setState(() {
      _autoValidate =
          true; // Start showing validation errors after first submit attempt
    });

    if (_formKey.currentState!.validate()) {
      final address = Address(
        name: _contactNameController.text,
        street: _addressLine1Controller.text,
        street2: _addressLine2Controller.text,
        city: _cityController.text,
        state: _stateController.text,
        postalCode: _pincodeController.text,
        phone: _contactPhoneController.text,
      );
      widget.onAddressCreated(address);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isPickup
                ? 'Pickup address added successfully'
                : 'Delivery address added successfully',
          ),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppTheme.primaryColor.withValues(
            alpha: (0.1 * 255).roundToDouble(),
            red: AppTheme.primaryColor.r.toDouble(),
            green: AppTheme.primaryColor.g.toDouble(),
            blue: AppTheme.primaryColor.b.toDouble(),
          ),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode:
              _autoValidate
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title with background
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isPickup
                          ? '📦 Pickup Address'
                          : '📍 Delivery Address',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.isPickup
                          ? 'Where to collect your package?'
                          : 'Where is your package going?',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.primaryColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Subtitle with icon
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  children: [
                    Icon(
                      widget.isPickup ? Icons.outbox : Icons.inbox,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.isPickup
                          ? 'Package Sender Details'
                          : 'Package Recipient Details',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Contact Information Section
              const Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contactNameController,
                decoration: const InputDecoration(
                  labelText: 'Contact Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contactPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Contact Phone',
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Address Section
              const Text(
                'Address Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressLine1Controller,
                decoration: const InputDecoration(
                  labelText: 'Address Line 1',
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressLine2Controller,
                decoration: const InputDecoration(
                  labelText: 'Address Line 2 (Optional)',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        prefixIcon: Icon(Icons.location_city),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter city';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      decoration: const InputDecoration(
                        labelText: 'State',
                        prefixIcon: Icon(Icons.map),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter state';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _pincodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Pincode',
                  prefixIcon: Icon(Icons.pin_drop),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pincode';
                  }
                  if (value.length != 6) {
                    return 'Pincode must be 6 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  icon: Icon(
                    widget.isPickup
                        ? Icons.add_location
                        : Icons.delivery_dining,
                  ),
                  label: Text(
                    widget.initialAddress != null
                        ? (widget.isPickup
                            ? 'Update Pickup Address'
                            : 'Update Delivery Address')
                        : (widget.isPickup
                            ? 'Add Pickup Address'
                            : 'Add Delivery Address'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
