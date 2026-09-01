import 'package:equatable/equatable.dart';
import 'package:resto/core/widgets/status_chip.dart';
import 'package:resto/features/cart/data/models/cart_item_model.dart';

enum OrderType {
  delivery,
  takeaway;

  String toJson() => name;
  static OrderType fromJson(String json) {
    return json.toLowerCase() == 'takeaway' ? OrderType.takeaway : OrderType.delivery;
  }
}

enum OrderStatus {
  received,
  preparing,
  onTheWay,
  readyForPickup,
  delivered,
  cancelled;

  String toJson() => name;
  static OrderStatus fromJson(String json) {
    switch (json.toLowerCase()) {
      case 'preparing':
        return OrderStatus.preparing;
      case 'ontheway':
      case 'on_the_way':
        return OrderStatus.onTheWay;
      case 'readyforpickup':
      case 'ready_for_pickup':
        return OrderStatus.readyForPickup;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.received;
    }
  }

  OrderStatusType get chipType {
    switch (this) {
      case OrderStatus.received:
        return OrderStatusType.received;
      case OrderStatus.preparing:
        return OrderStatusType.preparing;
      case OrderStatus.onTheWay:
        return OrderStatusType.onTheWay;
      case OrderStatus.readyForPickup:
        return OrderStatusType.readyForPickup;
      case OrderStatus.delivered:
        return OrderStatusType.delivered;
      case OrderStatus.cancelled:
        return OrderStatusType.cancelled;
    }
  }

  String get arabicTitle {
    switch (this) {
      case OrderStatus.received:
        return 'تم استلام الطلب';
      case OrderStatus.preparing:
        return 'قيد التحضير بالمطبخ';
      case OrderStatus.onTheWay:
        return 'في الطريق إليك';
      case OrderStatus.readyForPickup:
        return 'جاهز للاستلام من الفرع';
      case OrderStatus.delivered:
        return 'تم التسليم بنجاح';
      case OrderStatus.cancelled:
        return 'ملغي';
    }
  }
}

class OrderModel extends Equatable {
  final String id;
  final String orderNumber;
  final List<CartItemModel> items;
  final OrderType orderType;
  final OrderStatus status;
  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double tax;
  final double total;
  final String deliveryAddress;
  final String pickupBranch;
  final String customerName;
  final String customerPhone;
  final String? customerNotes;
  final String? driverId;
  final String? driverName;
  final String? driverPhone;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final double? rating;
  final String? reviewComment;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.items,
    this.orderType = OrderType.delivery,
    this.status = OrderStatus.received,
    required this.subtotal,
    this.discount = 0.0,
    this.deliveryFee = 25.0,
    this.tax = 0.0,
    required this.total,
    this.deliveryAddress = 'القاهرة - مصر الجديدة - شارع الثورة',
    this.pickupBranch = 'فرع التجمع الخامس - مول بوينت 90',
    this.customerName = 'عميل ريستو',
    this.customerPhone = '01012345678',
    this.customerNotes,
    this.driverId,
    this.driverName,
    this.driverPhone,
    required this.createdAt,
    this.deliveredAt,
    this.rating,
    this.reviewComment,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String? ?? '',
      orderNumber: json['orderNumber'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      orderType: json['orderType'] != null
          ? OrderType.fromJson(json['orderType'] as String)
          : OrderType.delivery,
      status: json['status'] != null
          ? OrderStatus.fromJson(json['status'] as String)
          : OrderStatus.received,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 25.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      deliveryAddress: json['deliveryAddress'] as String? ?? '',
      pickupBranch: json['pickupBranch'] as String? ?? '',
      customerName: json['customerName'] as String? ?? '',
      customerPhone: json['customerPhone'] as String? ?? '',
      customerNotes: json['customerNotes'] as String?,
      driverId: json['driverId'] as String?,
      driverName: json['driverName'] as String?,
      driverPhone: json['driverPhone'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      deliveredAt: json['deliveredAt'] != null
          ? DateTime.parse(json['deliveredAt'] as String)
          : null,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewComment: json['reviewComment'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'items': items.map((e) => e.toJson()).toList(),
      'orderType': orderType.toJson(),
      'status': status.toJson(),
      'subtotal': subtotal,
      'discount': discount,
      'deliveryFee': deliveryFee,
      'tax': tax,
      'total': total,
      'deliveryAddress': deliveryAddress,
      'pickupBranch': pickupBranch,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerNotes': customerNotes,
      'driverId': driverId,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'createdAt': createdAt.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'rating': rating,
      'reviewComment': reviewComment,
    };
  }

  OrderModel copyWith({
    String? id,
    String? orderNumber,
    List<CartItemModel>? items,
    OrderType? orderType,
    OrderStatus? status,
    double? subtotal,
    double? discount,
    double? deliveryFee,
    double? tax,
    double? total,
    String? deliveryAddress,
    String? pickupBranch,
    String? customerName,
    String? customerPhone,
    String? customerNotes,
    String? driverId,
    String? driverName,
    String? driverPhone,
    DateTime? createdAt,
    DateTime? deliveredAt,
    double? rating,
    String? reviewComment,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      items: items ?? this.items,
      orderType: orderType ?? this.orderType,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      pickupBranch: pickupBranch ?? this.pickupBranch,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerNotes: customerNotes ?? this.customerNotes,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      createdAt: createdAt ?? this.createdAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      rating: rating ?? this.rating,
      reviewComment: reviewComment ?? this.reviewComment,
    );
  }

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        items,
        orderType,
        status,
        subtotal,
        discount,
        deliveryFee,
        tax,
        total,
        deliveryAddress,
        pickupBranch,
        customerName,
        customerPhone,
        customerNotes,
        driverId,
        driverName,
        driverPhone,
        createdAt,
        deliveredAt,
        rating,
        reviewComment,
      ];
}
