import 'package:dicoding_flutter_restaurant_app/provider/main_provider.dart';
import 'package:dicoding_flutter_restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:dicoding_flutter_restaurant_app/provider/restaurant_provider.dart';
import 'package:dicoding_flutter_restaurant_app/ui/restaurant_detail.dart';
import 'package:dicoding_flutter_restaurant_app/ui/restaurants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => RestaurantProvider()),
      ChangeNotifierProvider(create: (_) => RestaurantDetailProvider()),
      ChangeNotifierProvider(create: (_) => MainProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);

    return MaterialApp(
      title: dotenv.env['TITLE_APP'],
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: mainProvider.themeMode,
      initialRoute: "/",
      routes: {
        "/": (context) => Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(dotenv.env['TITLE_APP']!),
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
              ),
              body: Restaurants(context),
            ),
        "/detail": (context) => Scaffold(
              body: RestaurantDetail(
                context,
                data: ModalRoute.of(context)?.settings.arguments as String,
              ),
            ),
      },
    );
  }
}
