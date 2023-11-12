

import 'dart:convert';
import 'dart:io';
import 'package:app1/src/models/product.dart';
import 'package:app1/src/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:app1/src/models/category.dart';
import 'package:app1/src/models/response_api.dart';
import 'package:app1/src/models/user.dart';
import 'package:get_storage/get_storage.dart';
import 'package:app1/src/providers/categories_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class RestaurantProductsCreateController extends GetxController {

  User user = User.fromJson(GetStorage().read('user') ?? {});
  
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  CategoriesProvider categoriesProvider = CategoriesProvider();

  ImagePicker picker = ImagePicker();
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;

  var idCategory = ''.obs; //SABER CUAL ID SELECCIONO EL USUARIO
  List<Category> categories = <Category>[].obs;

  ProductsProvider productsProvider = ProductsProvider();

  RestaurantProductsCreateController(){
    getCategories();
  }

  void getCategories() async {
    var result = await categoriesProvider.getAll();
    categories.clear();
    categories.addAll(result);
  }

  //METODO UTILIZADO EN EL BOTON "_BUTTONCREATE"
  void createProduct(BuildContext context) async {

    String name = nameController.text;
    String description = descriptionController.text;
    String price = priceController.text;

    print('NAME: ${name}');
    print('DESCRIPTION: ${description}');
    print('PRICE: ${price}');
    print('ID CATEGORY: ${idCategory}');

    ProgressDialog progressDialog = ProgressDialog(context: context);

    if(isValidFrom(name, description, price)){
      Product product = Product(
        name: name,
        description: description,
        price: double.parse(price),
        idCategory: idCategory.value,
        idRestaurant: user.id_restaurant ?? '0',
      );

    progressDialog.show(max: 100, msg: 'Espere un momento...');


    List<File> images = [];
    images.add(imageFile1!);
    images.add(imageFile2!);
    images.add(imageFile3!);

    Stream stream = await productsProvider.create(product, images);
    stream.listen((res) {
      progressDialog.close();

      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      Get.snackbar('Procerso terminado', responseApi.message ?? '');
      if(responseApi.success == true){
        clearForm();
      }
    });

    }

  }

  bool isValidFrom(String name, String description, String price){
    if(name.isEmpty){
      Get.snackbar('Formulario no valido', 'Ingresa el nombre del producto');
      return false;
    }

    if(description.isEmpty){
      Get.snackbar('Formulario no valido', 'Ingresa la descripcion del producto');
      return false;
    }

    if(price.isEmpty){
      Get.snackbar('Formulario no valido', 'Ingresa el precio del producto');
      return false;
    }

    if(idCategory.value == ''){
      Get.snackbar('Formulario no valido', 'Debes seleccionar la categoria del producto');
      return false;
    }

    if(imageFile1 == null){
      Get.snackbar('Formulario no valido', 'Selecciona la imagen del producto numero 1');
      return false;
    }

    if(imageFile2 == null){
      Get.snackbar('Formulario no valido', 'Selecciona la imagen del producto numero 2');
      return false;
    }

    if(imageFile3 == null){
      Get.snackbar('Formulario no valido', 'Selecciona la imagen del producto numero 3');
      return false;
    }

    return true;

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



  //LIMPIAR EL FORMULARIO "CREAR CATEGORIA"
  void clearForm(){

    nameController.text = '';
    descriptionController.text = '';
    priceController.text = '';
    imageFile1 = null;
    imageFile2 = null;
    imageFile3 = null;
    idCategory.value = '';
    update();
  }

}