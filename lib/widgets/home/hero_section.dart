import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../screens/book_shipment_screen.dart';
import '../../providers/order_providers.dart';

class HeroSection extends ConsumerWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEEF1FF), Color(0xFFF4F7FF)],
        ),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fast & reliable shipping',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Compare prices from top couriers and save up to 40%',
            style: TextStyle(fontSize: 16, color: AppTheme.secondaryTextColor),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ref.read(isNewOrderProvider.notifier).state = true;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookShipmentScreen(),
                ),
              );
            },
            style: AppTheme.elevatedButtonStyle,
            child: const Text('Ship Now'),
          ),
        ],
      ),
    );
  }
}
