import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'widgets/home/app_bar.dart';
import 'widgets/home/hero_section.dart';
import 'widgets/home/services_section.dart';
import 'widgets/home/why_choose_us_section.dart';
import 'widgets/home/bottom_nav_bar.dart';

void main() {
  runApp(const ProviderScope(child: ShippingApp()));
}

class ShippingApp extends StatelessWidget {
  const ShippingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shiplee',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const HomeAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            HeroSection(),
            ServicesSection(),
            WhyChooseUsSection(),
          ],
        ),
      ),
      bottomNavigationBar: const HomeBottomNavBar(),
    );
  }
}
