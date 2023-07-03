import 'package:app1/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:get/get.dart';
import 'package:app1/src/models/product.dart';
import 'package:get_storage/get_storage.dart';

class ClientOrdersCreateController extends GetxController {

  List<Product> selectedProducts = <Product>[].obs;
  var total = 0.0.obs;
  ClientProductsListController productsListController = Get.find();

  ClientOrdersCreateController (){

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

  void deleteItem(Product product){
    selectedProducts.remove(product);
    GetStorage().write('shopping_bag', selectedProducts);
    getTotal();
    productsListController.items.value = 0;
    if(selectedProducts.length == 0){
      productsListController.items.value = 0;
    }else{
      selectedProducts.forEach((p) { 
        productsListController.items.value = productsListController.items.value + (p.quantity!);
      });
    }

  }

  void addItem(Product product){
    //VALIDAR SI EL PRODUCTO YA FUE AGREGADO CON GETSTORAGE A LA SESION DEL DISPOSITIVO
    int index = selectedProducts.indexWhere((p) => p.id == product.id);
    selectedProducts.remove(product);
    product.quantity = product.quantity! + 1;
    selectedProducts.insert(index, product);
    GetStorage().write('shopping_bag', selectedProducts);
    getTotal();
    productsListController.items.value = 0;
    selectedProducts.forEach((p) { 
        productsListController.items.value = productsListController.items.value + (p.quantity!);
    });

  }

  void removeItem(Product product){
    if(product.quantity! > 1){
      //VALIDAR SI EL PRODUCTO YA FUE AGREGADO CON GETSTORAGE A LA SESION DEL DISPOSITIVO
      int index = selectedProducts.indexWhere((p) => p.id == product.id);
      selectedProducts.remove(product);
      product.quantity = product.quantity! - 1;
      selectedProducts.insert(index, product);
      GetStorage().write('shopping_bag', selectedProducts);
      getTotal();
      productsListController.items.value = 0;
      selectedProducts.forEach((p) { 
        productsListController.items.value = productsListController.items.value + (p.quantity!);
      });

    }
  }

  void goToAddressList(){
    Get.toNamed('/client/address/list');
  }

}