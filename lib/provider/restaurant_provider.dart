import 'package:dicoding_flutter_restaurant_app/model/base_response.dart';
import 'package:dicoding_flutter_restaurant_app/model/restaurant_state.dart';
import 'package:dicoding_flutter_restaurant_app/service/restaurant_api.dart';
import 'package:flutter/material.dart';

class RestaurantProvider extends ChangeNotifier {
  RestaurantAPI client = RestaurantAPI();
  RestaurantState _state = RestaurantLoading();

  RestaurantState get state => _state;

  Future<void> fetchRestaurantList() async {
    _state = RestaurantLoading(); // Set state to loading
    notifyListeners();

    try {
      final response = await client.getRestaurantList();
      if (response.data != null) {
        _state = RestaurantSuccess(
            BaseResponse.fromJson(response.data!)); // Set state to success
      } else {
        _state = RestaurantError("No data available"); // Set state to error
      }
    } catch (e) {
      _state =
          RestaurantError("Failed to fetch data: $e"); // Set state to error
    }

    notifyListeners();
  }
}
