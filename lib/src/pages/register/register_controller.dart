import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void register() {
    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String lastname = lastnameController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String confirmpassword = confirmPasswordController.text.trim();

    print('Email ${email}');
    print('Name ${name}');
    print('Lastname ${lastname}');
    print('Phone ${phone}');
    print('Password ${password}');
    print('ConfirmPassword ${confirmpassword}');

    if (isValidForm(email, password, name, lastname, phone, confirmpassword)) {
      Get.snackbar(
          'Formulario valido', 'Estas listo para enviar la peticion http');
    }
  }

  bool isValidForm(String email, String password, String name, String lastname,
      String phone, String confirmPassword) {
    if (email.isEmpty) {
      Get.snackbar('Formulario no valido', 'El email es requerido');
      return false;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Formulario no valido', 'El email no es valido');
      return false;
    }

    if (name.isEmpty) {
      Get.snackbar('Formulario no valido', 'El nombre es requerido');
      return false;
    }

    if (lastname.isEmpty) {
      Get.snackbar('Formulario no valido', 'El apellido es requerido');
      return false;
    }

    if (phone.isEmpty) {
      Get.snackbar('Formulario no valido', 'El telefono es requerido');
      return false;
    }

    if (password.isEmpty) {
      Get.snackbar('Formulario no valido', 'El password es requerido');
    }

    if (confirmPassword.isEmpty) {
      Get.snackbar('Formulario no valido',
          'Debes ingresar la confirmacion del password');
      return false;
    }

    if (password != confirmPassword) {
      Get.snackbar('Formulario no valido',
          'El password y la confirmacion del password no coinciden');
      return false;
    }

    return true;
  }
}
