//FRONT END PAGINA "CREAR NUEVA CATEGORIA" Y LLAMADO DE FUNCIONES 

import 'dart:io';
import 'package:app1/src/models/category.dart';
import 'package:app1/src/pages/restaurant/categories/create/restaurant_categories_create_controller.dart';
import 'package:app1/src/pages/restaurant/products/create/restaurant_products_create_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantProductsCreatePage extends StatelessWidget {
    
  //CONTROLADOR DE LA CLASE 
  RestaurantProductsCreateController con = Get.put(RestaurantProductsCreateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Stack(
        children: [
          _backgroundCover(),
          _boxForm(context),
          _TextNewCategory(context),
        ],
      )),
    );
  }

  Widget _backgroundCover() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      // #fef0e7
      color: const Color(0xfefef0e7),
    );
  }

  Widget _boxForm(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.12,
            left: 40,
            right: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          boxShadow: const <BoxShadow>[
            BoxShadow(
                color: Colors.black26,
                blurRadius: 15,
                offset: Offset(0.0, 0.75),
                spreadRadius: 3.0)
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [     //Campos que se actualizarán
              _textYourInfo(),
              _textFieldName(),
              _textFieldDescription(),
              _textFieldPrice(),
              _dropDownCategories(con.categories),
              Container(
                //margin: EdgeInsets.only(top: 10),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GetBuilder<RestaurantProductsCreateController>(
                      builder: (value) => _cardImage(context, con.imageFile1, 1)
                    ),
                    SizedBox(width: 5), //SEPARACION ENTRE IMAGENES
                    GetBuilder<RestaurantProductsCreateController>(
                      builder: (value) => _cardImage(context, con.imageFile2, 2)
                    ),
                    SizedBox(width: 5), //SEPARACION ENTRE IMAGENES
                    GetBuilder<RestaurantProductsCreateController>(
                      builder: (value) => _cardImage(context, con.imageFile3, 3)
                    ),
                    
                  ],
                ),
              ),
             
              _buttonCreate(context)
            ],
          ),
        ));
  }

  Widget _dropDownCategories(List<Category> categories){//MENU DE LAS CATEGORIAS YA EXISTENTES 
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.only(top: 15),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down_circle,
            color: Colors.amber,    //FALTA ACTUALIZAR AL COLOR CORRECTO
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(

          'Seleccionar categoria',
          style: TextStyle(
            //color: Colors.black,
            fontSize: 15
          ),
        ),
        items: _dropDownItems(categories),
        value: con.idCategory.value == '' ? null : con.idCategory.value,
        onChanged: (option){
          print('opcion seleccionada ${option}');
          con.idCategory.value = option.toString();
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<Category> categories){
    List<DropdownMenuItem<String>> list = [];

    categories.forEach((category) { 
      list.add(DropdownMenuItem(
        child: Text(category.name ?? ''),
        value: category.id,
      ));
    });

    return list;
  }

  Widget _cardImage(BuildContext context, File? imageFile, int numberFile){
    return GestureDetector(
      onTap: () => con.showAlertDialog(context, numberFile),
      child: Card(
        elevation: 3, //ALGO DE SOMBRA
        child: Container(
          padding: EdgeInsets.all(10),
          height: 70,
          width: MediaQuery.of(context).size.width * 0.18,
          child: imageFile != null
          ? Image.file(
            imageFile,
            fit: BoxFit.cover,
          )
          : Image(
            image: AssetImage('assets/img/add_image.png'),
          )
        ),
      )   
    );
     
  }

  Widget _buttonCreate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: ElevatedButton(
          onPressed: () {
            con.createProduct(context);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text(
            'CREAR PRODUCTO',
            style: TextStyle(
              color: Colors.white
            ),
          )
      ),
    );
  }

  Widget _textYourInfo() {
    return Container(
        margin: EdgeInsets.only(top: 30, bottom: 20),
        child: const Text('INGRESA ESTA INFORMACION',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            )));
  }

 Widget _textFieldName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: con.nameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Nombre',
            labelText: 'Nombre',
            prefixIcon: Icon(Icons.category)),
      ),
    );
  }

  Widget _textFieldPrice() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: con.priceController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            hintText: 'Precio',
            labelText: 'Precio',
            prefixIcon: Icon(Icons.attach_money)),
      ),
    );
  }

  Widget _textFieldDescription() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: TextField(
        controller: con.descriptionController,
        keyboardType: TextInputType.text,
        maxLines: 4,
        decoration: InputDecoration(
            hintText: 'Descripcion',
            labelText: 'Descripcion',
            prefixIcon: Container(
              //margin: EdgeInsets.only(bottom: 50),
              child: Icon(
                Icons.description
              )
            ),
        ) 
      ),
    );
  }
  //NOTA!!! EL ICONO Y EL TEXTO NO ESTAN EMPAREJADOS
  //POR EL MARGIN

 

  Widget _TextNewCategory(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 20),
        alignment: Alignment.topCenter,
        child: Text(
              'NUEVO PRODUCTO',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23

              ),
        ),
      ),
    );
  }
}