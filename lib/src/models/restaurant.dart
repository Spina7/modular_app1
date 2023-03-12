import 'dart:convert';

Restaurant restaurantFromJson(String str) => Restaurant.fromJson(json.decode(str));

String restaurantToJson(Restaurant data) => json.encode(data.toJson());

class Restaurant {

    String? id;
    String? name;
    String? address;
    int? initialWorkingHour;
    int? endingWorkingHour;

    Restaurant({
        this.id,
        this.name,
        this.address,
        this.initialWorkingHour,
        this.endingWorkingHour,
    });

    static List<Restaurant> fromJsonList(List<dynamic> jsonList){
      List<Restaurant> toList = [];

      jsonList.forEach((item) { 
        Restaurant restaurant = Restaurant.fromJson(item);
        toList.add(restaurant);
      });

      return toList;
    }   

    factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        initialWorkingHour: json["initial_working_hour"],
        endingWorkingHour: json["ending_working_hour"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "initial_working_hour": initialWorkingHour,
        "ending_working_hour": endingWorkingHour,
    };
}
