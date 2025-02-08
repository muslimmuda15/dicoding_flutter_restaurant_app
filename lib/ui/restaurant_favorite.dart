import 'package:dicoding_flutter_restaurant_app/db/database.dart';
import 'package:dicoding_flutter_restaurant_app/model/restaurant.dart';
import 'package:dicoding_flutter_restaurant_app/ui/restaurant_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantFavorite extends StatelessWidget {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  RestaurantFavorite({super.key});

  Widget buildRestaurantItem(BuildContext context, int index,
      Animation<double>? animation, List<Map<String, dynamic>> restaurants) {
    return RestaurantItem(
        restaurantItem: RestaurantData.fromJson(restaurants[index]));
  }

  Widget gridLayout(BuildContext context, int gridCount,
      List<Map<String, dynamic>> restaurants) {
    return GridView.count(
      crossAxisCount: gridCount,
      childAspectRatio: (10 / 6),
      children: List<Widget>.generate(restaurants.length,
          (index) => buildRestaurantItem(context, index, null, restaurants)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DatabaseProvider>(context);

    return FutureBuilder(
      future: dbProvider.getRestaurantList(),
      builder: (context, snapshot) => LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < 600) {
            return AnimatedList(
                key: listKey,
                initialItemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index, animation) => buildRestaurantItem(
                    context, index, animation, snapshot.data!));
          } else if (constraints.maxWidth < 900) {
            return gridLayout(context, 2, snapshot.data!);
          } else if (constraints.maxWidth < 1200) {
            return gridLayout(context, 4, snapshot.data!);
          } else if (constraints.maxWidth < 1350) {
            return gridLayout(context, 5, snapshot.data!);
          } else {
            return gridLayout(context, 6, snapshot.data!);
          }
        },
      ),
    );
  }
}
