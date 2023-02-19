import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../map/client_address_map_page.dart';

class ClientAddressCreateController extends GetxController{


  TextEditingController addressController = TextEditingController();
  TextEditingController neighborhoodController = TextEditingController();
  TextEditingController refPointController = TextEditingController();

  void openGoogleMaps(BuildContext context) async{
    Map<String, dynamic> refPointMp = await showMaterialModalBottomSheet(
        context: context,
        builder: (context) => ClientAddressMapPage(),
        isDismissible: false,
        enableDrag: false
    );

    print('REF POINT MAP ${refPointMp}');
    refPointController.text = refPointMp['address'];


  }

}