import 'package:dicoding_flutter_restaurant_app/model/restaurant_review.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class RestaurantAPI {
  static String baseURL = dotenv.env['API_BASE_URL']!;

  var api = RestaurantAPI.createApi();

  static Dio createApi() {
    var option = BaseOptions(
        baseUrl: baseURL,
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 60),
        contentType: "application/json;charset=utf-8");

    return Dio(option)
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: false,
          // filter: (options, args) {
          //   return !args.isResponse || !args.hasUint8ListData;
          // },
        ),
      );
  }

  Future<Response<Map>> getRestaurantList() async {
    Response<Map> response = await api.get("/list");
    return response;
  }

  Future<Response<Map>> getRestaurantDetail({required String? id}) async {
    Response<Map> response = await api.get("/detail/$id");
    return response;
  }

  Future<Response<Map>> getSearchRestaurant({required String search}) async {
    Response<Map> response =
        await api.get("/search", queryParameters: {"q": search});
    return response;
  }

  Future<Response<Map>> addReviewRestaurant({required ReviewData data}) async {
    Response<Map> response = await api.post("/review", data: data.toJson());
    return response;
  }
}
