import 'package:dicoding_flutter_restaurant_app/model/restaurant.dart';
import 'package:dicoding_flutter_restaurant_app/provider/main_provider.dart';
import 'package:dicoding_flutter_restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:dicoding_flutter_restaurant_app/service/restaurant_api.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class RestaurantDetail extends StatelessWidget {
  late final RestaurantDetailProvider provider;
  late final MainProvider mainProvider;
  final String data;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  RestaurantDetail(BuildContext context, {super.key, required this.data}) {
    provider = context.read<RestaurantDetailProvider>();
    mainProvider = context.read<MainProvider>();
    provider.fetchRestaurantDetail(data);
  }

  @override
  Widget build(BuildContext context) {
    // final postProvider = Provider.of<RestaurantDetailProvider>(context);

    if (provider.isLoading) {
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
      if (provider.baseResponse != null) {
        if (provider.baseResponse!.error == true) {
          return Center(
            child: Text(provider.baseResponse?.message ?? "Error text"),
          );
        } else {
          RestaurantData? restaurant = provider.baseResponse!.restaurant;
          if (restaurant != null) {
            return DefaultTabController(
              length: 2,
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      pinned: true,
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      actions: [
                        IconButton(
                          icon: Icon(Icons.contrast, color: Colors.white),
                          onPressed: () {
                            if (mainProvider.themeMode == ThemeMode.light) {
                              mainProvider.setThemMode(ThemeMode.dark);
                            } else {
                              mainProvider.setThemMode(ThemeMode.light);
                            }
                          },
                        ),
                      ],
                      expandedHeight: MediaQuery.of(context).size.height - 72,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          restaurant.name ?? "",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        background: Stack(
                          children: <Widget>[
                            Image.network(
                              "${RestaurantAPI.baseURL}/images/medium/${restaurant.pictureId}",
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Center(
                              child: Container(
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  gradient: LinearGradient(
                                    begin: FractionalOffset.topCenter,
                                    end: FractionalOffset.bottomCenter,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.0),
                                      Colors.black.withValues(alpha: 0.7),
                                    ],
                                    stops: [0.0, 1.0],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        TabBar(
                          labelColor: Theme.of(context).colorScheme.onSurface,
                          unselectedLabelColor: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.5),
                          tabs: [
                            Tab(icon: Icon(Icons.restaurant), text: "Tab 1"),
                            Tab(icon: Icon(Icons.local_cafe), text: "Tab 2"),
                          ],
                        ),
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: TabBarView(
                  children: <Widget>[
                    LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: (10 / 5),
                          children: List<Widget>.generate(
                            restaurant.menus?.foods?.length ?? 0,
                            (index) => SizedBox(
                              height: 200,
                              child: Card(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                semanticContainer: true,
                                clipBehavior: Clip.hardEdge,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: Text(
                                    restaurant.menus?.foods?[index].name ?? "",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: (10 / 5),
                          children: List<Widget>.generate(
                            restaurant.menus?.drinks?.length ?? 0,
                            (index) => SizedBox(
                              height: 200,
                              child: Card(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                semanticContainer: true,
                                clipBehavior: Clip.hardEdge,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: Text(
                                    restaurant.menus?.drinks?[index].name ?? "",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Text("No data found"),
            );
          }
        }
      } else {
        return Center(
          child: Text("No data found"),
        );
      }
    }
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
