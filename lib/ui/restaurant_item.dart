import 'package:dicoding_flutter_restaurant_app/model/restaurant.dart';
import 'package:dicoding_flutter_restaurant_app/service/restaurant_api.dart';
import 'package:flutter/material.dart';

class RestaurantItem extends StatelessWidget {
  final RestaurantData restaurantItem;
  const RestaurantItem({super.key, required this.restaurantItem});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        semanticContainer: true,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.pushNamed(
              context,
              "/detail",
              arguments: restaurantItem.id,
            );
          },
          child: Stack(
            children: <Widget>[
              Image.network(
                "${RestaurantAPI.baseURL}/images/medium/${restaurantItem.pictureId}",
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Center(
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    // gradient: LinearGradient(
                    //   begin: FractionalOffset.topCenter,
                    //   end: FractionalOffset.bottomCenter,
                    //   colors: [
                    //     Colors.white.withValues(alpha: 0.0),
                    //     Colors.black.withValues(alpha: 0.7),
                    //   ],
                    //   stops: [0.0, 1.0],
                    // ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 14,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 14,
                                    color: Colors.yellow,
                                  ),
                                  Text(
                                    restaurantItem.rating.toString(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                restaurantItem.city ?? "",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ListTile(
                          title: Text(
                            restaurantItem.name ?? "",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            restaurantItem.description ?? "",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
