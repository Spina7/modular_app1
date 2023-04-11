import 'package:app1/src/models/order.dart';
import 'package:app1/src/models/user.dart';
import 'package:app1/src/providers/orders_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DeliveryOrdersListController extends GetxController {
  
  OrdersProvider ordersProvider = OrdersProvider(); //EL REPARTIDOR NO CUENTA CON EL STATUS 'PAGADO'
  List<String> status = <String>['DESPACHADO', 'EN CAMINO', 'ENTREGADO'].obs;

  User user = User.fromJson(GetStorage().read('user') ?? {});
  
  Future<List<Order>> getOrders(String status) async {
    return await ordersProvider.findByDeliveryAndStatus(user.id ?? '0', status);
  }

  void goToOrdersDetail(Order order) {
    Get.toNamed('/delivery/orders/detail', arguments: {
      'order': order.toJson()
    });
  }
}
