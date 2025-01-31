import 'package:dicoding_flutter_restaurant_app/model/base_response.dart';

sealed class RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantSuccess extends RestaurantState {
  final BaseResponse baseResponse;

  RestaurantSuccess(this.baseResponse);
}

class RestaurantError extends RestaurantState {
  final String message;

  RestaurantError(this.message);
}
