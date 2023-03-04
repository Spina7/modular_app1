import 'package:app1/src/models/address.dart';
import 'package:app1/src/models/user.dart';
import 'package:app1/src/providers/address_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientAddressListController extends GetxController{


  List<Address> address = [];
  AddressProvider addressProvider = AddressProvider();
  User user = User.fromJson(GetStorage().read('user') ?? {});

  var radioValue = 0.obs;

  ClientAddressListController(){  //CONSTRUCTOR DE LA CLASE
    print('LA DIRECCION DE SESION: ${GetStorage().read('address')}');
  }


  Future<List<Address>> getAddress() async {

    address = await addressProvider.findByUser(user.id ?? '');
    
    //DIRECCION SELECCIONADA POR EL USUARIO
    Address a = Address.fromJson(GetStorage().read('address') ?? {});
    int index = address.indexWhere((ad) => ad.id == a.id );

    if(index != -1){//LA DIRRECCION DE SESION COINCIDE CON ALMENOS UN DATO EN LA LISTA DE DIRECCIONES
      radioValue.value = index;
    }
    
    return address;
  }

  void handleRadioValueChange(int? value){
    radioValue.value = value!;
    print('VALOR SELECCIONADO: ${value}');
    GetStorage().write('address', address[value].toJson());
    update();
  }
  
  void goToAddressCreate(){
    Get.toNamed('/client/address/create');
  }
}
