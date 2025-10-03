import 'package:sharpvendor/core/utils/exports.dart';

class OrdersService extends CoreService {
  Future<OrdersService> init() async => this;

  Future<APIResponse> getAllOrders(dynamic data) async {
    return await fetch("/restaurants/order");
  }

  Future<APIResponse> getOrderById(dynamic data) async {
    return await fetch("/restaurants/order/${data['id']}");
  }

  Future<APIResponse> updateOrder(dynamic data, int orderId) async {
    return await generalPatch("restaurants/order/$orderId/status", data);
  }
}
