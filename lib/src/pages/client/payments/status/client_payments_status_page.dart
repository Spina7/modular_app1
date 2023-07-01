import 'package:app1/src/pages/client/payments/status/client_payments_status_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ClientPaymentsStatusPage extends StatelessWidget {

  ClientPaymentsStatusController con = Get.put(ClientPaymentsStatusController());
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _backgroundCover(),
        _boxForm(context),
        _textFinishTransaction(context)
      ],
    ));
  }

  Widget _backgroundCover() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      // #fef0e7
      color: const Color(0xfefef0e7),
    );
  }

  Widget _boxForm(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.50,
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.25,
            left: 40,
            right: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          boxShadow: const <BoxShadow>[
            BoxShadow(
                color: Colors.black26,
                blurRadius: 15,
                offset: Offset(0.0, 0.75),
                spreadRadius: 3.0)
          ],
        ),
        child: Column(
          children: [     //Campos que se actualizarán
            _textTransactionDetail(),
            _textTransactionStatus(),
            Spacer(),
            _buttonCreate(context)
          ],
        ),
    );
  }

  Widget _buttonCreate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: ElevatedButton(
          onPressed: () {
            con.finishShopping();
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text(
            'FINALIZAR COMPRA',
            style: TextStyle(
              color: Colors.white
            ),
          )
      ),
    );
  }

  Widget _textTransactionDetail() {
    return Container(
      margin: EdgeInsets.only(top: 30, bottom: 20, left: 25, right: 25),
      child: Text(
        con.mercadoPagoPayment.status == 'approved' 
        ? 'Tu orden fue procesada exitosamente usando (${con.mercadoPagoPayment.paymentMethodId?.toUpperCase()} **** ${con.mercadoPagoPayment.card?.lastFourDigits})'
        : 'Tu pago fue rechazado',
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
      ),
    );
  }
 
  Widget _textTransactionStatus() {
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 25, right: 25),
      child: Text(
        con.mercadoPagoPayment.status == 'approved' 
        ? 'Mira el estado de tu compra en la seccion de mis pedidos'
        : con.errorMessage.value,
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _textFinishTransaction(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 15),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            con.mercadoPagoPayment.status == 'approved' 
            ? Icon(Icons.check_circle, size: 100, color: Colors.green)
            : Icon(Icons.cancel, size: 100, color: Colors.black12),

            Text(
              'TRANSACCION TERMINADA',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23

              ),
            ),
          ],
        ) 
      ),
    );
  }
}