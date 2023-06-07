//SELECTOR DE DOCUMENTOS MERCADO PAGO - API 

import 'package:app1/src/environment/environment.dart';
import 'package:app1/src/models/mercado_pago_card_token.dart';
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


  Future<MercadoPagoCardToken> createCardToken ({
    String? cvv,
    String? expirationYear,
    int? expirationMonth,
    String? cardNumber,
    String? cardHolderName,
    //String? documentNumber,
    //String? documentId,
  }) async {
    Response response = await post(
        '$url/card_tokens?public_key=${Environment.PUBLIC_KEY}',
        {
          'security_code': cvv,
          'expiration_year': expirationYear,
          'expiration_month': expirationMonth,
          'card_number': cardNumber,
          'cardholder':{
            'name':cardHolderName,
            /*'identification':{
              'number': documentNumber,
              'type': documentId
            }*/
          },
        },
        headers: {
          'Content-Type': 'application/json',  
        },
        
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    if(response.statusCode != 201){
      Get.snackbar('Error','No se pudo validar la targeta');
      return MercadoPagoCardToken();
    }

    print('RESPONSE: ${response}');
    print('RESPONSE Status code: ${response.statusCode}');
    print('RESPONSE BODY: ${response.body}');

    MercadoPagoCardToken  res = MercadoPagoCardToken.fromJson(response.body);

    return res;
  }

}