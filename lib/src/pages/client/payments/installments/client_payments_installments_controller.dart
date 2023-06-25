import 'package:app1/src/models/address.dart';
import 'package:app1/src/models/mercado_pago_card_token.dart';
import 'package:app1/src/models/mercado_pago_installment.dart';
import 'package:app1/src/models/mercado_pago_payment_method_installments.dart';
import 'package:app1/src/models/order.dart';
import 'package:app1/src/models/response_api.dart';
import 'package:app1/src/models/user.dart';
import 'package:app1/src/providers/mercado_pago_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:app1/src/models/product.dart';
import 'package:get_storage/get_storage.dart';

class ClientPaymentsInstallmentsController extends GetxController{

  List<Product> selectedProducts = <Product>[].obs;
  MercadoPagoPaymentMethodInstallments? paymentMethodInstallments;
  List<MercadoPagoInstallment> installmentsList = <MercadoPagoInstallment>[].obs;
  MercadoPagoProvider mercadoPagoProvider = MercadoPagoProvider();
  var total = 0.0.obs;
  var installments = ''.obs;
  User user = User.fromJson(GetStorage().read('user') ?? {});

  MercadoPagoCardToken cardToken = MercadoPagoCardToken.fromJson(Get.arguments[
    'card_token'
  ]);

  /*
  String identificationNumber = Get.arguments['identification_number'];
  String identificationType = Get.arguments['identification_type'];
  */

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

  void createPayment() async {

    if(installments.value.isEmpty){
      Get.snackbar('Formulario no valido', 'Selecciona el numero de cuotas');
      return;
    }

    Address a = Address.fromJson(GetStorage().read('address') ?? {});
    List<Product> products = [];

    if(GetStorage().read('shopping_bag') is List<Product>){
      products = GetStorage().read('shopping_bag');
     }else{
      products = Product.fromJsonList(GetStorage().read('shopping_bag'));
     }
    
    Order order = Order(
      idClient: user.id,
      idAddress: a.id,
      products: products
    );

    ResponseApi responseApi = await mercadoPagoProvider.createPayment(
      token: cardToken.id,
      paymentMethodId: paymentMethodInstallments!.paymentMethodId,
      paymentTypedId: paymentMethodInstallments!.paymentTypeId,
      issuerId: paymentMethodInstallments!.issuer!.id,
      transactionAmount: total.value,
      installments: int.parse(installments.value),
      emailCustomer: user.email,
      order: order
      //identificationNumber: identificationNumber,
      //identificationType: identificationType,
    );

    Fluttertoast.showToast(msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);

    if(responseApi.success == true){
      GetStorage().remove('shopping_bag'); 
    }

    Get.toNamed('/client/payments/status');//PANTALLA DEL ESTADO FINAL DE LA TRANSACCION
  }

  void getInstallments() async {

    if(cardToken.firstSixDigits != null){
      var result = await mercadoPagoProvider.getInstallments(
        cardToken.firstSixDigits!, 
        total.value
      );
      paymentMethodInstallments = result;
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