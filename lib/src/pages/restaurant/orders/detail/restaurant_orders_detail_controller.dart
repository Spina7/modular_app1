import 'package:app1/src/models/order.dart';
import 'package:get/get.dart';

class RestaurantOrdersDetailController extends GetxController {
  Order order = Order.fromJson(Get.arguments['order']);

  var total = 0.0.obs;

  RestaurantOrdersDetailController() {
    print('Order: ${order.toJson()}');
    getTotal();
  }

  void getTotal(){
    total.value = 0.0;
    order.products!.forEach((product) {
      total.value = total.value + (product.quantity! * product.price!);
    });
  }
}
