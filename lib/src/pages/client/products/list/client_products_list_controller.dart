
import 'package:app1/src/models/category.dart';
import 'package:app1/src/models/product.dart';
import 'package:app1/src/pages/client/products/detail/client_products_detail_page.dart';
import 'package:app1/src/providers/categories_provider.dart';
import 'package:app1/src/providers/products_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientProductsListController extends GetxController {

  CategoriesProvider categoriesProvider = CategoriesProvider();
  ProductsProvider productsProvider = ProductsProvider();

  List<Product> selectedProducts = [];
  
  List<Category> categories = <Category>[].obs;
  var items = 0.obs;
  
  
  ClientProductsListController(){
    getCategories();

    //LOS PRODUCTOS ALMACENADOS EN SESION 
    if(GetStorage().read('shopping_bag') != null){

      if(GetStorage().read('shopping_bag') is List<Product>){
        selectedProducts = GetStorage().read('shopping_bag');
      }else{
        selectedProducts = Product.fromJsonList(GetStorage().read('shopping_bag'));
      }

      selectedProducts.forEach((p) { 
        items.value = items.value + (p.quantity!);
      });

    }

  }

  void getCategories() async {
    var result = await categoriesProvider.getAll();
    categories.clear();
    categories.addAll(result);
  }

  //OBTENER PRODUCTOS
  Future<List<Product>> getProducts(String idCategory) async {
    return await productsProvider.findByCategory(idCategory);
  }

  void goToOrderCreate(){
    Get.toNamed('/client/orders/create');
  }

  void openBottomSheet(BuildContext context, Product product){
    showMaterialModalBottomSheet(
      context: context, 
      builder: (context) => ClientProductsDetailPage(product: product)
    );
  }

  
}