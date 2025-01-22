import 'package:dicoding_flutter_restaurant_app/model/base_response.dart';
import 'package:dicoding_flutter_restaurant_app/service/restaurant_api.dart';
import 'package:flutter/material.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  RestaurantAPI client = RestaurantAPI();
  BaseResponse? _baseResponse;
  bool _isLoading = false;

  BaseResponse? get baseResponse => _baseResponse;
  bool get isLoading => _isLoading;

  Future<void> fetchRestaurantDetail(String id) async {
    _isLoading = true;
    notifyListeners();

    final response = await client.getRestaurantDetail(id: id);
    _baseResponse =
        response.data != null ? BaseResponse.fromJson(response.data!) : null;
    _isLoading = false;
    notifyListeners();
  }
}
