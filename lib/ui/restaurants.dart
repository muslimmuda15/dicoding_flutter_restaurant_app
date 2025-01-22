import 'package:dicoding_flutter_restaurant_app/provider/restaurant_provider.dart';
import 'package:dicoding_flutter_restaurant_app/ui/restaurant_item.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class Restaurants extends StatelessWidget {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  late final RestaurantProvider provider;

  Restaurants(BuildContext context, {super.key}) {
    provider = context.read<RestaurantProvider>();
    provider.fetchRestaurantList();
  }

  Widget buildRestaurantItem(
    BuildContext context,
    int index,
    Animation<double>? animation,
  ) {
    return RestaurantItem(
        restaurantItem: provider.baseResponse!.restaurants![index]);
  }

  Widget gridLayout(BuildContext context, int gridCount) {
    return GridView.count(
      crossAxisCount: gridCount,
      childAspectRatio: (10 / 6),
      children: List<Widget>.generate(
          provider.baseResponse!.restaurants!.length,
          (index) => buildRestaurantItem(context, index, null)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<RestaurantProvider>(context);

    if (postProvider.isLoading) {
      return Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: LoadingIndicator(
            indicatorType: Indicator.ballScale,
            colors: const [
              Colors.red,
              Colors.yellow,
              Colors.green,
              Colors.blue
            ],
            strokeWidth: 2,
          ),
        ),
      );
    } else {
      if (postProvider.baseResponse != null) {
        if (postProvider.baseResponse!.error == true) {
          return Center(
            child: Text(postProvider.baseResponse?.message ?? "Error text"),
          );
        } else {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth < 600) {
                return AnimatedList(
                    key: listKey,
                    initialItemCount:
                        postProvider.baseResponse!.restaurants?.length ?? 0,
                    itemBuilder: buildRestaurantItem);
              } else if (constraints.maxWidth < 900) {
                return gridLayout(context, 2);
              } else if (constraints.maxWidth < 1200) {
                return gridLayout(context, 4);
              } else if (constraints.maxWidth < 1350) {
                return gridLayout(context, 5);
              } else {
                return gridLayout(context, 6);
              }
            },
          );
        }
      } else {
        return Center(
          child: Text("No data found"),
        );
      }
    }
  }
}
