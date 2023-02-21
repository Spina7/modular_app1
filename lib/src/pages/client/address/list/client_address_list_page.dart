//LISTA DE DIRECCIONES 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app1/src/pages/client/address/list/client_address_list_controller.dart';




class ClientAddressListPage extends StatelessWidget {

  ClientAddressListController con = Get.put(ClientAddressListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text(
            'Mis Direcciones',
            style: TextStyle(
                color: Colors.black //FALTA AJUSTAR COLOR
            )
        ),
        actions: [  //Para agregar el icono
          _iconAddressCreate()
        ],
      ),
    );
  }

  Widget _iconAddressCreate(){
    return IconButton(
        onPressed: () => con.goToAddressCreate(),
        icon: Icon(
          Icons.add,
          color: Colors.white,  //FALTA AJUSTAR COLOR
        )
    );
  }
}
