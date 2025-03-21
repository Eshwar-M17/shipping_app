import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Services',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Reliable shipping solutions for all your needs',
            style: TextStyle(color: AppTheme.secondaryTextColor),
          ),
          const SizedBox(height: 24),
          _buildServiceCards(),
        ],
      ),
    );
  }

  Widget _buildServiceCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildServiceCard(
                icon: Icons.local_shipping_outlined,
                title: 'Domestic Shipping',
                description: 'Ship anywhere in India',
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildServiceCard(
                icon: Icons.flight_takeoff_outlined,
                title: 'International Shipping',
                description: 'Ship to 220+ countries',
                color: AppTheme.accentGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildServiceCard(
                icon: Icons.inventory_2_outlined,
                title: 'Bulk Shipping',
                description: 'For business needs',
                color: AppTheme.accentPink,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildServiceCard(
                icon: Icons.home_work_outlined,
                title: 'Warehouse Services',
                description: 'Storage & fulfillment',
                color: AppTheme.accentYellow,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.smallBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(10, 0, 0, 0),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromARGB(25, color.red, color.green, color.blue),
              borderRadius: BorderRadius.circular(AppTheme.smallBorderRadius),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: AppTheme.secondaryTextColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
