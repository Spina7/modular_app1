
import 'package:app1/src/models/order.dart';
import 'package:app1/src/pages/restaurant/orders/list/restaurant_orders_list_controller.dart';
import 'package:app1/src/widgets/no_data_widget.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantOrdersListPage extends StatelessWidget {
  
  RestaurantOrdersListController con = Get.put(RestaurantOrdersListController());

  @override
  Widget build(BuildContext context) {

    
    return Obx(() => DefaultTabController(
      length: con.status.length,   //CUANTAS CATEGORIAS VAMOS A MOSTRAR
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(

            bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,   
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[400],
              tabs: List<Widget>.generate(con.status.length, (index) {
                return Tab(
                  child: Text(con.status[index] ),
                );
              }),
            ),
          ),
         ),
        body:TabBarView(
          children: con.status.map((String status) {
            return  FutureBuilder(
              future: con.getOrders(status),
              builder: (context, AsyncSnapshot<List<Order>> snapshot){
                if(snapshot.hasData){ //SI HAY INFORMACION
                  
                  if(snapshot.data!.length > 0){
                    return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (_, index){
                        return _cardOrder(snapshot.data![index]);
                      }
                    );
                  }else{
                    return Center(child: NoDataWidget(text: 'No hay ordenes'));
                  }
 
                } else{
                  return Center(child: NoDataWidget(text: 'No hay ordenes'));
                }
              }
            );
          }).toList(),
        )
      ),
    ));
  }


  Widget _cardOrder(Order order){
    return Container(
      height:150,
      
      child: Card(
        elevation: 3.0,   //UNA PEQUEÑA SOMBRA
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          children: [
            Text(order.id ?? ''),
            Text('${order.timestamp ?? 0}'),
            Text('${order.client?.name ?? ''}'),
            Text('${order.address?.address ?? ''}'),
            
          ],
        ),
      ),
    );
  }

}