//SELECTOR DE DOCUMENTOS MERCADO PAGO - API 

import 'package:app1/src/environment/environment.dart';
import 'package:app1/src/models/mercado_pago_document_type.dart';
import 'package:get/get.dart';

class MercadoPagoProvider extends GetConnect{

  String url = Environment.API_MERCADO_PAGO;


  Future<List<MercadoPagoDocumentType>> getDocumentsType() async {
    Response response = await get(
        '$url/identification_types',
        
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Environment.ACCESS_TOKEN}'
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    if(response.statusCode == 401){
      Get.snackbar('Peticion Denegada', 'Tu usuario no tiene permitido leer esta informacion');
      return [];
    }

    List<MercadoPagoDocumentType> documents = MercadoPagoDocumentType.fromJsonList(response.body);
    return documents;
  }

}