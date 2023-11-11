import 'package:app1/src/models/order.dart';
import 'package:app1/src/providers/orders_provider.dart';
import 'package:app1/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RestaurantOrdersListController extends GetxController {
  
  OrdersProvider ordersProvider = OrdersProvider();
  List<String> status = <String>['PAGADO', 'DESPACHADO', 'EN CAMINO', 'ENTREGADO'].obs;

  User user = User.fromJson(GetStorage().read('user') ?? {});

  Future<List<Order>> getOrders(String status) async {
    return await ordersProvider.findByStatus(user.id_restaurant ?? '0', status);
  }

  void goToOrdersDetail(Order order) {
    Get.toNamed('/restaurant/orders/detail', arguments: {
      'order': order.toJson()
    });
  }
}
