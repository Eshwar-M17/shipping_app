import 'dart:convert';

class Address {
  final String name;
  final String street;
  final String street2;
  final String city;
  final String state;
  final String postalCode;
  final String phone;

  Address({
    required this.name,
    required this.street,
    this.street2 = '',
    required this.city,
    required this.state,
    required this.postalCode,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'street': street,
      'street2': street2,
      'city': city,
      'state': state,
      'postal_code': postalCode,
      'phone': phone,
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      name: json['name'] ?? '',
      street: json['street'] ?? '',
      street2: json['street2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postal_code'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}

class CourierProvider {
  final int id;
  final String name;
  final String logoUrl;
  final double basePrice;
  final double pricePerKg;
  final String estimatedDelivery;
  final double rating;

  CourierProvider({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.basePrice,
    required this.pricePerKg,
    required this.estimatedDelivery,
    required this.rating,
  });

  factory CourierProvider.fromJson(Map<String, dynamic> json) {
    return CourierProvider(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] as int,
      name: json['name'] as String,
      logoUrl: json['logo'] ?? 'assets/logos/default.png',
      basePrice: (json['basePrice'] ?? 0).toDouble(),
      pricePerKg: (json['pricePerKg'] ?? 0).toDouble(),
      estimatedDelivery: json['estimatedDelivery'] ?? '2-3 Days',
      rating: (json['rating'] ?? 4.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo_url': logoUrl,
      'base_price': basePrice,
      'price_per_kg': pricePerKg,
      'estimated_delivery': estimatedDelivery,
      'rating': rating,
    };
  }

  double calculateTotal(double weight) {
    return basePrice + (pricePerKg * weight);
  }
}

class Package {
  final double weight;
  final double length;
  final double width;
  final double height;
  final double volumetricWeight;
  final String category;

  Package({
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    required this.volumetricWeight,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'length': length,
      'width': width,
      'height': height,
      'category': category,
      'volumetric_weight': volumetricWeight,
    };
  }

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      weight: double.parse(json['weight']?.toString() ?? '0'),
      length: double.parse(json['length']?.toString() ?? '0'),
      width: double.parse(json['width']?.toString() ?? '0'),
      height: double.parse(json['height']?.toString() ?? '0'),
      volumetricWeight: double.parse(
        json['volumetric_weight']?.toString() ?? '0',
      ),
      category: json['category'] ?? '',
    );
  }
}

class ShippingOrder {
  final int id;
  final Package package;
  final Address pickupAddress;
  final Address deliveryAddress;
  final CourierProvider courier;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  ShippingOrder({
    required this.id,
    required this.package,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.courier,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  factory ShippingOrder.fromJson(Map<String, dynamic> json) {
    return ShippingOrder(
      id: json['id'],
      package: Package.fromJson(jsonDecode(json['package_details'])),
      pickupAddress: Address.fromJson(jsonDecode(json['pickup_address'])),
      deliveryAddress: Address.fromJson(jsonDecode(json['delivery_address'])),
      courier: CourierProvider.fromJson(json['courier']),
      totalPrice: double.parse(json['total_price']?.toString() ?? '0'),
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'package_details': jsonEncode(package.toJson()),
      'pickup_address': jsonEncode(pickupAddress.toJson()),
      'delivery_address': jsonEncode(deliveryAddress.toJson()),
      'courier_id': courier.id,
      'total_price': totalPrice,
      'status': status,
    };
  }
}
