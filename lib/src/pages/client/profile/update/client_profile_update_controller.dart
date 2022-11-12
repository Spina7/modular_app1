import 'dart:io';
import 'package:app1/src/models/response_api.dart';
import 'package:app1/src/models/user.dart';
import 'package:app1/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:app1/src/providers/users_provider.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ClientProfileUpdateController extends GetxController{


  User user = User.fromJson(GetStorage().read('user'));

  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  ImagePicker picker = ImagePicker();
  File? imageFile;

  UsersProvider usersProvider = UsersProvider();

  ClientProfileInfoController clientProfileInfoController = Get.find(); //PARA ACCEDER A TODOS METODOS Y ATRIBUTOS 
                                                                        
  //CONSTRUCTOR DE LA CLASE
  ClientProfileUpdateController(){

    nameController.text = user.name ?? '';
    lastnameController.text = user.lastname ?? '';
    phoneController.text = user.phone ?? '';
  }


  void updateInfo(BuildContext context) async {
    
    String name = nameController.text;
    String lastname = lastnameController.text;
    String phone = phoneController.text;
    

    if (isValidForm(name, lastname, phone)) {

      ProgressDialog progressDialog = ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Actualizando...');

      User myUser = User(
        id: user.id,
        name: name,
        lastname: lastname,
        phone: phone,
        sessionToken: user.sessionToken
        
      );

      if(imageFile == null){  //ACTUALIZAR SIN IMAGEN 
        ResponseApi responseApi = await usersProvider.update(myUser);
        Get.snackbar('Proceso terminado', responseApi.message ?? '');
        progressDialog.close();
        if(responseApi.success == true){
          
          GetStorage().write('user', responseApi.data);
          clientProfileInfoController.user.value = User.fromJson(GetStorage().read('user') ?? {});
        }
      }else{  //ACTUALIZAR CON IMAGEN

          Stream stream = await usersProvider.updateWithImage(myUser, imageFile!);
          stream.listen((res) {

            progressDialog.close();
            ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
            Get.snackbar('Proceso terminado', responseApi.message ?? '');
            if (responseApi.success == true) {
              
              GetStorage().write('user', responseApi.data);
              clientProfileInfoController.user.value = User.fromJson(GetStorage().read('user') ?? {});
            } else {
              Get.snackbar('Registro fallido', responseApi.message ?? '');
            }
        });

      }

      
      
      /*Stream stream = await usersProvider.createWithImage(user, imageFile!);
      stream.listen((res) {
        progressDialog.close();
        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));

        if (responseApi.success == true) {
          GetStorage()
              .write('user', responseApi.data); // DATOS DEL USUARIO EN SESION
          goToHomePage();
        } else {
          Get.snackbar('Registro fallido', responseApi.message ?? '');
        }
      });*/
    }
  }


  bool isValidForm(   //ACTUALIZAR 
    
    String name, 
    String lastname, 
    String phone,
   
  ) {
 
    if (name.isEmpty) {
      Get.snackbar('Formulario no valido', 'Debes ingresar tu nombre');
      return false;
    }

    if (lastname.isEmpty) {
      Get.snackbar('Formulario no valido', 'Debes ingresar tu apellido');
      return false;
    }

    if (phone.isEmpty) {
      Get.snackbar(
          'Formulario no valido', 'Debes ingresar tu numero telefonico');
      return false;
    }

    return true;
  }


  Future selectImage(ImageSource imageSource) async {
    XFile? image = await picker.pickImage(source: imageSource);

    if (image != null) {
      imageFile = File(image.path);
      update();
    }
  }

  void showAlertDialog(BuildContext context) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.gallery);
          Get.back();
        },
        child: Text(
          'Galeria',
          style: TextStyle(color: Colors.white),
        ));
    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.camera);
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



}