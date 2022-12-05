// CATEGRIAS 

import 'package:app1/src/models/category.dart';
import 'package:app1/src/models/response_api.dart';
import 'package:get/get.dart';
import 'package:app1/src/environment/environment.dart';
import 'package:app1/src/models/user.dart';
import 'package:get_storage/get_storage.dart';


class CategoriesProvider extends GetConnect {

  String url = Environment.API_URL + 'api/categories';
  

  User userSession = User.fromJson(GetStorage().read('user') ?? {} );

  //MOSTRAR TODAS LAS CATEGORIAS 
  Future<List<Category>> getAll() async {
    Response response = await get(
        '$url/getAll',
        
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    if(response.statusCode == 401){
      Get.snackbar('Peticion Denegada', 'Tu usuario no tiene permitido leer esta informacion');
      return [];
    }

    List<Category> categories = Category.fromJsonList(response.body);
    return categories;
  }
 
  //CREAR UNA NUEVA CATEGORIA (RESTAURANTE)
  Future<ResponseApi> create(Category category) async {
    Response response = await post(
        '$url/create',
        category.toJson(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA


    ResponseApi  responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

}