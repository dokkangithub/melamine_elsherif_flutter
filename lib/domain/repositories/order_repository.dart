import 'package:melamine_elsherif/domain/entities/order.dart';

/// Repository interface for handling order operations
abstract class OrderRepository {
  /// Get a list of orders for the current user
  /// [limit] - Maximum number of orders to return
  /// [offset] - Number of orders to skip for pagination
  /// Returns a list of [Order]
  Future<List<Order>> getOrders({
    int limit = 10,
    int offset = 0,
  });

  /// Get an order by ID
  /// [id] - The order ID
  /// Returns the [Order] if found, otherwise null
  Future<Order?> getOrderById(String id);

  /// Get an order by cart ID
  /// [cartId] - The cart ID
  /// Returns the [Order] if found, otherwise null
  Future<Order?> getOrderByCartId(String cartId);

  /// Cancel an order
  /// [orderId] - The order ID
  /// Returns true if the order was cancelled successfully
  Future<bool> cancelOrder(String orderId);

  /// Create a return for an order
  /// [orderId] - The order ID
  /// [items] - Map of item IDs and quantities to return
  /// [returnReason] - Reason for the return
  /// Returns the return ID if successful
  Future<String> createReturn({
    required String orderId,
    required Map<String, int> items,
    required String returnReason,
  });

  /// Track an order
  /// [orderId] - The order ID
  /// Returns the tracking information
  Future<Map<String, dynamic>> trackOrder(String orderId);
} 