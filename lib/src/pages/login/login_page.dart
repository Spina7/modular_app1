import 'package:app1/src/pages/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginController con = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          height: 100,
          color: const Color(0xfefef0e7),
          child: _textDontHaveAccount(),
        ),
        body: Stack(
          children: [
            _backgroundCover(),
            Column(
              children: [_imageCover()],
            ),
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

  Widget _boxForm(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.4, left: 40, right: 40),
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
              _textFieldPassword(),
              _buttonLogin()
            ],
          ),
        ));
  }

  Widget _buttonLogin() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: ElevatedButton(
          onPressed: () => con.login(),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text(
            'INGRESAR',
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Widget _textDontHaveAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('¿No tienes cuenta?',
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontFamily: 'Roboto')),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => con.goToRegisterPage(),
          child: const Text('Registrate Aqui',
              style: TextStyle(
                  // #EA5153
                  color: Color(0xeaea5153),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto')),
        )
      ],
    );
  }

  Widget _imageCover() {
    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        child: Image.asset(
          'assets/img/delivery.png',
          height: 350,
          width: 350,
        ),
      ),
    );
  }
}
