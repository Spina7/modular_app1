import 'dart:ffi';

import 'package:app1/src/models/product.dart';
import 'package:app1/src/models/user.dart';
import 'package:app1/src/pages/client/orders/detail/client_orders_detail_controller.dart';
import 'package:app1/src/pages/delivery/orders/detail/delivery_orders_detail_controller.dart';
import 'package:app1/src/pages/restaurant/orders/detail/restaurant_orders_detail_controller.dart';
import 'package:app1/src/utils/relative_time_util.dart';
import 'package:app1/src/widgets/no_data_widget.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientOrdersDetailPage extends StatelessWidget {


  ClientOrdersDetailController con = Get.put(ClientOrdersDetailController());

  @override
  Widget build(BuildContext context) {
    return Obx(() =>  Scaffold(

      bottomNavigationBar: Container(
        color: Color.fromRGBO(245, 245, 245, 1),
        height: con.order.status == 'EN CAMINO' 
        ? MediaQuery.of(context).size.height *0.42
        : MediaQuery.of(context).size.height *0.38,
        padding:EdgeInsets.only(top: 15),
        child: Column(
          children:  [
             _dataDelivery(),
             _dataAddress(),
             _dataDate(),
            _totalToPay(context)
          ],
        ),
      ),

      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),

        title: Text(
          'Orden #${con.order.id}',
          style: TextStyle(
            color: Colors.black
          ),
        ),
      ),

      body: con.order.products!.isNotEmpty
        ? ListView(
            children: con.order.products!.map((Product product) {
              return _cardProduct(product);
            }).toList(),
        )
        : Center(
            child: NoDataWidget(text: 'No hay ningun producto agragado aun'),
        ),
    ));
  }

  Widget _dataDelivery(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Repartidor y Telefono'),
        subtitle: Text('${con.order.delivery?.name ?? 'No Asignado'} ${con.order.delivery?.lastname ?? ''} - ${con.order.delivery?.phone ?? '###'}'),
        trailing: Icon(
          Icons.person
        ),
      ),
    );
  }


   Widget _dataAddress(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Direccion de entrega'),
        subtitle: Text(con.order.address?.address ?? ''),
        trailing: Icon(
          Icons.location_on
        ),
      ),
    );
  }

   Widget _dataDate(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Fecha del pedido'),
        subtitle: Text('${RelativeTimeUtil.getRelativeTime(con.order.timestamp ?? 0)}'),
        trailing: Icon(
          Icons.timer
        ),
      ),
    );
  }


  Widget _cardProduct(Product product) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _imageProduct(product),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Cantidad:  ${product.quantity}',
                style: TextStyle(
                  fontSize: 13
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _imageProduct(Product product) {
    return Container(
      height: 50,
      width: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FadeInImage(
          image: product.image1 != null
              ? NetworkImage(product.image1!)
              : AssetImage('assets/img/no-image.png') as ImageProvider,
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder: AssetImage('assets/img/no-image.png'),
        ),
      ),
    );
  }

   Widget _totalToPay(BuildContext context){
    return Column(
      children: [
        Divider(height: 1, color: Colors.grey[400]),

         Container(
          margin: EdgeInsets.only(left: 15, top: 25),
          child: Row(
            mainAxisAlignment: con.order.status == 'EN CAMINO' 
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
            children: [
              Text(
                'TOTAL: \$${con.total.value}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),
              ),
              con.order.status == 'EN CAMINO'  
                ? _buttonGoToOrderMap()
                : Container()
            ],
          ),
         )
        
      ],
    );
  }
 

   Widget _buttonGoToOrderMap(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      alignment: Alignment.centerLeft, // ALINEACION A LA IZQUIERDA      
      child: ElevatedButton(
        onPressed: () => con.goToOrderMap(),
        style: ElevatedButton.styleFrom(
          
          padding: EdgeInsets.all(10),
          primary: Colors.lightGreen
        ),
        child: Text(
          'RASTREAR PEDIDO',
          style: TextStyle(
            color: Colors.black
          ),
        )
      )
    );
  }

}
