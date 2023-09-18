

import 'dart:convert';

Restaurant restaurantFromJson(String str) => Restaurant.fromJson(json.decode(str));

String restaurantToJson(Restaurant data) => json.encode(data.toJson());

class Restaurant {

  String? id;
  String? name;
  String? address;
  String? initial_working_hour;
  String? ending_working_hour;
  
  Restaurant({
    this.id,
    this.name,
    this.address,
    this.initial_working_hour,
    this.ending_working_hour,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    initial_working_hour: json["initial_working_hour"],
    ending_working_hour: json["ending_working_hour"],
  );

  static List<Restaurant> fromJsonList(List<dynamic> jsonList){
    List<Restaurant> toList = [];

    jsonList.forEach((item) { 
      Restaurant restaurant = Restaurant.fromJson(item);
      toList.add(restaurant);
    });
    return toList;
    }


  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "initial_working_hour": initial_working_hour,
    "ending_working_hour": ending_working_hour,
  };
}
