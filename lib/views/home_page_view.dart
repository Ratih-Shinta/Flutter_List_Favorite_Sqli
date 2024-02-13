import 'package:flutter/material.dart';
import 'package:flutter_list_favorite_sqli/controllers/product_controller.dart';
import 'package:flutter_list_favorite_sqli/models/product_model.dart';
import 'package:flutter_list_favorite_sqli/views/favorite_page_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePageView extends StatelessWidget {
  final productController = Get.put(ProductController());

  HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Photos List',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        return productController.isLoading.value
            ? CircularProgressIndicator()
            : FutureBuilder(
                future: productController.getAllPhotos(),
                builder: (context, snapshot) => ListView.builder(
                  itemCount: productController.allPhotos.length,
                  itemBuilder: (BuildContext context, int index) {
                    final product = productController.allPhotos[index];
                    return Container(
                      margin: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.03),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        image: DecorationImage(
                          // image: CachedNetworkImageProvider(product.url),
                          image: Image.network(product.url!).image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              padding: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.8),
                                    Colors.black.withOpacity(0.6),
                                    Colors.black.withOpacity(0.0),
                                  ],
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.alt,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white, // Warna teks
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        product.photographer,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white, // Warna teks
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // Memeriksa apakah produk sudah ada dalam daftar favorit atau tidak
                                      if (!productController
                                          .isFavorite(product.id)) {
                                        Get.snackbar(
                                          'Saved',
                                          '${product.alt!} has been saved to favorite',
                                          snackPosition: SnackPosition.TOP,
                                          colorText: Colors.black,
                                        );
                                        FavoritePhoto favoritePhoto =
                                            FavoritePhoto(
                                          id: product.id,
                                          url: product.url,
                                          alt: product.alt,
                                          photographer: product.photographer,
                                        );
                                        productController
                                            .saveData(favoritePhoto);
                                      } else {
                                        // Menampilkan pesan jika produk sudah ada dalam daftar favorit
                                        Get.snackbar(
                                          'Already Saved',
                                          '${product.alt!} is already in favorite',
                                          snackPosition: SnackPosition.TOP,
                                          colorText: Colors.black,
                                        );
                                      }
                                    },
                                    icon: Icon(Icons.favorite_border_outlined,
                                        color: Colors.white, size: 25),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () {
          Get.to(FavoritePageView());
        },
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
          child: Icon(
            Icons.favorite,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
