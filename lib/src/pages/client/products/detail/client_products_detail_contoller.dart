import 'package:app1/src/models/product.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientProductsDetailController extends GetxController {
  
  
  List<Product> selectedProducts = [];

  ClientProductsDetailController(){}  //CONSTRUCTOR

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

    }else{
      Fluttertoast.showToast(msg: 'Debes de sellecionar al menos un item para agregar');
    }
    
  }

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