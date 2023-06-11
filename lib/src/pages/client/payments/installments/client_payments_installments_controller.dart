import 'package:app1/src/models/mercado_pago_installment.dart';
import 'package:get/get.dart';
import 'package:app1/src/models/product.dart';
import 'package:get_storage/get_storage.dart';

class ClientPaymentsInstallmentsController extends GetxController{

  List<Product> selectedProducts = <Product>[].obs;
  List<MercadoPagoInstallment> installmentsList = <MercadoPagoInstallment>[].obs;
  var total = 0.0.obs;
  var installments = ''.obs;

  ClientPaymentsInstallmentsController(){
    //LOS PRODUCTOS ALMACENADOS EN SESION 
    if(GetStorage().read('shopping_bag') != null){

      if(GetStorage().read('shopping_bag') is List<Product>){
        var result = GetStorage().read('shopping_bag');
        selectedProducts.clear();
        selectedProducts.addAll(result);
      }else{
        var result = Product.fromJsonList(GetStorage().read('shopping_bag'));
        selectedProducts.clear();
        selectedProducts.addAll(result);
      }

      getTotal();

    }
  }

 void getTotal(){
    total.value = 0.0;
    selectedProducts.forEach((product) {
      total.value = total.value + (product.quantity! * product.price!);
    });
  }

}