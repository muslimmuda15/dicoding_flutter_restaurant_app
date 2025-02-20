import 'package:dicoding_flutter_restaurant_app/model/base_response.dart';
import 'package:dicoding_flutter_restaurant_app/model/restaurant_state.dart';
import 'package:dicoding_flutter_restaurant_app/notification/local_notification_provider.dart';
import 'package:dicoding_flutter_restaurant_app/provider/restaurant_provider.dart';
import 'package:dicoding_flutter_restaurant_app/ui/restaurant_item.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class Restaurants extends StatelessWidget {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  late final LocalNotificationProvider localNotificationProvider;
  late final RestaurantProvider provider;

  Restaurants(BuildContext context, {super.key}) {
    provider = context.read<RestaurantProvider>();
    localNotificationProvider = context.read<LocalNotificationProvider>();

    provider.fetchRestaurantList();
  }

  Widget buildRestaurantItem(BuildContext context, int index,
      Animation<double>? animation, BaseResponse baseResponse) {
    return RestaurantItem(restaurantItem: baseResponse.restaurants![index]);
  }

  Widget gridLayout(
      BuildContext context, int gridCount, BaseResponse baseResponse) {
    return GridView.count(
      crossAxisCount: gridCount,
      childAspectRatio: (10 / 6),
      children: List<Widget>.generate(baseResponse.restaurants!.length,
          (index) => buildRestaurantItem(context, index, null, baseResponse)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<RestaurantProvider>(context);

    return switch (postProvider.state) {
      RestaurantLoading() => Center(
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
        ),
      RestaurantError() => LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Image(
                  image: AssetImage("assets/images/no_internet.png"),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      RestaurantSuccess(:final baseResponse) => LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth < 600) {
              return AnimatedList(
                  key: listKey,
                  initialItemCount: baseResponse.restaurants?.length ?? 0,
                  itemBuilder: (context, index, animation) =>
                      buildRestaurantItem(
                          context, index, animation, baseResponse));
            } else if (constraints.maxWidth < 900) {
              return gridLayout(context, 2, baseResponse);
            } else if (constraints.maxWidth < 1200) {
              return gridLayout(context, 4, baseResponse);
            } else if (constraints.maxWidth < 1350) {
              return gridLayout(context, 5, baseResponse);
            } else {
              return gridLayout(context, 6, baseResponse);
            }
          },
        )
    };
  }
}
