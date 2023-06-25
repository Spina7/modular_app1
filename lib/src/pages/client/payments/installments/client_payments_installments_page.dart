import 'package:app1/src/models/mercado_pago_installment.dart';
import 'package:app1/src/pages/client/payments/installments/client_payments_installments_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ClientPaymentsInstallmentsPage extends StatelessWidget {

  ClientPaymentsInstallmentsController con = Get.put(ClientPaymentsInstallmentsController());
  

  @override
  Widget build(BuildContext context) {
    return Obx(() =>  Scaffold(

      bottomNavigationBar: Container(
        color: Color.fromRGBO(245, 245, 245, 1),
        height: 100,
        child: _totalToPay(context),
      ),

      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black   // FALTA AJUSTAR COLOR
        ),
        title: Text(
          'Cuotas de Pago', 
          style: TextStyle(
            color: Colors.black   // FALTA AJUSTAR COLOR
          ),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textDescription(),
          _dropDownWidget(con.installmentsList),
        ]
      ),

    ));
  }

  Widget _textDescription(){
    return Container(
      margin: EdgeInsets.all(30),
      child: Text(
        '¿En cuantas cuotas desea realizar el pago?',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _dropDownWidget(List<MercadoPagoInstallment> installments){
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

          'Seleccionar numero de cuotas',
          style: TextStyle(
            //color: Colors.black,
            fontSize: 15
          ),
        ),
        items: _dropDownItems(installments),
        value: con.installments.value == '' ? null : con.installments.value,
        onChanged: (option){
          print('opcion seleccionada ${option}');
          con.installments.value = option.toString();
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<MercadoPagoInstallment> installments){
    List<DropdownMenuItem<String>> list = [];

    installments.forEach((installment) { 
      list.add(DropdownMenuItem(
        child: Text('${installment.installments}'),
        value: '${installment.installments}',
      ));
    });
    return list;
  }

  Widget _totalToPay(BuildContext context){
    return Column(
      children: [
        Divider(height: 1, color: Colors.grey[400]),
        Container(
          margin: EdgeInsets.only(left: 15, top: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'TOTAL: \$${con.total.value}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),
              ),
              Container(
              
                margin: EdgeInsets.symmetric(horizontal: 30),
                //width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  onPressed: () => con.createPayment(), 
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10)
                  ),
                  child: Text(
                    'CONFIRMAR PAGO',
                    style: TextStyle(
                      color: Colors.black
                    ),
                  )
                )
              )
            ],
          ),
        )
        
      ],
    );
  }

}