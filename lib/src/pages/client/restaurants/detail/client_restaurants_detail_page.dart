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
    return Scaffold(
      bottomNavigationBar: Container(
        color: const Color.fromRGBO(245, 245, 245, 1.0),
        height: 100,
        //child: _buttonsAddToBag(),
      ),
      body: ListView(
        children: [
          SizedBox(height: 20),
          //_imageSlideshow(context),
          _textNameRestaurant(),
          _textAddressRestaurant(),
          _textHourDetail(),
          _buildProductList(context),
        ],
      ),
    );
  }

  Widget _buildProductList(BuildContext context) {
    return FutureBuilder(
      future: conProduct.getAll(),
      builder: (context, AsyncSnapshot<List<Product>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error al cargar los productos: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return NoDataWidget(text: 'No hay productos');
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Productos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  final product = snapshot.data![index];
                  return _cardProduct(context, product);
                },
              ),
            ],
          );
        }
      },
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
 


}