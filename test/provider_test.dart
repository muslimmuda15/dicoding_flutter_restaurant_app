import 'package:dicoding_flutter_restaurant_app/model/restaurant_state.dart';
import 'package:dicoding_flutter_restaurant_app/provider/restaurant_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'mock/mock_restaurant_api.mocks.dart';

void main() {
  late RestaurantProvider provider;
  late MockRestaurantAPI mockApi;

  setUpAll(() async {
    // Initialize dotenv before all tests
    await dotenv.load(fileName: ".env");
  });

  group('RestaurantProvider', () {
    setUp(() {
      mockApi = MockRestaurantAPI();
      provider = RestaurantProvider();
      provider.client = mockApi;
    });

    test('Is first state RestaurantLoading?', () {
      expect(provider.state, isA<RestaurantLoading>());
    });

    test('fetchRestaurantList() - Successful to retrieve data', () async {
      final mockResponse = Response<Map<String, dynamic>>(
        data: {
          "error": false,
          "message": "success",
          "count": 2,
          "restaurants": [
            {
              "id": "1",
              "name": "Restaurant A",
              "description": "Desc A",
              "pictureId": "1",
              "city": "City A",
              "rating": 4.5
            },
            {
              "id": "2",
              "name": "Restaurant B",
              "description": "Desc B",
              "pictureId": "2",
              "city": "City B",
              "rating": 4.0
            }
          ]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      );

      when(mockApi.getRestaurantList()).thenAnswer((_) async => mockResponse);

      await provider.fetchRestaurantList();

      expect(provider.state, isA<RestaurantSuccess>());
      final successState = provider.state as RestaurantSuccess;
      expect(successState.baseResponse.restaurants?.isNotEmpty, true);
    });

    test('fetchRestaurantList() - Failed to receive data', () async {
      when(mockApi.getRestaurantList()).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: 'Network error successfully',
          message: 'Failed to connect on the server',
        ),
      );

      await provider.fetchRestaurantList();

      expect(provider.state, isA<RestaurantError>());
      expect((provider.state as RestaurantError).message,
          contains("Failed to fetch data"));
    });
  });
}
