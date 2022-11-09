

import 'package:app1/src/models/Rol.dart';
import 'package:app1/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RolesController extends GetxController{

  //MODELO PARA TRAER LOS ROLES ASIGNADOS AL MOMENTO DE INICIAR SESION
  User user = User.fromJson(GetStorage().read('user') ?? {} );


  void goToPageRol(Rol rol){
    Get.offNamedUntil(rol.route ?? '', (route) => false);
  }


}