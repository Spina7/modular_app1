import 'dart:async';

import 'package:app1/src/models/category.dart';
import 'package:app1/src/models/product.dart';
import 'package:app1/src/models/restaurant.dart';
import 'package:app1/src/pages/client/products/detail/client_products_detail_page.dart';
import 'package:app1/src/pages/client/restaurants/detail/client_restaurants_detail_contoller.dart';
import 'package:app1/src/pages/client/restaurants/detail/client_restaurants_detail_page.dart';
import 'package:app1/src/providers/categories_provider.dart';
import 'package:app1/src/providers/restaurant_provider.dart';
import 'package:app1/src/providers/products_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientRestaurantsListController extends GetxController {
  CategoriesProvider categoriesProvider = CategoriesProvider();
  RestaurantProvider restaurantProvider = RestaurantProvider();
  ProductsProvider productsProvider = ProductsProvider();

  List<Product> selectedProducts = [];

  List<Restaurant> selectedRestaurants = [];

  List<Category> categories = <Category>[].obs;
  var items = 0.obs;

  List<Restaurant> restaurants = <Restaurant>[].obs;
  var restaurantsItems = 0.obs;

  var restaurantName = ''.obs;
  Timer? searchOnStoppedTyping;

  ClientRestaurantsListController() {
    getCategories();

    //LOS PRODUCTOS ALMACENADOS EN SESION
    if (GetStorage().read('shopping_bag') != null) {
      if (GetStorage().read('shopping_bag') is List<Product>) {
        selectedProducts = GetStorage().read('shopping_bag');
      } else {
        selectedProducts =
            Product.fromJsonList(GetStorage().read('shopping_bag'));
      }

      selectedProducts.forEach((p) {
        items.value = items.value + (p.quantity!);
      });
    }
  }

  void onChangeText(String text) {
    const duration = Duration(milliseconds: 800);
    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping?.cancel();
    }

    searchOnStoppedTyping = Timer(duration, () {
      restaurantName.value = text;
      print('TEXTO COMPLETO ${text}');
    });
  }

  void getCategories() async {
    var result = await categoriesProvider.getAll();
    categories.clear();
    categories.addAll(result);
  }

  //OBTENER RESTAURANTES
  Future<List<Restaurant>> getRestaurants(String restaurantName) async {
    if (restaurantName.isEmpty) {
      return await restaurantProvider.getAll();
    } else {
      return await restaurantProvider.findByName(restaurantName);
    }
  }

  /*
  //OBTENER PRODUCTOS
  Future<List<Product>> getProducts(String idCategory, String productName) async {
    
    if(productName.isEmpty){
      return await productsProvider.findByCategory(idCategory);
    }else{
      return await productsProvider.findByNameAndCategory(idCategory, productName);
    }
    
  }

  
  void goToOrderCreate(){
    Get.toNamed('/client/orders/create');
  }
  */

  void openBottomSheet(BuildContext context, Restaurant restaurant) {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) =>
            ClientRestaurantsDetailPage(restaurant: restaurant));
  }
}
