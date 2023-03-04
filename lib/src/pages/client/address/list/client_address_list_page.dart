//LISTA DE DIRECCIONES 
import 'package:app1/src/models/address.dart';
import 'package:app1/src/widgets/no_data_widget.dart';
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
      body: GetBuilder<ClientAddressListController> (builder: (Value) => Stack(
        children: [
          _textSelectAddress(),
          _listAddress(context)
        ],
      )),
    );
  }

  //EXTRAE TOLA LA INFO DE LA BASE DE DATOS. 
  Widget _listAddress(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 50),

      child: FutureBuilder(
        future: con.getAddress(),
        builder: (context, AsyncSnapshot<List<Address>> snapshot){
          if(snapshot.hasData){
            if(snapshot.data!.isNotEmpty){
              return ListView.builder(

                itemCount: snapshot.data?.length ?? 0,
                padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                itemBuilder: (_, index){
                  return _radioSelectorAddress(snapshot.data![index], index);
                }
              );
            }else{
              return Center(
                child: NoDataWidget(text: 'No Hay Direcciones'),
              );
            }
          }else{
            return Center(
              child: NoDataWidget(text: 'No Hay Direcciones'),
            );
          }
        }
      ),
    );
  }

  Widget _radioSelectorAddress(Address address, int index){
    return  Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      
      child: Column(
        children: [

          Row(
            children: [
              Radio(
                value: index, 
                groupValue: con.radioValue.value, 
                onChanged: con.handleRadioValueChange,
                
              ),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.address ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold 
                    ),
                  ),

                  Text(
                    address.neighborhood ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      //fontWeight: FontWeight.bold 
                    ),
                  ),
                ],
              )
            ],
          ),
          Divider(
            color: Colors.grey[400],
          )
        ]
      ),
    );
  }

  Widget _textSelectAddress(){
    return Container(
      margin: EdgeInsets.only(top: 30, left: 30),
      child: Text(
        'Escoge una direccion',
        style: TextStyle(
          color: Colors.black,
          fontSize: 19, 
          fontWeight: FontWeight.bold
        ),
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
