import 'package:dicoding_flutter_restaurant_app/model/restaurant.dart';

class BaseResponse {
  bool? error;
  int? founded, count;
  String? message;
  List<RestaurantData>? restaurants;
  RestaurantData? restaurant;

  BaseResponse.fromJson(Map data) {
    error = data["error"];
    message = data["message"];
    count = data["count"];
    founded = data["founded"];
    restaurant = data["restaurant"] != null
        ? RestaurantData.fromJson(data["restaurant"])
        : null;
    restaurants = data["restaurants"] != null
        ? List<RestaurantData>.from(
            data["restaurants"].map(
              (restaurant) => RestaurantData.fromJson(restaurant),
            ),
          )
        : null;
  }
}

class NameData {
  String? name;

  NameData(this.name);

  NameData.fromJson(Map data) {
    name = data["name"];
  }
}
