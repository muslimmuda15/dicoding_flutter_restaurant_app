import 'package:dicoding_flutter_restaurant_app/model/restaurant.dart';
import 'package:dicoding_flutter_restaurant_app/util/logger.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<List<Map<String, dynamic>>> loadRestaurantList(Database db) async {
  return await db.query('restaurants');
}

Future<void> insertRestaurant(Database db, RestaurantData restaurant) async {
  try {
    await db.insert(
      'restaurants',
      restaurant.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } on DatabaseException catch (e) {
    Log.d('Database error : ', error: e.result);
  } catch (e) {
    Log.d('Unexpected error: ', error: e);
  }
}

Future<void> deleteRestaurant(Database db, String id) async {
  try {
    await db.delete(
      'restaurants',
      where: 'id = ?',
      whereArgs: [id],
    );
  } on DatabaseException catch (e) {
    Log.d('Database error : ', error: e.result);
  } catch (e) {
    Log.d('Unexpected error: ', error: e);
  }
}

Future<bool> checkRestaurantFavorite(Database db, String id) async {
  final result = await db.query(
    'restaurants',
    where: 'id = ?',
    whereArgs: [id],
  );
  return result.isNotEmpty;
}
