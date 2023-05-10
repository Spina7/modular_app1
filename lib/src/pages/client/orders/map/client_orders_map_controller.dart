import 'dart:async';
import 'dart:ffi';
import 'package:app1/src/environment/environment.dart';
import 'package:app1/src/models/order.dart';
import 'package:app1/src/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';  //obtener nuestra direccion
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as location;  //Paquete complementario para establecer nuestra localizacion
import 'package:geocoding/geocoding.dart'; //Funcionalidad de arrastrar y obtener la direccion EN TIEMPO REAL en el mapa
import 'package:socket_io_client/socket_io_client.dart';

class ClientOrdersMapController extends GetxController {

  Socket socket = io('${ Environment.API_URL }orders/delivery', <String, dynamic> {
    'transports': ['websocket'],
    'autoConnect': false

  });

  Order order = Order.fromJson(Get.arguments['order'] ?? {});
  OrdersProvider ordersProvider = OrdersProvider();

  CameraPosition initialPosition = CameraPosition(
      target: LatLng(20.7123519, -103.4113297),
      zoom: 14
  );

  LatLng? addressLatlng;
  var addressName = ''.obs;

  Completer<GoogleMapController> mapController = Completer();

  Position? position;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  BitmapDescriptor? deliveryMarker;
  BitmapDescriptor? homeMarker;

  StreamSubscription? positionSubscribe;

  
  //
  //101. Trazando ruta desde punto A a punto B
  Set<Polyline> polylines = <Polyline>{}.obs;
  List<LatLng> points = [];
  
  
  ClientOrdersMapController() { 
    print('Order: ${order.toJson()}');

    checkGPS(); //Verificar si el gps esta activo
    connectAndListen();
  }

  void connectAndListen(){  //METODO QUE NOS PERMITE CONECTARNOS A SOCKET IO
    socket.connect();
    socket.onConnect((data) {
      print('ESTE DISPOSITIVO SE CONECTO A SOCKET IO');
    });
    listenPosition();
    listenToDelivered();
  }

  void listenPosition(){
    socket.on('position/${order.id}', (data) {

      addMarker(
        'delivery', 
        data['lat'], 
        data['lng'],
        'Tu repartidor', 
        '', 
        deliveryMarker!
      );

    });
  }

  void listenToDelivered(){
    socket.on('delivered/${order.id}', (data) {
      Fluttertoast.showToast(
        msg: 'El estado de la orden se actualizo a Entregado',
        toastLength: Toast.LENGTH_LONG
      );
      Get.offNamedUntil('/client/home', (route) => false);
    });
  }

  //Establecer la direccion cuando arrastramos en el mapa.
  Future setLocationDraggableInfo() async{

    double lat = initialPosition.target.latitude;
    double lng = initialPosition.target.longitude;

    List<Placemark> address = await placemarkFromCoordinates(lat, lng);

    if(address.isNotEmpty){
      String direction = address[0].thoroughfare ?? '';
      String street = address[0].subThoroughfare ?? '';
      String city = address[0].locality ?? '';
      String department = address[0].administrativeArea ?? '';
      String country = address[0].country ?? '';

      addressName.value = '$direction #$street, $city, $department';
      addressLatlng = LatLng(lat, lng);

      print('LAT Y LNG: ${addressLatlng?.latitude ?? 0} ${addressLatlng?.longitude ?? 0} ');
    }
  }

  //Mostrar el punto seleccionado
  void selectRefPoint(BuildContext context){

    if(addressLatlng != null){

      Map<String, dynamic> data = {
        'address': addressName.value,
        'lat': addressLatlng!.latitude,
        'lng': addressLatlng!.longitude,
      };
      Navigator.pop(context,data);
    }
  }

  Future<BitmapDescriptor> createMarkerFromAssets(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor descriptor = await BitmapDescriptor.fromAssetImage(
      configuration, path
    );

    return descriptor;
  }

