import 'dart:convert';
import 'dart:io';
import 'package:app1/src/environment/environment.dart';
import 'package:app1/src/models/restaurant.dart';
import 'package:app1/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class RestaurantProvider extends GetConnect{

  User userSession = User.fromJson(GetStorage().read('user') ?? {} );

  String url = Environment.API_URL + 'api/restaurants';

  //MOSTRAR TODOS LOS RESTAURANTES
  Future<List<Restaurant>> findByCategory(String idCategory) async {
    Response response = await get(
        '$url/findByCategory/$idCategory',
        
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    if(response.statusCode == 401){
      Get.snackbar('Peticion Denegada', 'Tu usuario no tiene permitido leer esta informacion');
      return [];
    }

    List<Restaurant> restaurants = Restaurant.fromJsonList(response.body);
    return restaurants;
  }

  /*
  Future<List<Restaurant>> findByNameAndCategory(String idCategory, String name) async {
    Response response = await get(
        '$url/findByNameAndCategory/$idCategory/$name',
        
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    if(response.statusCode == 401){
      Get.snackbar('Peticion Denegada', 'Tu usuario no tiene permitido leer esta informacion');
      return [];
    }

    List<Restaurant> restaurants = Restaurant.fromJsonList(response.body);
    return restaurants;
  }
  */


  Future<List<Restaurant>> findByName(String name) async {
    try {
      Response response = await get(
        '$url/findByName/$name',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
      );

      if (response.statusCode == 401) {
        Get.snackbar('Peticion Denegada', 'Tu usuario no tiene permitido leer esta informacion');
        return [];
      }

      List<Restaurant> restaurants = Restaurant.fromJsonList(response.body);
      return restaurants;
    } catch (e) {
      print('Error en la solicitud HTTP: $e');
      return [];
    }
  }

  Future<List<Restaurant>> getAll() async {
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

    List<Restaurant> restaurants = Restaurant.fromJsonList(response.body);
    return restaurants;
    print(restaurants);
  }
  
  /*
  Future<Stream> create(Product product, List<File> images) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/products/create');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = userSession.sessionToken ?? '';

    for(int i = 0; i < images.length; i++){ //for para recoger los archivos que le envia el usuario
      request.files.add(http.MultipartFile(
          'image',
          http.ByteStream(images[i].openRead().cast()),
          await images[i].length(),
          filename: basename(images[i].path)
      ));
    }

    request.fields['product'] = json.encode(product);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }
  */
}
