import 'package:dicoding_flutter_restaurant_app/model/base_response.dart';
import 'package:dicoding_flutter_restaurant_app/model/restaurant_state.dart';
import 'package:dicoding_flutter_restaurant_app/service/restaurant_api.dart';
import 'package:dicoding_flutter_restaurant_app/util/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantProvider extends ChangeNotifier {
  RestaurantAPI client = RestaurantAPI();
  RestaurantState _state = RestaurantLoading();

  RestaurantState get state => _state;

  Future<void> fetchRestaurantList() async {
    _state = RestaurantLoading();

    try {
      final response = await client.getRestaurantList();
      if (response.data != null) {
        _state = RestaurantSuccess(BaseResponse.fromJson(response.data!));
      } else {
        _state = RestaurantError("No data available");
      }
    } on DioException catch (e) {
      Log.d("Dio error : ", error: e);
      _state = RestaurantError("Failed to fetch data : ${e.message}");
    }

    notifyListeners();
  }
}
