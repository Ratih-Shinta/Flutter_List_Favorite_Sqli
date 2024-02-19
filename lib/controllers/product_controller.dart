import 'dart:convert';
import 'package:flutter_list_favorite_sqli/models/product_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

class ProductController extends GetxController {
  String dbName = "db_user";
  int dbVersion = 1;

  String favoriteTable = "favorite_table";
  final String columnId = 'id';
  final String columnUrl = 'src';
  final String columnAlt = 'alt';
  final String columnPhotographer = 'photographer';

  Database? database;
  var isLoading = true.obs;
  RxList allPhotos = [].obs;
  RxList<Photo> favoritesPhoto = <Photo>[].obs;

  @override
  void onInit() {
    getAllPhotos();
    super.onInit();
    initDatabase();
    getFavorites();
  }

  Future<void> getAllPhotos() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.pexels.com/v1/search?query=nature'),
        headers: {
          'Authorization':
              'BJl0ap1V86KsHfXbjGfPS9qRjGvuyahozrf277axY6w927Ym7ph94blu',
        },
      );
      if (response.statusCode == 200) {
        isLoading(false);
        final content = json.decode(response.body)['photos'];
        for (var item in content) {
          allPhotos.add(Photo.fromJson(item));
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Database> initDatabase() async {
    String directory = await getDatabasesPath();
    String path = directory + dbName;
    var database = await openDatabase(path, version: dbVersion,
        onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $favoriteTable (
          $columnId INTEGER PRIMARY KEY,
          $columnPhotographer TEXT,
          $columnAlt TEXT,
          $columnUrl TEXT
        )
      ''');
      version = dbVersion;
    });
    return database;
  }

  Future<List<Photo>> getFavorites() async {
    final db = await initDatabase();
    List<Map<String, dynamic>> maps = await db.query(favoriteTable);
    favoritesPhoto.clear();
    if (maps.isNotEmpty) {
      favoritesPhoto.addAll(maps
          .map((map) => Photo(
                id: map[columnId],
                photographer: map[columnPhotographer],
                alt: map[columnAlt],
                src: map[columnUrl],
              ))
          .toList());
    }
    favoritesPhoto.forEach((element) {
      print(element.toJson());
    });
    return favoritesPhoto;
  }

  Future<void> fetchFavorites() async {
    await getFavorites();
  }

  Future<int> saveData(Photo favoritePhoto) async {
    final db = await initDatabase();
    int result = await db.insert(favoriteTable, favoritePhoto.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<int> deleteFavorite(Photo favoritePhoto) async {
    final db = await initDatabase();
    int result = await db.delete(favoriteTable,
        where: '$columnId = ?', whereArgs: [favoritePhoto.id]);
    favoritesPhoto.removeWhere((element) => element.id == favoritePhoto.id);
    return result;
  }

  bool isFavorite(int id) {
    for (Photo favoritePhoto in favoritesPhoto) {
      if (favoritePhoto.id == id) {
        return true;
      }
    }
    return false;
  }
}