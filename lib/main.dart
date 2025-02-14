import 'package:dicoding_flutter_restaurant_app/db/database.dart';
import 'package:dicoding_flutter_restaurant_app/model/restaurant.dart';
import 'package:dicoding_flutter_restaurant_app/notification/local_notification_provider.dart';
import 'package:dicoding_flutter_restaurant_app/notification/local_notification_service.dart';
import 'package:dicoding_flutter_restaurant_app/provider/setting_provider.dart';
import 'package:dicoding_flutter_restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:dicoding_flutter_restaurant_app/provider/restaurant_provider.dart';
import 'package:dicoding_flutter_restaurant_app/ui/restaurant_detail.dart';
import 'package:dicoding_flutter_restaurant_app/ui/restaurant_favorite.dart';
import 'package:dicoding_flutter_restaurant_app/ui/restaurants.dart';
import 'package:dicoding_flutter_restaurant_app/ui/settings.dart';
import 'package:dicoding_flutter_restaurant_app/util/time_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MultiProvider(
    providers: [
      Provider(
        create: (context) => LocalNotificationService()
          ..init()
          ..configureLocalTimeZone(),
      ),
      ChangeNotifierProvider(
        create: (context) => LocalNotificationProvider(
          context.read<LocalNotificationService>(),
        )..requestPermissions(),
      ),
      ChangeNotifierProvider(create: (_) => RestaurantProvider()),
      ChangeNotifierProvider(create: (_) => RestaurantDetailProvider()),
      ChangeNotifierProvider(create: (_) => SettingProvider()),
      ChangeNotifierProvider(create: (_) => DatabaseProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // const _MyAppState({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);

    return MaterialApp(
      title: dotenv.env['TITLE_APP'],
      theme: ThemeData(
        brightness: Brightness.light, // Light theme
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        textTheme: GoogleFonts.playfairTextTheme(
          TextTheme(
            bodyLarge: TextStyle(color: Colors.black87),
            bodyMedium: TextStyle(color: Colors.black87),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Colors.orange,
          secondary: Colors.red,
        ),
        textTheme: GoogleFonts.playfairTextTheme(
          TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white),
          ),
        ),
      ),
      themeMode: settingProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: "/",
      routes: {
        "/": (context) => Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(dotenv.env['TITLE_APP']!),
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
              body: Restaurants(context),
            ),
        "/detail": (context) => RestaurantDetail(
              context,
              data:
                  ModalRoute.of(context)?.settings.arguments as RestaurantClick,
            ),
        "/favorite": (context) => Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(dotenv.env['TITLE_APP']!),
                actions: [
                  IconButton(
                    icon: Icon(Icons.contrast, color: Colors.white),
                    onPressed: () {
                      settingProvider.setThemMode();
                    },
                  ),
                ],
              ),
              body: RestaurantFavorite(),
            ),
        "/settings": (context) => Settings()
      },
    );
  }
}
