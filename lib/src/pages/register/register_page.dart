import 'package:app1/src/pages/register/register_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  RegisterController con = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _backgroundCover(),
        _imageUser(context),
        _buttonBack(),
        _boxForm(context),
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
        height: MediaQuery.of(context).size.height * 0.7,
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
            children: [
              _textYourInfo(),
              _textFieldEmail(),
              _textFieldName(),
              _textFieldLastName(),
              _textFieldPhone(),
              _textFieldPassword(),
              _textFieldConfirmPassword(),
              _buttonRegister(context)
            ],
          ),
        ));
  }

  Widget _buttonRegister(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: ElevatedButton(
          onPressed: () => con.register(context),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text(
            'REGISTRARSE',
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

  Widget _textFieldEmail() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: con.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'Correo Electronico',
            labelText: 'E-mail',
            prefixIcon: Icon(Icons.email)),
      ),
    );
  }

  Widget _textFieldPhone() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: con.phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintText: 'Telefono',
            labelText: 'Telefono',
            prefixIcon: Icon(Icons.phone)),
      ),
    );
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
            prefixIcon: Icon(Icons.person)),
      ),
    );
  }

  Widget _textFieldLastName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: con.lastnameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Apellido',
            labelText: 'Apellido',
            prefixIcon: Icon(Icons.person_outline)),
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: con.passwordController,
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Contraseña',
            labelText: 'Contraseña',
            prefixIcon: Icon(Icons.lock)),
      ),
    );
  }

  Widget _textFieldConfirmPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: con.confirmPasswordController,
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Confirmar Contraseña',
            labelText: 'Confirmar Contraseña',
            prefixIcon: Icon(Icons.lock_outline)),
      ),
    );
  }

  Widget _buttonBack() {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.only(
        left: 20,
      ),
      child: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.arrow_back_ios),
        color: Colors.black,
        iconSize: 30,
      ),
    ));
  }

  Widget _imageUser(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 20),
        alignment: Alignment.topCenter,
        child: GestureDetector(
            onTap: () => con.showAlertDialog(context),
            child: GetBuilder<RegisterController>(
              builder: (value) => CircleAvatar(
                backgroundImage: con.imageFile != null
                    ? FileImage(con.imageFile!)
                    : AssetImage('assets/img/user_profile.png')
                        as ImageProvider,
                radius: 60,
                backgroundColor: Colors.white,
              ),
            )),
      ),
    );
  }
}
