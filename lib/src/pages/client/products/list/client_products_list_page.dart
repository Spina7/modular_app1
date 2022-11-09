

import 'package:app1/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:app1/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:app1/src/pages/register/register_page.dart';
import 'package:app1/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:app1/src/utils/custom_animated_bottom_bar.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


              

class ClientProductsListPage extends StatelessWidget {
  
  ClientProductsListController con = Get.put(ClientProductsListController());

  @override
  Widget build(BuildContext context) {

    
     return Scaffold(

      bottomNavigationBar: _bottomBar(),

      body: Obx(() =>  IndexedStack(
          index: con.indexTab.value,
          children: [
          RestaurantOrdersListPage(),
          DeliveryOrdersListPage(),
          RegisterPage()
          ],
        )
      )
    );
  }

  //

  Widget _bottomBar(){
    return Obx(() => CustomAnimatedBottomBar(
      containerHeight: 70,
      backgroundColor: Colors.amber,
      showElevation: true,  //Sombra 
      itemCornerRadius: 24, //bordes redondeados 
      curve: Curves.easeIn,
      selectedIndex: con.indexTab.value,  //indice seleccionado
      onItemSelected: (index) => con.changeTab(index),
      items: [
        //ELEMENTOS REFLEJADOS DENTRO DEL BOTTOM BAR
        BottomNavyBarItem(
          icon: Icon(Icons.apps), 
          title: Text('HOME'),
          activeColor: Colors.white,
          inactiveColor: Colors.black,
        ),

        BottomNavyBarItem(
          icon: Icon(Icons.list), 
          title: Text('Mis Pedidos'),
          activeColor: Colors.white,
          inactiveColor: Colors.black,
        ),

        BottomNavyBarItem(
          icon: Icon(Icons.person), 
          title: Text('Perfil'),
          activeColor: Colors.white,
          inactiveColor: Colors.black,
        ),


        ],
      )
    );
  }


}
