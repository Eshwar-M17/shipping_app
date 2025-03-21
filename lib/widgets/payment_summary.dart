import 'package:flutter/material.dart';
import '../models/shipping_models.dart';
import '../theme/app_theme.dart';

class PaymentSummary extends StatelessWidget {
  final Package? package;
  final CourierProvider? courier;
  final double total;
  final String paymentMethod;
  final Function(String) onPaymentMethodChanged;

  const PaymentSummary({
    Key? key,
    this.package,
    this.courier,
    required this.total,
    required this.paymentMethod,
    required this.onPaymentMethodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Payment Method Selection
            Row(
              children: [
                Radio<String>(
                  value: 'Cash On Delivery',
                  groupValue: paymentMethod,
                  activeColor: AppTheme.primaryColor,
                  onChanged: (value) {
                    if (value != null) {
                      onPaymentMethodChanged(value);
                    }
                  },
                ),
                const Text(
                  'Cash On Delivery',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Radio<String>(
                  value: 'Prepaid',
                  groupValue: paymentMethod,
                  activeColor: AppTheme.primaryColor,
                  onChanged: (value) {
                    if (value != null) {
                      onPaymentMethodChanged(value);
                    }
                  },
                ),
                const Text(
                  'Prepaid',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),

            const Divider(height: 32),

            // Price Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.secondaryTextColor,
                  ),
                ),
                Text(
                  '₹ ${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'GST (18%)',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.secondaryTextColor,
                  ),
                ),
                Text(
                  '₹ ${(total * 0.18).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Divider(height: 32),

            // Total Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppTheme.secondaryTextColor,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                Text(
                  '₹ ${(total * 1.18).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Next Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Handle payment processing and move to confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing payment...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
