
import 'package:app1/src/models/category.dart';
import 'package:app1/src/models/product.dart';
import 'package:app1/src/models/restaurant.dart';
import 'package:app1/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:app1/src/pages/client/profile/info/client_profile_info_page.dart';
import 'package:app1/src/pages/client/restaurants/client_restaurants_list_controller.dart';
import 'package:app1/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:app1/src/pages/register/register_page.dart';
import 'package:app1/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:app1/src/utils/custom_animated_bottom_bar.dart';
import 'package:app1/src/widgets/no_data_widget.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ClientRestaurantsListPage extends StatelessWidget {
  
  ClientRestaurantsListController con = Get.put(ClientRestaurantsListController());
 
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
        body: TabBarView(
          children: con.categories.map((Category category) {
            return FutureBuilder(
              future: con.getRestaurants(con.restaurantName.value),
              builder: (context, AsyncSnapshot<List<Restaurant>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Mientras se está cargando la información, puedes mostrar un indicador de carga
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // Si hay un error en la solicitud, muestra un mensaje de error
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // Si no hay datos o la lista está vacía, muestra un mensaje de que no hay productos
                  return NoDataWidget(text: 'No hay restaurantes');
                } else {
                  // Si hay datos disponibles, construye la lista de restaurantes
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) {
                      // Aquí puedes usar los datos del snapshot para construir cada tarjeta de restaurante
                      Restaurant restaurant = snapshot.data![index];
                      return _cardRestaurant(context, Product(), restaurant);
                    },
                  );
                }
              },
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
        child: con.items.value > 0 
        ? Stack(
          children: [
            IconButton(
              onPressed: () => con.goToOrderCreate(), 
              icon: Icon(
                Icons.shopping_bag_outlined,
                size: 35,
              )
            ),
            
            Positioned(
              right: 5,
              top: 12,
              child: Container(
                width: 16,
                height: 16,
                alignment: Alignment.center,
                child: Text(
                  '${con.items.value}',
                  style: TextStyle(
                    fontSize: 12
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(30))
                ),
              )
            )
          ],
        )
        :  IconButton(
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
          onChanged: con.onChangeText,
          decoration: InputDecoration(
            hintText: 'Buscar Restaurantes',
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

 
  //MOSTRAR LAS RESTAURANTES EN UN "CARD"
  Widget _cardRestaurant(
    BuildContext context, 
    Product product, 
    Restaurant restaurant){

    return GestureDetector(

      onTap: () => con.openBottomSheet(context, product),
      
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15, left: 7, right: 7),
            child: ListTile(
              title: Text(restaurant.name ?? ''),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  
                  Text(
                    restaurant.address ?? '',
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 12
                    ),
                  ),
                  SizedBox(height: 10),
                  /*
                  Text(
                    '\$${product.price.toString()}', //PARA MOSTRAR SINGO DE PESOS
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  */
                  SizedBox(height: 20),
                ],
              ),

              trailing: Container(
                height: 70,
                width: 60,
                /*
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
                  
                ),*/
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey[300], indent: 37, endIndent: 37)
        ],
      ),
    );
  }


}
