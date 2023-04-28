import 'package:app1/src/models/order.dart';
import 'package:app1/src/pages/client/orders/list/client_orders_list_controller.dart';
import 'package:app1/src/pages/delivery/orders/list/delivery_orders_list_controller.dart';
import 'package:app1/src/pages/restaurant/orders/list/restaurant_orders_list_controller.dart';
import 'package:app1/src/utils/relative_time_util.dart';
import 'package:app1/src/widgets/no_data_widget.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientOrdersListPage extends StatelessWidget {
  
  ClientOrdersListController con = Get.put(ClientOrdersListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => DefaultTabController(
          length: con.status.length, //CUANTAS CATEGORIAS VAMOS A MOSTRAR
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
                        child: Text(con.status[index]),
                      );
                    }),
                  ),
                ),
              ),
              body: TabBarView(
                children: con.status.map((String status) {
                  return FutureBuilder(
                      future: con.getOrders(status),
                      builder: (context, AsyncSnapshot<List<Order>> snapshot) {
                        if (snapshot.hasData) {
                          //SI HAY INFORMACION

                          if (snapshot.data!.length > 0) {
                            return ListView.builder(
                                itemCount: snapshot.data?.length ?? 0,
                                itemBuilder: (_, index) {
                                  return _cardOrder(snapshot.data![index]);
                                });
                          } else {
                            return Center(
                                child: NoDataWidget(text: 'No hay ordenes'));
                          }
                        } else {
                          return Center(
                              child: NoDataWidget(text: 'No hay ordenes'));
                        }
                      });
                }).toList(),
              )),
        ));
  }

  Widget _cardOrder(Order order) {
    return GestureDetector(
      onTap: () => con.goToOrdersDetail(order),
      
      child: Container(
        height: 150,
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        
        child: Card(
          elevation: 3.0, //UNA PEQUEÑA SOMBRA
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),

          child: Stack(
            children: [
              Container(
                  height: 30,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      )
                  ),
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      'Orden #${order.id}',
                      textAlign: TextAlign.center,
                      style:TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 15
                      ),
                    ),
                  )
              ),

              Container(
                margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 5),
                        alignment: Alignment.centerLeft,
                        child: Text('Pedido: ${RelativeTimeUtil.getRelativeTime(order.timestamp ?? 0)}')
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                          'Repartidor: ${order.delivery?.name ?? 'No Asignado'} ${order.delivery?.lastname ?? ''}'),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 5),
                      alignment: Alignment.centerLeft,
                      child:
                          Text('Entregar en: ${order.address?.address ?? ''}'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
