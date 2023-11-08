import 'package:app1/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientProfileInfoPage extends StatelessWidget {
  
  ClientProfileInfoController con = Get.put(ClientProfileInfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Stack(
        children: [
          _backgroundCover(),
          _imageUser(context),
          _boxForm(context),
          
          Column(
            children: [
              _buttonSignOut(),
              _buttonRoles()
            ],
          ),
        ],
      )),
    );
  }

  Widget _backgroundCover() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      // #fef0e7
      color: Colors.grey[230],
    );
  }

  Widget _boxForm(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.25,
            left: 40,
            right: 40),
        decoration: BoxDecoration(
          color: const Color(0xfefef0e7),
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
              _textName(),
              _textEmail(),
              _textPhone(),
              _buttonUpdate(context)
            ],
          ),
        ));
  }

  Widget _buttonRoles() {
    return Container(
      margin: EdgeInsets.only(right: 20),
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () => con.goToRoles(),
        icon: Icon(Icons.supervised_user_circle),
        color: Colors.black,
        iconSize: 30,
      ),
    );
  }



  Widget _buttonSignOut() {
    return SafeArea(
      child: Container(
      margin: EdgeInsets.only(right: 20),
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () => con.signOut(),
        icon: Icon(Icons.power_settings_new),
        color: Colors.black,
        iconSize: 30,
      ),
    ));
  }

  Widget _buttonUpdate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: ElevatedButton(
          onPressed: () => con.goToProfileUpdate(),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text(
            'ACTUALIZAR DATOS',
            style: TextStyle(color: Colors.white),
          )),
    );
  }

   Widget _textName() {
    return Container(
      margin: EdgeInsets.only(top: 10),
        child: ListTile(
          leading: Icon(Icons.person),
          title: Text( '${con.user.value.name ?? '' } ${con.user.value.lastname ?? ''}'),
          subtitle: Text('Nombre'),
        ),
    );
  }

   Widget _textEmail() {
    return ListTile(
      leading: Icon(Icons.email),
      title: Text(con.user.value.email ?? ''),
      subtitle: Text('Email'),
    );
  }

  Widget _textPhone() {
    return ListTile(
      leading: Icon(Icons.phone),
      title: Text(con.user.value.phone ?? ''),
      subtitle: Text('Telefono'),
    );
  }
  
  Widget _imageUser(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 20),
        alignment: Alignment.topCenter,
        child: CircleAvatar(

          backgroundImage: con.user.value.image != null
              ? NetworkImage(con.user.value.image!)
              : AssetImage('assets/img/user_profile.png') as ImageProvider,
          radius: 60,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

}