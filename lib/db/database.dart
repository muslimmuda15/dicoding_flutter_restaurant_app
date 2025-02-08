import 'package:dicoding_flutter_restaurant_app/db/query.dart';
import 'package:dicoding_flutter_restaurant_app/model/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Database> initializeDatabase() async {
  sqfliteFfiInit();

  var databaseFactory = databaseFactoryFfi;
  final appSupportDir = await getApplicationSupportDirectory();
  final dbPath = join(appSupportDir.path, 'restaurant.db');

  return await databaseFactory.openDatabase(
    dbPath,
    options: OpenDatabaseOptions(
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE restaurants (
              id TEXT PRIMARY KEY,
              name TEXT,
              description TEXT,
              pictureId TEXT,
              city TEXT,
              rating REAL
          )
      ''');
      },
    ),
  );
}

class DatabaseProvider with ChangeNotifier {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initializeDatabase();
    return _database!;
  }

  Future<List<Map<String, dynamic>>> getRestaurantList() async {
    final db = await database;
    return loadRestaurantList(db);
  }

  Future<void> toggleFavorite(RestaurantData restaurant) async {
    final db = await database;
    final isFavorite = await checkRestaurantFavorite(db, restaurant.id!);

    if (isFavorite) {
      await deleteRestaurant(db, restaurant.id!);
    } else {
      await insertRestaurant(db, restaurant);
    }

    notifyListeners();
  }

  Future<bool> isRestaurantFavorite(String id) async {
    final db = await database;
    return await checkRestaurantFavorite(db, id);
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
