

import 'package:app1/src/models/category.dart';
import 'package:app1/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:app1/src/pages/client/profile/info/client_profile_info_page.dart';
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

    
     return DefaultTabController(
       length: con.categories.length,
       child: Scaffold(
         appBar: PreferredSize(
           preferredSize: Size.fromHeight(50),
           child: AppBar(
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.redAccent,
              labelColor: Colors.red,
              unselectedLabelColor: Colors.grey[400],
              tabs: List<Widget>.generate(con.categories.length, (index) {
                return Tab(
                  child: Text(con.categories[index].name ?? ''),
                );
              }),
            ),
           ),
         ),
        body:TabBarView(
          children: con.categories.map((Category category) {
            return Container();
          }).toList(),
        )
        ),
     );
  }


}
