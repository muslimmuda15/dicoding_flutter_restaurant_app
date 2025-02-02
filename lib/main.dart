import 'package:dicoding_flutter_restaurant_app/model/restaurant.dart';
import 'package:dicoding_flutter_restaurant_app/provider/main_provider.dart';
import 'package:dicoding_flutter_restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:dicoding_flutter_restaurant_app/provider/restaurant_provider.dart';
import 'package:dicoding_flutter_restaurant_app/ui/restaurant_detail.dart';
import 'package:dicoding_flutter_restaurant_app/ui/restaurants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
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
                      Brightness themeBrightness = Theme.of(context).brightness;
                      bool isSystemDarkMode =
                          themeBrightness == Brightness.dark;

                      if (isSystemDarkMode) {
                        mainProvider.setThemMode(ThemeMode.light);
                      } else {
                        mainProvider.setThemMode(ThemeMode.dark);
                      }
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
      },
    );
  }
}
