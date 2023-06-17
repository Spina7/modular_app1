import 'package:app1/src/models/mercado_pago_card_token.dart';
import 'package:app1/src/models/mercado_pago_installment.dart';
import 'package:app1/src/providers/mercado_pago_provider.dart';
import 'package:get/get.dart';
import 'package:app1/src/models/product.dart';
import 'package:get_storage/get_storage.dart';

class ClientPaymentsInstallmentsController extends GetxController{

  List<Product> selectedProducts = <Product>[].obs;
  List<MercadoPagoInstallment> installmentsList = <MercadoPagoInstallment>[].obs;
  MercadoPagoProvider mercadoPagoProvider = MercadoPagoProvider();
  var total = 0.0.obs;
  var installments = ''.obs;

  MercadoPagoCardToken cardToken = MercadoPagoCardToken.fromJson(Get.arguments[
    'card_token'
  ]);

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
      getInstallments();

    }
  }

  void getInstallments() async {

    if(cardToken.firstSixDigits != null){
      var result = await mercadoPagoProvider.getInstallments(
        cardToken.firstSixDigits!, 
        total.value
      );
      print('Result: ${result}');
      
      if(result.payerCosts != null){
        installmentsList.clear();
        installmentsList.addAll(result.payerCosts!);
      }
    }

  }

  void getTotal(){
    total.value = 0.0;
    selectedProducts.forEach((product) {
      total.value = total.value + (product.quantity! * product.price!);
    });
  }

}