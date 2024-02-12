import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_list_favorite_sqli/models/product_model.dart';
import 'package:flutter_list_favorite_sqli/views/favorite_page_view.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProductController extends GetxController {
    String dbName = "db_user";
  int dbVersion = 1;

  String favoriteTable = "favorite_table";
  final String columnId = 'id';
  final String columnUrl = 'url';
  final String columnAlt = 'alt';
  final String columnPhotographer = 'photographer';

  Database? database;
  var isLoading = true.obs;
  RxList allPhotos = [].obs;
  RxList<FavoritePhoto> favorite = <FavoritePhoto>[].obs;
  RxList<FavoritePhoto> favoritesPhoto = <FavoritePhoto>[].obs;

  @override
  void onInit() {
    getAllPhotos();
    super.onInit();
    initDatabase();
    getFavorites();
  }

  // final String token =
  //     "BJl0ap1V86KsHfXbjGfPS9qRjGvuyahozrf277axY6w927Ym7ph94blu";

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

  // Future getAllPhotos() async {
  //   try {
  //     final response = await http.get(
  //         Uri.parse('https://api.pexels.com/v1/search?query=nature'),
  //         headers: {
  //           'Authorization':
  //               'BJl0ap1V86KsHfXbjGfPS9qRjGvuyahozrf277axY6w927Ym7ph94blu'
  //         });
  //     if (response.statusCode == 200) {
  //       isLoading(false);
  //       // productresponsemodel.value = productResponseModelFromJson(response.body);
  //       // productresponsemodel.assignAll(productresponsemodel);
  //       // return productresponsemodel[0];
  //       final content = json.decode(response.body)['photos'];
  //       for (var item in content) {
  //         allPhotos.add(Photo.fromJson(item));
  //       }
  //     } else {
  //       print('Error: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<Database> initDatabase() async {
    String directory = await getDatabasesPath();
    String path = directory + dbName;
    var database = await openDatabase(path, version: dbVersion,
        onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $favoriteTable (
          $columnId INTEGER PRIMARY KEY,
          $columnAlt TEXT,
          $columnUrl TEXT,
          $columnPhotographer TEXT
        )
      ''');
      version = dbVersion;
    });
    return database;
  }

  Future<List<FavoritePhoto>> getFavorites() async {
    final db = await initDatabase();
    List<Map<String, dynamic>> maps = await db.query(favoriteTable);
    // var favoriteList = await db.getFavorites();
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        favoritesPhoto.add(FavoritePhoto.fromJson(maps[i]));
      }
    }
    favorite.assignAll(favoritesPhoto); // Menggunakan assignAll untuk mengisi nilai favorites
    return favoritesPhoto; // Mengembalikan nilai favoritesMovie
  }

  // Future<List<FavoritePhoto>> getFavorites() async {
  //   final db = await initDatabase();
  //   List<Map<String, dynamic>> maps = await db.query(favoriteTable);
  //   if (maps.length > 0) {
  //     for (int i = 0; i < maps.length; i++) {
  //       favoritePhoto.add(FavoritePhoto.fromJson(maps[i]));
  //     }
  //   }
  //   return favoritePhoto;
  // }

  Future<int> saveData(FavoritePhoto favoritePhoto) async {
    final db = await initDatabase();
    int result = await db.insert(favoriteTable, favoritePhoto.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    favoritesPhoto.add(favoritePhoto);
    return result;
  }

  Future<int> deleteFavorite(FavoritePhoto favoritePhoto) async {
    final db = await initDatabase();
    int result = await db.delete(favoriteTable,
        where: '$columnId = ?', whereArgs: [favoritePhoto.id]);
    favorite.remove(favoritePhoto);
    return result;
  }

  bool isFavorite(int id) {
  // Cek apakah item dengan ID tertentu sudah ada dalam daftar favorit atau tidak
  for (FavoritePhoto favoritePhoto in favorite) {
    if (favoritePhoto.id == id) {
      return true; // Item sudah ada dalam daftar favorit
    }
  }
  return false; // Item belum ada dalam daftar favorit
}


  // Future<void> delete(int id) async {
  //   String table = "user";
  //   Directory directory = await getApplicationDocumentsDirectory();
  //   String path = directory.path + "db_user";
  //   database = await openDatabase(path);

  //   // SnackBar(content: Text("Item berhasil di hapus"));
  //   try {
  //     await database!.delete(table, where: "id = ?", whereArgs: [id]);
  //     Get.snackbar("Pesan", "Item berhasil dihapus dari favorite");
  //     Get.off(FavoritePageView());
  //   } catch (e) {
  //     print("Error deleting data from the database: $e");
  //   }
  // }

  // Future<List<ProductResponseModel>> getDataUser() async {
  //   String table = "user";
  //   Directory directory = await getApplicationDocumentsDirectory();
  //   String path = directory.path + "db_user";
  //   database = await openDatabase(path);
  //   final data = await database!.query(table);
  //   List<ProductResponseModel> user =
  //       data.map((e) => ProductResponseModel.fromJson(e)).toList();
  //   return user;
  // }
}

