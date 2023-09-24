import 'package:app1/src/models/product.dart';
import 'package:app1/src/models/restaurant.dart';
import 'package:app1/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:app1/src/providers/products_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientRestaurantsDetailController extends GetxController {
  
  
  List<Restaurant> selectedRestaurants = [];
  ClientRestaurantsDetailController clientRestaurantDetailController = Get.find();

  ProductsProvider productsProvider = ProductsProvider();

  List<Product> selectedProducts = [];

  ClientRestaurantsDetailController(){}  //CONSTRUCTOR

  /*
  void checkIfProductsWasAdded(Product product, var price, var counter){
     price.value = product.price ?? 0.0 ;

    //LOS PRODUCTOS ALMACENADOS EN SESION 
    if(GetStorage().read('shopping_bag') != null){

      if(GetStorage().read('shopping_bag') is List<Product>){
        selectedProducts = GetStorage().read('shopping_bag');
      }else{
        selectedProducts = Product.fromJsonList(GetStorage().read('shopping_bag'));
      }

      int index = selectedProducts.indexWhere((p) => p.id == product.id);

      if(index != -1){  //EL PRODUCTO YA FUE AGREGADO 

        counter.value = selectedProducts[index].quantity ?? 0;
        price.value = product.price! * counter.value;
      
        selectedProducts.forEach((p) { 
          print('Producto: ${p.toJson()}');
        });

      }

    }

  }
  */

  /*
  void addToBag(Product product, var price, var counter){

    if(counter.value > 0){

      //VALIDAR SI EL PRODUCTO YA FUE AGREGADO CON GETSTORAGE A LA SESION DEL DISPOSITIVO
      int index = selectedProducts.indexWhere((p) => p.id == product.id);

      if(index == -1){  //NO HA SIDO AGREGADO
        if(product.quantity == null){
          if(counter.value > 0){
            product.quantity  = counter.value;
          }else{
            product.quantity = 1;
          }
        }

        selectedProducts.add(product);
      }else{    //YA HA SIGO AGREGADO EN STORAGE 
        selectedProducts[index].quantity = counter.value;
      }

      GetStorage().write('shopping_bag', selectedProducts);
      Fluttertoast.showToast(msg: 'Producto agregado');
      
      productsListController.items.value = 0;
      selectedProducts.forEach((p) { 
        productsListController.items.value = productsListController.items.value + (p.quantity!);
      });

    }else{
      Fluttertoast.showToast(msg: 'Debes de sellecionar al menos un item para agregar');
    }
    
  }
  */

  void addItem(Product product, var price, var counter){
    counter.value = counter.value + 1; 
    price.value = product.price! * counter.value;
  }
  

  void removeItem(Product product, var price, var counter){
    if(counter.value > 0){
      counter.value = counter.value - 1; 
      price.value = product.price! * counter.value;
    }
  }

}