  void addMarker(
    String markerId,
    double lat,
    double lng,
    String title,
    String content,
    BitmapDescriptor iconMarker
  ){
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
      markerId: id,
      icon: iconMarker,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: title, snippet: content)
    );

    markers[id] = marker;

    update();
  }

  //Para verificar si el GPS esta activado o no... 
  void checkGPS() async{
    deliveryMarker = await createMarkerFromAssets('assets/img/Delivery_little.png');
    homeMarker = await createMarkerFromAssets('assets/img/home.png');
    
    
    bool isLocationEnable = await Geolocator.isLocationServiceEnabled();

    if(isLocationEnable == true){
      updateLocation();
    }else{
      bool locationGPS = await location.Location().requestService();
      if(locationGPS == true){
        updateLocation();
      }
    }
  }

  
  //
  //101. Trazando ruta desde punto A a punto B
  Future<void> setPolylines(LatLng from, LatLng to) async {
    PointLatLng pointFrom = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointTo = PointLatLng(to.latitude, to.longitude);
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
      Environment.API_KEY_MAPS, 
      pointFrom, 
      pointTo
    );

    for(PointLatLng point in result.points){
      points.add(LatLng(point.latitude, point.longitude));
    }

    Polyline polyline = Polyline(
      polylineId: PolylineId('poly'),
      color: Colors.redAccent,
      points: points,
      width: 5
    );

    polylines.add(polyline);
    update();
  }
  

  void updateLocation() async{
    //Asegurarnos de que nustra app no falle 
    try{
      await _determinePosition();
      position = await Geolocator.getLastKnownPosition(); //Podemos tener la latitud y longitud(ACTUAL)
      
      animateCameraPosition(order.lat ?? 20.7123519, order.lng ?? -103.4113297);

      addMarker(
        'home', 
        order.address?.lat ?? 20.7123519, 
        order.address?.lng ?? -103.4113297, 
        'Lugar de entrega', 
        '', 
        homeMarker!
      );

      addMarker(
        'delivery', 
        order.lat ?? 20.7123519, 
        order.lng ?? -103.4113297, 
        'Tu repartidor', 
        '', 
        deliveryMarker!
      );

      LatLng from = LatLng(order.lat ?? 20.7123519, order.lng ?? -103.4113297);
      LatLng to = LatLng(order.address?.lat ?? 20.7123519, order.address?.lng ?? -103.4113297);

      setPolylines(from, to);

    }catch(e){
      print('Error: ${e}');
    }
  }

  void callNumber() async{
    String number = order.delivery?.phone ?? ''; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  void centerPosition(){
    if(position != null){
      animateCameraPosition(position!.latitude, position!.longitude);
    }
    
  }


  Future animateCameraPosition(double lat, double lng) async{
    GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(lat, lng),
            zoom: 13,
            bearing: 0
        )
    ));
  }


  //Obtener la localizacion de nuestro dispositivo
  Future<Position> _determinePosition() async { 
    
    bool serviceEnabled;
    LocationPermission permission;


    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }



  void onMapCreate(GoogleMapController controller){
   controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#ebe3cd"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#523735"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f1e6"}]},{"featureType":"administrative","elementType":"geometry.stroke","stylers":[{"color":"#c9b2a6"}]},{"featureType":"administrative.land_parcel","elementType":"geometry.stroke","stylers":[{"color":"#dcd2be"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#ae9e90"}]},{"featureType":"landscape.natural","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#93817c"}]},{"featureType":"poi.park","elementType":"geometry.fill","stylers":[{"color":"#a5b076"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#447530"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#f5f1e6"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#fdfcf8"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#f8c967"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#e9bc62"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#e98d58"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry.stroke","stylers":[{"color":"#db8555"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#806b63"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"transit.line","elementType":"labels.text.fill","stylers":[{"color":"#8f7d77"}]},{"featureType":"transit.line","elementType":"labels.text.stroke","stylers":[{"color":"#ebe3cd"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"water","elementType":"geometry.fill","stylers":[{"color":"#b9d3c2"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#92998d"}]}]');
    //controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#242f3e"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#746855"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#242f3e"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#263c3f"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#6b9a76"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#38414e"}]},{"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#212a37"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#9ca5b3"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#746855"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#1f2835"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#f3d19c"}]},{"featureType":"transit","elementType":"geometry","stylers":[{"color":"#2f3948"}]},{"featureType":"transit.station","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#17263c"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#515c6d"}]},{"featureType":"water","elementType":"labels.text.stroke","stylers":[{"color":"#17263c"}]}]');
    mapController.complete(controller);
  }


  @override
  void onClose(){
    super.onClose();
    socket.disconnect();
    positionSubscribe?.cancel();
  }
}