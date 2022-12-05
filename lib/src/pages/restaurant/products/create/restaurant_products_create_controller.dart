

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:app1/src/models/category.dart';
import 'package:app1/src/models/response_api.dart';
import 'package:app1/src/providers/categories_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RestaurantProductsCreateController extends GetxController {
  
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  CategoriesProvider categoriesProvider = CategoriesProvider();

  ImagePicker picker = ImagePicker();
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;

  String? idCategory; //SABER CUAL ID SELECCIONO EL USUARIO

  List<Category> categories = <Category>[].obs;

  RestaurantProductsCreateController(){
    getCategories();
  }

  void getCategories() async {
    var result = await categoriesProvider.getAll();
    categories.clear();
    categories.addAll(result);
  }

  //METODO UTILIZADO EN EL BOTON "_BUTTONCREATE"
  void createCategory() async {

    String name = nameController.text;
    String description = descriptionController.text;

    print('NAME: ${name}');
    print('DESCRIPTION: ${description}');

    if(name.isNotEmpty && description.isNotEmpty){

      Category category = Category(
        name: name,
        description: description
      );
      //MANDO EL MODELO Y LANZO LA PETICION
      ResponseApi responseApi = await categoriesProvider.create(category);

      Get.snackbar('Proceso terminado', responseApi.message ?? '' );

      if(responseApi.success == true){//si se cera correctamente se limpia el formulario
        clearForm();
      }


    }else{
      Get.snackbar('Formulario no valido', 'Ingresa todos los campos para crear la categoria');
    }

  }

Future selectImage(ImageSource imageSource, int numberFile) async {
    XFile? image = await picker.pickImage(source: imageSource);

    if (image != null) {

      if(numberFile == 1){
        imageFile1 = File(image.path);
      } else if(numberFile == 2){
        imageFile2 = File(image.path);
      } else if(numberFile == 3){
        imageFile3 = File(image.path);
      }
      
      update();
    }
  }

  void showAlertDialog(BuildContext context, int numberFile) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.gallery, numberFile);
          Get.back();
        },
        child: Text(
          'Galeria',
          style: TextStyle(color: Colors.white),
        ));
    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.camera, numberFile);
          Get.back();
        },
        child: Text(
          'Camara',
          style: TextStyle(color: Colors.white),
        ));

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona una opcion'),
      content: Text('Selecciona una opcion para subir tu foto de perfil'),
      actions: [
        galleryButton,
        cameraButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }



  //LIMPAR EL FORMULARIO "CREAR CATEGORIA"
  void clearForm(){

    nameController.text = '';
    descriptionController.text = '';

  }

}