import 'package:sharpvendor/core/utils/exports.dart';

class OrdersService extends CoreService {
  Future<OrdersService> init() async => this;

  Future<APIResponse> getAllOrders(dynamic data) async {
    return await fetch(
        "/restaurants/orders?${data['page']}&page_size=${data['per_page']}");
  }
  Future<APIResponse> getOrderById(dynamic data) async {
    return await fetch("/restaurants/orders/${data['id']}");
  }


  Future<APIResponse> updateOrder(dynamic data, int orderId) async {
    return await generalPatch("restaurant/orders/$orderId/status", data);
  }


}
