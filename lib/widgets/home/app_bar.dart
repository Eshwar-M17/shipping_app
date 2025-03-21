import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          const Icon(
            Icons.local_shipping_outlined,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 8),
          const Text(
            'Shiplee',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () {}, child: const Text('Track Order')),
        IconButton(icon: const Icon(Icons.person_outline), onPressed: () {}),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
