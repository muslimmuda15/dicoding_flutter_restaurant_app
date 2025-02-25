import 'package:dicoding_flutter_restaurant_app/db/database.dart';
import 'package:dicoding_flutter_restaurant_app/model/restaurant.dart';
import 'package:dicoding_flutter_restaurant_app/model/restaurant_state.dart';
import 'package:dicoding_flutter_restaurant_app/provider/setting_provider.dart';
import 'package:dicoding_flutter_restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:dicoding_flutter_restaurant_app/service/restaurant_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class RestaurantDetail extends StatelessWidget {
  late final RestaurantDetailProvider provider;
  late final SettingProvider settingProvider;
  final RestaurantClick data;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  RestaurantDetail(BuildContext context, {super.key, required this.data}) {
    provider = context.read<RestaurantDetailProvider>();
    settingProvider = context.read<SettingProvider>();
    provider.fetchRestaurantDetail(data.id);
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<RestaurantDetailProvider>(context);

    return switch (postProvider.state) {
      RestaurantLoading() => Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(data.name ?? ""),
            actions: [
              IconButton(
                icon: Icon(Icons.bookmark_outline, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    "/favorite",
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    "/settings",
                  );
                },
              ),
            ],
          ),
          body: Center(
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
        ),
      RestaurantError() => Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(data.name ?? ""),
            actions: [
              IconButton(
                icon: Icon(Icons.contrast, color: Colors.white),
                onPressed: () {
                  Brightness themeBrightness = Theme.of(context).brightness;
                  bool isSystemDarkMode = themeBrightness == Brightness.dark;

                  if (isSystemDarkMode) {
                    settingProvider.setThemMode();
                  } else {
                    settingProvider.setThemMode();
                  }
                },
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: Image(
                    image: AssetImage("assets/images/no_internet.png"),
                    fit: BoxFit.contain, // This maintains aspect ratio
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
        ),
      RestaurantSuccess(:final baseResponse) => Scaffold(
          body: restaruantDetail(context, baseResponse.restaurant),
        ),
    };
  }

  Widget restaruantDetail(BuildContext context, RestaurantData? restaurant) {
    final database = Provider.of<DatabaseProvider>(context);

    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
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
                    Brightness themeBrightness = Theme.of(context).brightness;
                    bool isSystemDarkMode = themeBrightness == Brightness.dark;

                    if (isSystemDarkMode) {
                      settingProvider.setThemMode();
                    } else {
                      settingProvider.setThemMode();
                    }
                  },
                ),
              ],
              expandedHeight: MediaQuery.of(context).size.height - 72,
              title: Text(
                // This becomes the sticky title when collapsed
                restaurant?.name ?? "",
                style: TextStyle(color: Colors.white),
              ),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Stack(
                  children: <Widget>[
                    Image.network(
                      "${RestaurantAPI.baseURL}/images/medium/${restaurant?.pictureId}",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/no_image.png",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          // In case the asset image also fails to load
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey[600],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      // Add title and description in the expanded area
                      left: 16,
                      bottom: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurant?.name ?? "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            restaurant?.description ?? "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 16),
                              Text(
                                "${restaurant?.address ?? ""}\n${restaurant?.city ?? ""}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              )
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RatingStars(
                                value: restaurant?.rating?.toDouble() ?? 0.0,
                                starBuilder: (index, color) => Icon(
                                  Icons.star,
                                  color: color,
                                ),
                                starCount: 5,
                                starSize: 20,
                                valueLabelColor: const Color(0xff9b9b9b),
                                valueLabelTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0,
                                ),
                                valueLabelRadius: 10,
                                maxValue: 5,
                                starSpacing: 2,
                                maxValueVisibility: true,
                                valueLabelVisibility: true,
                                animationDuration: Duration(milliseconds: 1000),
                                valueLabelPadding: const EdgeInsets.symmetric(
                                    vertical: 1, horizontal: 8),
                                valueLabelMargin:
                                    const EdgeInsets.only(right: 8),
                                starOffColor: const Color(0xffe7e8ea),
                                starColor: Colors.yellow,
                              ),
                              FutureBuilder<bool>(
                                future: database
                                    .isRestaurantFavorite(restaurant!.id!),
                                builder: (context, snapshot) {
                                  final isFavorite = snapshot.data ?? false;

                                  return IconButton(
                                    onPressed: () async {
                                      await database.toggleFavorite(restaurant);
                                    },
                                    icon: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border_outlined,
                                      color: isFavorite
                                          ? Colors.red
                                          : Colors.white,
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ],
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
              builder: (BuildContext context, BoxConstraints constraints) {
                return GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (10 / 5),
                  children: List<Widget>.generate(
                    restaurant?.menus?.foods?.length ?? 0,
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
                            restaurant?.menus?.foods?[index].name ?? "",
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (10 / 5),
                  children: List<Widget>.generate(
                    restaurant?.menus?.drinks?.length ?? 0,
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
                            restaurant?.menus?.drinks?[index].name ?? "",
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
