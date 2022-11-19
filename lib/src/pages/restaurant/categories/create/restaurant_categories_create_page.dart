import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

class RestaurantCategoriesCreatePage extends StatelessWidget {
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _backgroundCover(),
        _boxForm(context),
        _TextNewCategory(context),
      ],
    ));
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
        height: MediaQuery.of(context).size.height * 0.50,
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.25,
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
              _buttonUpdate(context)
            ],
          ),
        ));
  }

  Widget _buttonUpdate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text(
            'CREAR CATEGORIA',
            style: TextStyle(color: Colors.white),
          )),
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
        //controller: con.lastnameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Nombre',
            labelText: 'Nombre',
            prefixIcon: Icon(Icons.category)),
      ),
    );
  }


  Widget _textFieldDescription() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: TextField(
        //controller: con.nameController,
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

 

 

  Widget _TextNewCategory(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 15),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Icon(
              Icons.category, 
              size: 100,
              color: Colors.white,
            ),

            Text(
              'NUEVA CATEGORIA',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23

              ),
            ),
          ],
        ) 
      ),
    );
  }
}