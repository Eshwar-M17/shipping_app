import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shipping_models.dart';
import '../theme/app_theme.dart';
import '../services/shipping_api_service.dart';

class CourierSelection extends ConsumerWidget {
  final List<CourierProvider> availableCouriers;
  final CourierProvider? selectedCourier;

  const CourierSelection({
    Key? key,
    required this.availableCouriers,
    this.selectedCourier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (availableCouriers.isEmpty) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.smallBorderRadius),
            border: Border.all(color: AppTheme.dividerColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline,
                color: AppTheme.secondaryTextColor,
                size: 32,
              ),
              const SizedBox(height: 16),
              const Text(
                'No couriers available',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please calculate shipping rates first or use sample data',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.secondaryTextColor),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children:
          availableCouriers.map((courier) {
            final isSelected = selectedCourier?.id == courier.id;

            return GestureDetector(
              onTap: () {
                // Update selected courier
                ref.read(selectedCourierProvider.notifier).state = courier;
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(
                    AppTheme.smallBorderRadius,
                  ),
                  border: Border.all(
                    color:
                        isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.dividerColor,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected ? AppTheme.boxShadow : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with courier name, logo and rating
                      Row(
                        children: [
                          // Courier logo
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppTheme.dividerColor),
                            ),
                            child: Center(
                              child: Image.asset(
                                courier.logoUrl,
                                width: 36,
                                height: 36,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.local_shipping,
                                    color:
                                        isSelected
                                            ? AppTheme.primaryColor
                                            : AppTheme.secondaryTextColor,
                                    size: 32,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Name and rating
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  courier.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isSelected
                                            ? AppTheme.primaryColor
                                            : AppTheme.textColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    _buildRatingStars(courier.rating),
                                    const SizedBox(width: 8),
                                    Text(
                                      courier.rating.toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Price badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? AppTheme.primaryColor
                                      : AppTheme.accentGreen,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              '₹${(courier.basePrice + courier.pricePerKg).toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppTheme.dividerColor,
                      ),
                      const SizedBox(height: 16),
                      // Price and delivery time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoColumn(
                            title: 'Base Price',
                            value: '₹${courier.basePrice.toStringAsFixed(0)}',
                            icon: Icons.payments_outlined,
                          ),
                          _buildInfoColumn(
                            title: 'Per KG',
                            value: '₹${courier.pricePerKg.toStringAsFixed(0)}',
                            icon: Icons.scale_outlined,
                          ),
                          _buildInfoColumn(
                            title: 'Delivery Time',
                            value: courier.estimatedDelivery,
                            icon: Icons.access_time,
                          ),
                        ],
                      ),
                      if (isSelected) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(
                              alpha: (0.1 * 255).roundToDouble(),
                              red: AppTheme.primaryColor.red.toDouble(),
                              green: AppTheme.primaryColor.green.toDouble(),
                              blue: AppTheme.primaryColor.blue.toDouble(),
                            ),
                            borderRadius: BorderRadius.circular(
                              AppTheme.smallBorderRadius,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: AppTheme.primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Selected Courier',
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildRatingStars(double rating) {
    const int totalStars = 5;
    final int fullStars = rating.floor();
    final bool hasHalfStar = rating - fullStars >= 0.5;

    return Row(
      children: List.generate(totalStars, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.amber, size: 16);
        } else if (index == fullStars && hasHalfStar) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 16);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 16);
        }
      }),
    );
  }

  Widget _buildInfoColumn({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppTheme.secondaryTextColor),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.secondaryTextColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
      ],
    );
  }
}
