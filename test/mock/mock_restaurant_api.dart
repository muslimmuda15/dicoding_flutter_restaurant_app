import 'package:dicoding_flutter_restaurant_app/model/restaurant_state.dart';
import 'package:dicoding_flutter_restaurant_app/provider/restaurant_provider.dart';
import 'package:dicoding_flutter_restaurant_app/service/restaurant_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mock_restaurant_api.mocks.dart';

// Generate mock
@GenerateMocks([RestaurantAPI])
void main() {
  late RestaurantProvider provider;
  late RestaurantAPI mockApi;

  setUp(() {
    mockApi = MockRestaurantAPI();
    provider = RestaurantProvider()..client = mockApi;
  });

  group('RestaurantProvider Test', () {
    /**
     * Test 1: Test init state is RestaurantLoading  
     * */
    test('initial state should be RestaurantLoading', () {
      expect(provider.state, isA<RestaurantLoading>());
    });

    /**
     * Test 2: Test success to return restaurant list
     */
    test('should return restaurant list when API call is successful', () async {
      // Arrange
      final mockResponse = Response(
        data: {
          "error": false,
          "message": "success",
          "count": 1,
          "restaurants": [
            {
              "id": "1",
              "name": "Test Restaurant",
              "description": "Test Description",
              "pictureId": "1",
              "city": "Test City",
              "rating": 4.5
            }
          ]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      );

      when(mockApi.getRestaurantList()).thenAnswer((_) async => mockResponse);

      await provider.fetchRestaurantList();

      // Assert
      expect(provider.state, isA<RestaurantSuccess>());
      final successState = provider.state as RestaurantSuccess;
      expect(successState.baseResponse.restaurants?.length, 1);
      expect(successState.baseResponse.restaurants?[0].name, "Test Restaurant");
    });

    /**
     * Test network error
     */
    test('should return error when API call fails', () async {
      when(mockApi.getRestaurantList()).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: 'Failed to connect',
          message: 'Connection error',
        ),
      );

      await provider.fetchRestaurantList();

      expect(provider.state, isA<RestaurantError>());
      final errorState = provider.state as RestaurantError;
      expect(errorState.message.contains('Failed to fetch data'), true);
    });
  });
}
