import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class WhyChooseUsSection extends StatelessWidget {
  const WhyChooseUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      color: const Color(0xFFF7F9FC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Why Choose Shiplee',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildFeatureRow(
            icon: Icons.savings_outlined,
            title: 'Save up to 40%',
            description: 'Get the best shipping rates from top couriers',
          ),
          const SizedBox(height: 16),
          _buildFeatureRow(
            icon: Icons.speed_outlined,
            title: 'Fast Delivery',
            description: 'Guaranteed on-time delivery across India',
          ),
          const SizedBox(height: 16),
          _buildFeatureRow(
            icon: Icons.track_changes_outlined,
            title: 'Real-time Tracking',
            description: 'Track your shipments 24/7 with live updates',
          ),
          const SizedBox(height: 16),
          _buildFeatureRow(
            icon: Icons.support_agent_outlined,
            title: '24/7 Support',
            description: 'Dedicated customer support for all your queries',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color.fromARGB(
              25,
              AppTheme.primaryColor.red,
              AppTheme.primaryColor.green,
              AppTheme.primaryColor.blue,
            ),
            borderRadius: BorderRadius.circular(AppTheme.smallBorderRadius),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: AppTheme.secondaryTextColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
