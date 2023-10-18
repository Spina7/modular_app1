import 'package:app1/src/models/mercado_pago_document_type.dart';
import 'package:app1/src/pages/client/payments/create/client_payments_create_controller.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:get/get.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/glassmorphism_config.dart';

class ClientPaymentsCreatePage extends StatelessWidget {
  ClientPaymentsCreateController con =
      Get.put(ClientPaymentsCreateController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              'Pagos',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: ListView(
            children: [
              CreditCardWidget(
                cardNumber: con.cardNumber.value,
                expiryDate: con.expireDate.value,
                cardHolderName: con.cardHolderName.value,
                cvvCode: con.cvvCode.value,
                showBackView: con.isCvvFocused.value,
                cardBgColor: Colors.black,
                obscureCardNumber: true,
                obscureInitialCardNumber: false,
                obscureCardCvv: true,
                height: 175,
                labelCardHolder: 'NOMBRE Y APELLIDO',
                textStyle: TextStyle(color: Colors.black87),
                width: MediaQuery.of(context).size.width,
                animationDuration: Duration(milliseconds: 1000),
                frontCardBorder: Border.all(color: Colors.grey),
                backCardBorder: Border.all(color: Colors.grey),
                onCreditCardWidgetChange: (CreditCardBrand) {},
                glassmorphismConfig: Glassmorphism(
                  blurX: 10.0,
                  blurY: 10.0,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Colors.grey.withAlpha(50),
                      Colors.black.withAlpha(80),
                    ],
                    stops: const <double>[
                      0.3,
                      0,
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: CreditCardForm(
                  formKey: con.keyForm,
                  onCreditCardModelChange: con.onCreditCardModelChanged,
                  themeColor: Colors.red,
                  obscureCvv: true,
                  obscureNumber: true,
                  enableCvv: true,
                  cardNumberDecoration: const InputDecoration(
                    suffixIcon: Icon(Icons.credit_card),
                    labelText: 'Numero de la Tarjeta',
                    hintText: 'XXXX XXXX XXXX XXXX',
                  ),
                  expiryDateDecoration: const InputDecoration(
                    suffixIcon: Icon(Icons.date_range),
                    labelText: 'Expiracion',
                    hintText: 'MM/YY',
                  ),
                  cvvCodeDecoration: const InputDecoration(
                    suffixIcon: Icon(Icons.lock),
                    labelText: 'CVV',
                    hintText: 'XXX',
                  ),
                  cardHolderDecoration: const InputDecoration(
                    suffixIcon: Icon(Icons.person),
                    labelText: 'Titular de la Tarjeta',
                  ),
                  cvvCode: '',
                  expiryDate: '',
                  cardHolderName: '',
                  cardNumber: '',
                ),
              ),
              Column(
                children: [
                  _buttonNext(context),
                  _buttonNextCash(context),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _textFieldDocumentNumber() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: con.documentNumberController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintText: 'Numero de documento',
            labelText: 'Numero de documento',
            suffixIcon: Icon(Icons.description)),
      ),
    );
  }

  Widget _buttonNext(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: ElevatedButton(
          onPressed: () {}, //=> con.createCardToken(),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text(
            'CONTINUAR',
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Widget _buttonNextCash(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: ElevatedButton(
          onPressed: () => con.payInCash(),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text(
            'Continuar Pago En Efectivo',
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Widget _dropDownWidget(List<MercadoPagoDocumentType> documents) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.only(top: 15),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down_circle,
            color: Color(0xeaea5153),
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          'Seleccionar tipo de documento',
          style: TextStyle(
              //color: Colors.black,
              fontSize: 15),
        ),
        items: _dropDownItems(documents),
        value: con.idDocument.value == '' ? null : con.idDocument.value,
        onChanged: (option) {
          print('opcion seleccionada ${option}');
          con.idDocument.value = option.toString();
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(
      List<MercadoPagoDocumentType> documents) {
    List<DropdownMenuItem<String>> list = [];

    documents.forEach((document) {
      list.add(DropdownMenuItem(
        child: Text(document.name ?? ''),
        value: document.id,
      ));
    });

    return list;
  }
}
