import 'package:dicoding_flutter_restaurant_app/model/base_response.dart';

class MenusData {
  List<NameData>? foods, drinks;

  MenusData(this.foods, this.drinks);

  MenusData.fromJson(Map data) {
    foods = data["foods"] != null
        ? List<NameData>.from(
            data["foods"].map(
              (food) => NameData.fromJson(food),
            ),
          )
        : null;
    drinks = data["drinks"] != null
        ? List<NameData>.from(
            data["drinks"].map(
              (drink) => NameData.fromJson(drink),
            ),
          )
        : null;
  }
}
