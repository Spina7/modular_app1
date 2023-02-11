
import 'package:app1/src/models/category.dart';
import 'package:app1/src/models/product.dart';
import 'package:app1/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:app1/src/pages/client/profile/info/client_profile_info_page.dart';
import 'package:app1/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:app1/src/pages/register/register_page.dart';
import 'package:app1/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:app1/src/utils/custom_animated_bottom_bar.dart';
import 'package:app1/src/widgets/no_data_widget.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ClientProductsListPage extends StatelessWidget {
  
  ClientProductsListController con = Get.put(ClientProductsListController());

  @override
  Widget build(BuildContext context) {

    
    return Obx(() => DefaultTabController(
      length: con.categories.length,   //CUANTAS CATEGORIAS VAMOS A MOSTRAR
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: AppBar(

            flexibleSpace: Container(
              margin: EdgeInsets.only(top: 15),
              alignment: Alignment.topCenter,
              child:  Wrap(
                direction: Axis.horizontal,
                children: [
                  _textFieldSearch(context),
                  _iconShoppingBag()
                ],
              ),
            ),

            bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,   
              labelColor: Colors.black,
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
            return  FutureBuilder(
              future: con.getProducts(category.id ?? '1'),
              builder: (context, AsyncSnapshot<List<Product>> snapshot){
                if(snapshot.hasData){ //SI HAY INFORMACION
                  
                  if(snapshot.data!.length > 0){
                    return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (_, index){
                        return _cardProduct(context, snapshot.data![index]);
                      }
                    );
                  }else{
                    return NoDataWidget(text: 'No hay productos');
                  }
 
                } else{
                  return NoDataWidget(text: 'No hay productos');
                }
              }
            );
          }).toList(),
        )
      ),
    ));
  }

  Widget _iconShoppingBag(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 10),
        child: IconButton(
          onPressed: () => con.goToOrderCreate(), 
          icon: Icon(
            Icons.shopping_bag_outlined,
            size: 30,
          )
        ), 
      ),
    );
  }

  Widget _textFieldSearch(BuildContext context){    //BARRA DE BUSQUEDA
    return SafeArea(
      child: Container(

        width: MediaQuery.of(context).size.width * 0.75,

        child: TextField(
          decoration: InputDecoration(
            hintText: 'Buscar Producto',
            suffixIcon: Icon(Icons.search, color: Colors.grey),
            hintStyle: TextStyle(
              fontSize: 17,
              color: Colors.grey
            ),

            fillColor: Colors.white,    //FALTA AJUSTAR COLOR
            filled: true,

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey)
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey)
            ),
            contentPadding: EdgeInsets.all(15)
          ),
        ),
      )
    );
  }



  //MOSTRAR LAS PRODUCTOS EN UN "CARD"
  Widget _cardProduct(BuildContext context, Product product){
    return GestureDetector(

      onTap: () => con.openBottomSheet(context, product),

      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15, left: 20, right: 20),
            child: ListTile(
              title: Text(product.name ?? ''),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    product.description ?? '',
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 12
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '\$${product.price.toString()}', //PARA MOSTRAR SINGO DE PESOS
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),

              trailing: Container(
                height: 70,
                width: 60,
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
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey[300], indent: 37, endIndent: 37)
        ],
      ),
    );
  }


}
