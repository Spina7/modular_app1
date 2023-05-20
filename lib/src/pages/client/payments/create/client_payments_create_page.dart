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
  
  ClientPaymentsCreateController con = Get.put(ClientPaymentsCreateController());

  @override
  Widget build(BuildContext context) {
    return Obx(() =>  Scaffold(

      bottomNavigationBar: _buttonNext(context),

      body: ListView(
        children: [

          CreditCardWidget(   //ANIMACION DE UNA TARGETA
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
              formKey: con.keyForm, // Required 
              onCreditCardModelChange: con.onCreditCardModelChanged, // Required
              themeColor: Colors.red,
              obscureCvv: true, 
              obscureNumber: true,
              //isHolderNameVisible: true,
              //isCardNumberVisible: true,
              //isExpiryDateVisible: true,
              enableCvv: true,
              cardNumberValidator: (String? cardNumber){},
              expiryDateValidator: (String? expiryDate){},
              cvvValidator: (String? cvv){},
              cardHolderValidator: (String? cardHolderName){},
              onFormComplete: () {
              // callback to execute at the end of filling card data
              },

              cardNumberDecoration: const InputDecoration(
                //border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.credit_card),
                labelText: 'Numero de la Tarjeta',
                hintText: 'XXXX XXXX XXXX XXXX',
              ),
              expiryDateDecoration: const InputDecoration(
                //border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.date_range),
                labelText: 'Expiracion',
                hintText: 'XX/XX',
              ),
              cvvCodeDecoration: const InputDecoration(
                //border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.lock),
                labelText: 'CVV',
                hintText: 'XXX',
              ),
              cardHolderDecoration: const InputDecoration(
                //border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.person),
                labelText: 'Titular de la Tarjeta',
              ),
              cvvCode: '',
              expiryDate: '',
              cardHolderName: '',
              cardNumber: '',

            ),
          ),

        ],
      )
    ));
  }

  Widget _buttonNext(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text(
            'CONTINUAR',
            style: TextStyle(color: Colors.white),
          )),
    );
  }

}