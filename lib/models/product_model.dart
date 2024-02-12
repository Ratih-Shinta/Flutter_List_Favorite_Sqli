import 'dart:convert';

import 'package:flutter_list_favorite_sqli/controllers/product_controller.dart';

List<ProductModel> productModelFromJson(String str) =>
    List<ProductModel>.from(
        json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  int? page;
  int? perPage;
  List<Photo>? photos;
  int? totalResults;
  String? nextPage;

  ProductModel({
    required this.page,
    required this.perPage,
    required this.photos,
    required this.totalResults,
    required this.nextPage,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    perPage = json['per_page'];
    if (json['photos'] != null) {
      photos = <Photo>[];
      json['photos'].forEach((v) {
        photos!.add(new Photo.fromJson(v));
      });
    }
    totalResults = json['total_Results'];
    nextPage = json['nextPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
        data ['page'] = this.page;
        data ['per_page'] = this.perPage;
        if (this.photos != null) {
          data['results'] = this.photos!.map((v) => v.toJson()).toList();
        }
        data ['total_Results'] = this.totalResults;
        data ['nextPage'] = this.nextPage;
        return data;
      }
}

class Photo {
  int? id;
  int? width;
  int? height;
  String? url;
  String? photographer;
  String? photographerUrl;
  int? photographerId;
  String? avgColor;
  Src? src;
  bool? liked;
  String? alt;

  Photo({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    required this.photographer,
    required this.photographerUrl,
    required this.photographerId,
    required this.avgColor,
    required this.src,
    required this.liked,
    required this.alt,
  });

  Photo.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      width = json['width'];
      height = json['height'];
      url = json['url'];
      photographer = json['photographer'];
      photographerUrl = json['photographer_url'];
      photographerId = json['photographer_id'];
      avgColor = json['avg_color'];
      src = Src.fromJson(json['src']);
      liked = json['liked'];
      alt = json['alt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
        data ['id'] = this.id;
        data ['width'] = this.width;
        data ['height'] = this.height;
        data ['url'] = this.url;
        data ['photographer'] = this.photographer;
        data ['photographer_url'] = this.photographerUrl;
        data ['photographer_id'] = this.photographerId;
        data ['avg_color'] = this.avgColor;
        data ['src'] = this.src;
        data ['liked'] = this.liked;
        data ['alt'] = this.alt;
        return data;
      }
}

class Src {
  String? original;
  String? large2X;
  String? large;
  String? medium;
  String? small;
  String? portrait;
  String? landscape;
  String? tiny;

  Src({
    required this.original,
    required this.large2X,
    required this.large,
    required this.medium,
    required this.small,
    required this.portrait,
    required this.landscape,
    required this.tiny,
  });

  Src.fromJson(Map<String, dynamic> json) {
      original = json['original'];
      large2X = json['large2X'];
      large = json['large'];
      medium = json['medium'];
      small = json['small'];
      portrait = json['portrait'];
      landscape = json['landscape'];
      tiny = json['tiny'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['original'] = this.original;
    data['large2X'] = this.large2X;
    data['large'] = this.large;
    data['medium'] = this.medium;
    data['small'] = this.small;
    data['portrait'] = this.portrait;
    data['landscape'] = this.landscape;
    data['tiny'] = this.tiny;
    return data;
  }
}

class FavoritePhoto {
  bool isFav(ProductController productController) {
    return productController.favorite.contains(id);
  }

  int? id;
  String? url;
  String? alt;
  String? photographer;

  FavoritePhoto({
    required this.id,
    required this.url,
    required this.alt,
    required this.photographer,
  });

  FavoritePhoto.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      url = json['url'];
      alt = json['alt'];
      photographer = json['photographer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
        data ['id'] = this.id;
        data ['url'] = this.url;
        data ['alt'] = this.alt;
        data ['photographer'] = this.photographer;
        return data;
      }
}


// class ProductColor {
//   String hexValue;
//   String colourName;

//   ProductColor({
//     required this.hexValue,
//     required this.colourName,
//   });

//   factory ProductColor.fromJson(Map<String, dynamic> json) => ProductColor(
//     hexValue: json["hex_value"],
//     colourName: json["colour_name"] == null?"" :  json["colour_name"] ,
//   );

//   Map<String, dynamic> toJson() => {
//     "hex_value": hexValue,
//     "colour_name": colourName,
//   };
// }

// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;

//   EnumValues(this.map);

//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }