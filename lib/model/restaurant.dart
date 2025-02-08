import 'package:dicoding_flutter_restaurant_app/model/base_response.dart';
import 'package:dicoding_flutter_restaurant_app/model/menus.dart';
import 'package:dicoding_flutter_restaurant_app/model/restaurant_review.dart';

class RestaurantClick {
  String? id, name;

  RestaurantClick(this.id, this.name);
}

class RestaurantData {
  String? id, name, description, pictureId, city, address;
  num? rating;
  List<NameData>? categories;
  MenusData? menus;
  List<CustomerReview>? customerReviews;

  RestaurantData(
      this.id,
      this.name,
      this.description,
      this.pictureId,
      this.city,
      this.rating,
      this.categories,
      this.menus,
      this.customerReviews,
      this.address);

  RestaurantData.fromJson(Map data) {
    id = data["id"];
    name = data["name"];
    description = data["description"];
    pictureId = data["pictureId"];
    city = data["city"];
    address = data["address"];
    rating = data["rating"];
    categories = data["categories"] != null
        ? List<NameData>.from(
            data["categories"].map(
              (category) => NameData.fromJson(category),
            ),
          )
        : null;
    menus = data["menus"] != null ? MenusData.fromJson(data["menus"]) : null;
    customerReviews = data["customerReviews"] != null
        ? List<CustomerReview>.from(
            data["customerReviews"].map(
              (customerReview) => CustomerReview.fromJson(customerReview),
            ),
          )
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name ?? "",
      "description": description ?? "",
      "pictureId": pictureId ?? "",
      "city": city ?? "",
      "rating": rating ?? 0,
    };
  }
}
