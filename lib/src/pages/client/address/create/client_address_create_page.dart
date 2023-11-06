import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app1/src/pages/client/address/create/client_address_create_controller.dart';
import 'package:geolocator/geolocator.dart';

class ClientAddressCreatePage extends StatelessWidget {
  ClientAddressCreateController con = Get.put(ClientAddressCreateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _backgroundCover(),
        _boxForm(context),
        _textNewAddress(context),
        _iconBack()
      ],
    ));
  }

  Widget _iconBack() {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.only(left: 15),
      child: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, size: 30)),
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
            children: [
              //Campos que se actualizarán
              _textYourInfo(),
              _textFieldAddress(),
              SizedBox(height: 15),

              _textFieldNeighbor(),
              SizedBox(height: 15),

              _textFieldRefPoint(context),
              SizedBox(height: 20),
              _buttonCreate(context)
            ],
          ),
        ));
  }

  Widget _buttonCreate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: ElevatedButton(
          onPressed: () {
            con.createAddress();
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text(
            'CREAR DIRECCION',
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

  Widget _textFieldAddress() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: con.addressController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Direccion', prefixIcon: Icon(Icons.location_on)),
      ),
    );
  }

  Widget _textFieldNeighbor() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: con.neighborhoodController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Barrio', prefixIcon: Icon(Icons.location_city)),
      ),
    );
  }

  /*
  Widget _textFieldRefPoint(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        onTap: () => con.openGoogleMaps(context),
        controller: con.refPointController,
        autofocus: false,
        focusNode: AlwaysDisableFocusNode(),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Punto de referencia',
            prefixIcon: Icon(Icons.map)),
      ),
    );
  }
  */

  Widget _textFieldRefPoint(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: FutureBuilder<LocationPermission>(
        future: Geolocator.checkPermission(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // Muestra un indicador de carga mientras se verifica el permiso.
            return CircularProgressIndicator();
          }

          final locationPermission = snapshot.data;

          return TextField(
            onTap: () {
              if (locationPermission == LocationPermission.denied) {
                // Muestra un mensaje o realiza alguna acción cuando se toca el campo
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Error"),
                      content: Text("Activa el GPS para usar esta función."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cerrar"),
                        ),
                      ],
                    );
                  },
                );
              } else {
                con.openGoogleMaps(context);
              }
            },
            readOnly: locationPermission ==
                LocationPermission
                    .denied, // Campo de texto no editable si el GPS está deshabilitado
            controller: con.refPointController,
            autofocus: false,
            focusNode: AlwaysDisableFocusNode(),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Punto de referencia',
              prefixIcon: Icon(Icons.map),
            ),
          );
        },
      ),
    );
  }

  Widget _textNewAddress(BuildContext context) {
    return SafeArea(
      child: Container(
          margin: EdgeInsets.only(top: 15),
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Icon(
                Icons.location_on,
                size: 100,
                color: Colors.black,
              ),
              Text(
                'NUEVA DIRECCION',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
            ],
          )),
    );
  }
}

class AlwaysDisableFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
