import 'package:app1/src/models/product.dart';
import 'package:app1/src/models/restaurant.dart';
import 'package:app1/src/pages/client/products/detail/client_products_detail_contoller.dart';
import 'package:app1/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:app1/src/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:app1/src/models/category.dart';

class ClientRestaurantsDetailPage extends StatelessWidget {
  
  Product? product;
  Restaurant? restaurant;

  ClientProductsListController conProduct = Get.put(ClientProductsListController());

 

  late ClientProductsDetailController con;

  var counter = 0.obs;  
  var price = 0.0.obs;
 


  ClientRestaurantsDetailPage({@required this.restaurant}){}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: conProduct.categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(restaurant?.name ?? ''),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey[400],
            tabs: conProduct.categories.map((Category category) {
              return Tab(
                child: Text(category.name ?? ''),
              );
            }).toList(),
          ),
        ),
        body: Column(
          children: [
            _imageSlideshow(context),
            _textAddressRestaurant(),
            _textHourDetail(),
            Expanded(
              child: TabBarView(
                children: conProduct.categories.map((Category category) {
                  return FutureBuilder(
                    future: conProduct.getProducts(category.id ?? '1', conProduct.productName.value),
                    builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return NoDataWidget(text: 'No hay productos');
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, index) {
                            return _cardProduct(context, snapshot.data![index]);
                          },
                        );
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(BuildContext context) {
    final conProduct = Get.put(ClientProductsListController());

    return Expanded(
      child: Obx(() => FutureBuilder(
        future: conProduct.getProducts('2', conProduct.productName.value),
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading indicator while fetching data.
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return NoDataWidget(text: 'No hay productos');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                return _cardProduct(context, snapshot.data![index]);
              },
            );
          }
        },
      )),
    );
  }
  
  Widget _textNameRestaurant() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10 ),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        restaurant?.name ?? '',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black,
        ),
      ),
    );
  }
  
  
  Widget _textAddressRestaurant() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        restaurant?.address ?? '',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }


  Widget _textHourDetail() {
    final initialWorkingHour = restaurant?.initial_working_hour;
    final formattedHour = initialWorkingHour != null
      ? DateFormat('HH:mm:ss').format(DateTime.parse(initialWorkingHour))
      : '';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        formattedHour,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }


  Widget _buttonsAddToBag(){
    return Column(
      children: [
        Divider(
          height: 1,
          color: Colors.grey[400],
        ),

        Container(

          margin: EdgeInsets.only(left: 20, right: 20, top: 25),

          child: Row(
            children: [

              ElevatedButton(   //BOTON - (MENOS)
                onPressed: () => con.removeItem(product!, price, counter), 
                child: Text(
                  '-',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  minimumSize: Size(45, 37),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(25), 
                    )
                  )
                ),
              ),

              ElevatedButton(
                onPressed: (){}, 
                child: Text(
                  '${counter.value}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  minimumSize: Size(40, 37)
                ),
              ),

              ElevatedButton(     //BOTON + (MAS)
                onPressed: () => con.addItem(product!, price, counter), 
                child: Text(
                  '+',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  minimumSize: Size(45, 37),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25), 
                    )
                  )
                ),
              ),

              Spacer(),
              ElevatedButton(     //BOTON "AGREGAR"
                onPressed: () => con.addToBag(product!, price, counter), 
                child: Text(
                  'Agregar  ${price.value}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent,     //FALTA AJUSTAR COLOR 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)
                  )
                ),
              ),

            ],
          ), 

        )
      ],
    );
  }

   //MOSTRAR LAS PRODUCTOS EN UN "CARD"
  Widget _cardProduct(BuildContext context, Product product){
    return GestureDetector(

      onTap: () => conProduct.openBottomSheet(context, product),

      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15, left: 7, right: 7),
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
 

  Widget _imageSlideshow(BuildContext context){
    return ImageSlideshow(

      width: double.infinity,
      height: MediaQuery.of(context).size.height *0.4,
      initialPage: 0,
      indicatorColor: Colors.redAccent,
      indicatorBackgroundColor: Colors.grey,

      children: [
        /*
        FadeInImage(
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder: AssetImage('assets/img/no-image.png'), 
          image: product!.image1 != null
                ? NetworkImage(product!.image1!)
                : AssetImage('assets/img/no-image.png') as ImageProvider
        ),

        FadeInImage(
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder: AssetImage('assets/img/no-image.png'), 
          image: product!.image2 != null
                ? NetworkImage(product!.image2!)
                : AssetImage('assets/img/no-image.png') as ImageProvider
        ),

        FadeInImage(
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder: AssetImage('assets/img/no-image.png'), 
          image: product!.image3 != null
                ? NetworkImage(product!.image3!)
                : AssetImage('assets/img/no-image.png') as ImageProvider
        ),
        */
      ]
    );
  }


}