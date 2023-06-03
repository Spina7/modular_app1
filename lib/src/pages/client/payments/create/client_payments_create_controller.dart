
import 'package:app1/src/models/mercado_pago_document_type.dart';
import 'package:app1/src/providers/mercado_pago_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:get/get.dart';

class ClientPaymentsCreateController extends GetxController{

  TextEditingController documentNumberController = TextEditingController();

  var cardNumber = ''.obs;
  var expireDate = ''.obs;
  var cardHolderName = ''.obs;
  var cvvCode = ''.obs;
  var isCvvFocused = false.obs;
  var idDocument = ''.obs; //SELECTOR DE DOCUMENTOS MERCADO PAGO - API
  
  GlobalKey<FormState> keyForm = GlobalKey();
  //SELECTOR DE DOCUMENTOS MERCADO PAGO - API
  MercadoPagoProvider mercadoPagoProvider = MercadoPagoProvider();
  List<MercadoPagoDocumentType> documents = <MercadoPagoDocumentType>[].obs;

  
  ClientPaymentsCreateController(){
    //SELECTOR DE DOCUMENTOS MERCADO PAGO - API
    //getDocumentType();
  }

  void onCreditCardModelChanged(CreditCardModel creditCardModel){
    cardNumber.value = creditCardModel.cardNumber;
    expireDate.value = creditCardModel.expiryDate;
    cardHolderName.value = creditCardModel.cardHolderName;
    cvvCode.value = creditCardModel.cvvCode;
    isCvvFocused.value = creditCardModel.isCvvFocused;
  }

  //SELECTOR DE DOCUMETOS MERCADO PAGO - API 
  void getDocumentType() async {
    var result  = await mercadoPagoProvider.getDocumentsType();
    documents.clear();
    documents.addAll(result);
  }

}