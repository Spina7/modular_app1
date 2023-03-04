

import 'package:app1/src/models/category.dart';
import 'package:app1/src/models/response_api.dart';
import 'package:get/get.dart';
import 'package:app1/src/environment/environment.dart';
import 'package:app1/src/models/user.dart';
import 'package:get_storage/get_storage.dart';
import 'package:app1/src/models/address.dart';

class AddressProvider extends GetConnect {

  String url = Environment.API_URL + 'api/address';
  

  User userSession = User.fromJson(GetStorage().read('user') ?? {} );

  //METODO PARA MOSTRAR LAS DIRECCIONES(CLIENTE)
  Future<List<Address>> findByUser(String idUser) async {
    Response response = await get(
        '$url/findByUser/$idUser',
        
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    if(response.statusCode == 401){
      Get.snackbar('Peticion Denegada', 'Tu usuario no tiene permitido leer esta informacion');
      return [];
    }

    List<Address> address = Address.fromJsonList(response.body);
    return address;
  }
  

  //CREAR UNA NUEVA DIRECCION (CLIENTE)
  Future<ResponseApi> create(Address address) async {
    Response response = await post(
        '$url/create',
        address.toJson(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA


    ResponseApi  responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

}