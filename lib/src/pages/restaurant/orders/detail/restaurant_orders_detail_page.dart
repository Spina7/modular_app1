import 'dart:ffi';

import 'package:app1/src/models/product.dart';
import 'package:app1/src/models/user.dart';
import 'package:app1/src/pages/restaurant/orders/detail/restaurant_orders_detail_controller.dart';
import 'package:app1/src/utils/relative_time_util.dart';
import 'package:app1/src/widgets/no_data_widget.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantOrdersDetailPage extends StatelessWidget {
  RestaurantOrdersDetailController con =
      Get.put(RestaurantOrdersDetailController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(

      bottomNavigationBar: Container(
        color: Color.fromRGBO(245, 245, 245, 1),
        height: MediaQuery.of(context).size.height * 0.53,
        padding: EdgeInsets.only(top: 15),
        child: Column(
          children: [
            
            _dataDate(),
            _dataClient(),
            _dataAddress(),
            _totalToPay(context),
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

  Widget _dataClient(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Cliente'),
        subtitle: Text('${con.order.client?.name ?? ''} ${con.order.client?.lastname ?? ''} - ${con.order.client?.phone ?? ''}'),
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
          width: double.infinity,
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 30, top: 10),
          child: Text(
            'ASIGNAR REPARTIDOR',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.redAccent
            ),
          ),
        ),
        _dropDownDeliveryMen(con.users),

        Container(
          margin: EdgeInsets.only(left: 15, top: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'TOTAL: \$${con.total.value}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),
              ),
              Container(
              
                margin: EdgeInsets.symmetric(horizontal: 30),
                
                child: ElevatedButton(
                  onPressed: () => con.updateOrder(), 
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10)
                  ),
                  child: Text(
                    'TOMAR ORDEN',
                    style: TextStyle(
                      color: Colors.black
                    ),
                  )
                )
              )
            ],
          ),
        )
        
      ],
    );
  }

  Widget _dropDownDeliveryMen(List<User> users){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 35),
      margin: EdgeInsets.only(top: 15),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down_circle,
            color: Color(0xeaea5153),    
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(

          'Seleccionar repartidor',
          style: TextStyle(
            //color: Colors.black,
            fontSize: 15
          ),
        ),
        items: _dropDownItems(users),
        value: con.idDelivery.value == '' ? null : con.idDelivery.value,
        onChanged: (option){
          print('opcion seleccionada ${option}');
          con.idDelivery.value = option.toString();
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<User> users){
    List<DropdownMenuItem<String>> list = [];

    users.forEach((user) { 
      list.add(DropdownMenuItem(
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              child: FadeInImage(
                image: user.image != null
                      ? NetworkImage(user.image!)
                      : AssetImage('assets/img/no-image.png') as ImageProvider,
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 50),
                placeholder: AssetImage('assets/img/no-image.png'),
              ),
            ),
            SizedBox(width: 15),
            Text(user.name ?? ''),
          ],
        ),
        value: user.id,
      ));
    });

    return list;
  }


}
