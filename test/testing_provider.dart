import 'package:flutter_test/flutter_test.dart';
import 'package:dicoding_flutter_restaurant_app/provider/restaurant_provider.dart';
import 'package:dicoding_flutter_restaurant_app/model/restaurant_state.dart';

void main() {
  group('RestaurantProvider Test', () {
    late RestaurantProvider provider;

    setUp(() {
      provider = RestaurantProvider();
    });

    test('Initial state should be loading', () {
      expect(provider.state, isA<RestaurantLoading>());
    });

    test('fetchRestaurantList should update state', () async {
      // Initial state
      expect(provider.state, isA<RestaurantLoading>());

      // Fetch data
      await provider.fetchRestaurantList();

      // State should be either success or error
      expect(
        provider.state,
        anyOf(isA<RestaurantSuccess>(), isA<RestaurantError>()),
      );
    });
  });
}
