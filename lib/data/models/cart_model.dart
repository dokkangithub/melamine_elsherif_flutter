import 'package:melamine_elsherif/data/models/address_model.dart';
import 'package:melamine_elsherif/data/models/customer_model.dart';
import 'package:melamine_elsherif/data/models/discount_model.dart';
import 'package:melamine_elsherif/data/models/line_item_model.dart';
import 'package:melamine_elsherif/data/models/region_model.dart';
import 'package:melamine_elsherif/data/models/shipping_method_model.dart';
import 'package:melamine_elsherif/domain/entities/cart.dart';

/// Model class for cart data from the API
class CartModel extends Cart {
  /// Creates a [CartModel] instance
  const CartModel({
    required String id,
    String? email,
    AddressModel? billingAddress,
    AddressModel? shippingAddress,
    required List<LineItemModel> items,
    RegionModel? region,
    String? regionId,
    List<DiscountModel>? discounts,
    List<String>? giftCardIds,
    CustomerModel? customer,
    String? customerId,
    List<String>? paymentProviders,
    List<ShippingMethodModel>? shippingMethods,
    String? paymentSession,
    Map<String, dynamic>? paymentSessions,
    String? type,
    String? orderId,
    double? subtotal,
    double? taxTotal,
    double? shippingTotal,
    double? discountTotal,
    double? giftCardTotal,
    double? total,
    Map<String, dynamic>? metadata,
    String? salesChannelId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? completedAt,
    DateTime? deletedAt,
  }) : super(
          id: id,
          email: email,
          billingAddress: billingAddress,
          shippingAddress: shippingAddress,
          items: items,
          region: region,
          regionId: regionId,
          discounts: discounts,
          giftCardIds: giftCardIds,
          customer: customer,
          customerId: customerId,
          paymentProviders: paymentProviders,
          shippingMethods: shippingMethods,
          paymentSession: paymentSession,
          paymentSessions: paymentSessions,
          type: type,
          orderId: orderId,
          subtotal: subtotal,
          taxTotal: taxTotal,
          shippingTotal: shippingTotal,
          discountTotal: discountTotal,
          giftCardTotal: giftCardTotal,
          total: total,
          metadata: metadata,
          salesChannelId: salesChannelId,
          createdAt: createdAt,
          updatedAt: updatedAt,
          completedAt: completedAt,
          deletedAt: deletedAt,
        );

  /// Creates a [CartModel] instance from JSON data
  factory CartModel.fromJson(Map<String, dynamic> json) {
    final List<LineItemModel> items = [];
    if (json['items'] != null) {
      for (final item in json['items']) {
        items.add(LineItemModel.fromJson(item));
      }
    }

    final List<DiscountModel>? discounts = json['discounts'] != null
        ? (json['discounts'] as List)
            .map((discount) => DiscountModel.fromJson(discount))
            .toList()
        : null;

    final List<ShippingMethodModel>? shippingMethods =
        json['shipping_methods'] != null
            ? (json['shipping_methods'] as List)
                .map((method) => ShippingMethodModel.fromJson(method))
                .toList()
            : null;

    final List<String>? giftCardIds = json['gift_cards'] != null
        ? (json['gift_cards'] as List)
            .map((card) => card['id'] as String)
            .toList()
        : null;

    return CartModel(
      id: json['id'],
      email: json['email'],
      billingAddress: json['billing_address'] != null
          ? AddressModel.fromJson(json['billing_address'])
          : null,
      shippingAddress: json['shipping_address'] != null
          ? AddressModel.fromJson(json['shipping_address'])
          : null,
      items: items,
      region: json['region'] != null ? RegionModel.fromJson(json['region']) : null,
      regionId: json['region_id'],
      discounts: discounts,
      giftCardIds: giftCardIds,
      customer: json['customer'] != null
          ? CustomerModel.fromJson(json['customer'])
          : null,
      customerId: json['customer_id'],
      paymentProviders: json['payment_providers'] != null
          ? (json['payment_providers'] as List).cast<String>()
          : null,
      shippingMethods: shippingMethods,
      paymentSession: json['payment_session'],
      paymentSessions: json['payment_sessions'],
      type: json['type'],
      orderId: json['order_id'],
      subtotal: _parseDouble(json['subtotal']),
      taxTotal: _parseDouble(json['tax_total']),
      shippingTotal: _parseDouble(json['shipping_total']),
      discountTotal: _parseDouble(json['discount_total']),
      giftCardTotal: _parseDouble(json['gift_card_total']),
      total: _parseDouble(json['total']),
      metadata: json['metadata'],
      salesChannelId: json['sales_channel_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      deletedAt:
          json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }

  /// Converts this model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'billing_address': billingAddress != null
          ? (billingAddress as AddressModel).toJson()
          : null,
      'shipping_address': shippingAddress != null
          ? (shippingAddress as AddressModel).toJson()
          : null,
      'items': items
          .map((item) => (item as LineItemModel).toJson())
          .toList(),
      'region': region != null ? (region as RegionModel).toJson() : null,
      'region_id': regionId,
      'discounts': discounts != null
          ? discounts!
              .map((discount) => (discount as DiscountModel).toJson())
              .toList()
          : null,
      'customer': customer != null ? (customer as CustomerModel).toJson() : null,
      'customer_id': customerId,
      'payment_session': paymentSession,
      'payment_sessions': paymentSessions,
      'shipping_methods': shippingMethods != null
          ? shippingMethods!
              .map((method) => (method as ShippingMethodModel).toJson())
              .toList()
          : null,
      'type': type,
      'order_id': orderId,
      'subtotal': subtotal,
      'tax_total': taxTotal,
      'shipping_total': shippingTotal,
      'discount_total': discountTotal,
      'gift_card_total': giftCardTotal,
      'total': total,
      'metadata': metadata,
      'sales_channel_id': salesChannelId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  /// Helper method to parse double values from JSON
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value);
    return null;
  }
} 