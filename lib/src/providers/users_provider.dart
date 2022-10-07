import 'package:get/get.dart';
import 'package:app1/src/environment/environment.dart';
import 'package:app1/src/models/user.dart';

class UsersProvider extends GetConnect {

  String url = Environment.API_URL + 'api/users';
  
  
  Future<Response> create(User user) async {
    Response response = await post(
        '$url/create',
        user.toJson(),
        headers: {
          'Content-Type': 'application/json'
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    return response;
  }
} 