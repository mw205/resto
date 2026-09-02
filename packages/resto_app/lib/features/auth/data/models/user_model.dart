import 'package:equatable/equatable.dart';

enum UserRole {
  customer,
  driver,
  admin;

  String toJson() => name;
  static UserRole fromJson(String json) {
    switch (json.toLowerCase()) {
      case 'driver':
      case 'delivery':
        return UserRole.driver;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.customer;
    }
  }
}

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? token;
  final List<String> savedAddresses;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.role = UserRole.customer,
    this.token,
    this.savedAddresses = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: json['role'] != null ? UserRole.fromJson(json['role'] as String) : UserRole.customer,
      token: json['token'] as String?,
      savedAddresses: (json['savedAddresses'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.toJson(),
      if (token != null) 'token': token,
      'savedAddresses': savedAddresses,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    String? token,
    List<String>? savedAddresses,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      token: token ?? this.token,
      savedAddresses: savedAddresses ?? this.savedAddresses,
    );
  }

  bool get isDriver => role == UserRole.driver;
  bool get isAdmin => role == UserRole.admin;
  bool get isCustomer => role == UserRole.customer;

  @override
  List<Object?> get props => [id, name, email, phone, role, token, savedAddresses];
}
