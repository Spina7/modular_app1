

import 'package:app1/src/models/category.dart';
import 'package:app1/src/models/response_api.dart';
import 'package:app1/src/providers/categories_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RestaurantCategoriesCreateController extends GetxController {
  
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  CategoriesProvider categoriesProvider = CategoriesProvider();

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

  //LIMPAR EL FORMULARIO "CREAR CATEGORIA"
  void clearForm(){

    nameController.text = '';
    descriptionController.text = '';

  }

}