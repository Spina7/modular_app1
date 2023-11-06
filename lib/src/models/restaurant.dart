import 'dart:convert';

Restaurant restaurantFromJson(String str) =>
    Restaurant.fromJson(json.decode(str));

String restaurantToJson(Restaurant data) => json.encode(data.toJson());

class Restaurant {
  String? id;
  String? name;
  String? address;
  String? initial_working_hour;
  String? ending_working_hour;
  String? image1;
  String? image2;
  String? image3;

  Restaurant({
    this.id,
    this.name,
    this.address,
    this.initial_working_hour,
    this.ending_working_hour,
    this.image1,
    this.image2,
    this.image3,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        initial_working_hour: json["initial_working_hour"],
        ending_working_hour: json["ending_working_hour"],
        image1: json["image1"],
        image2: json["image2"],
        image3: json["image3"],
      );

  static List<Restaurant> fromJsonList(List<dynamic> jsonList) {
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
        "image1": image1,
        "image2": image2,
        "image3": image3,
      };
}
