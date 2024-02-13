import 'package:flutter/material.dart';
import 'package:flutter_list_favorite_sqli/controllers/product_controller.dart';
import 'package:flutter_list_favorite_sqli/models/product_model.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritePageView extends StatelessWidget {
  final productController = Get.put(ProductController());
  FavoritePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Favorite Page',
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
                    final favProduct = productController.favorite[index];
                    return Container(
                      margin: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.03),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        image: DecorationImage(
                          // image: CachedNetworkImageProvider(favProduct.url),
                          image: AssetImage('assets/webcam-toy-photo43.jpg'),
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
                                        favProduct.alt,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white, // Warna teks
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        favProduct.photographer,
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
                                      if (productController
                                          .isFavorite(favProduct.id)) {
                                        Get.snackbar(
                                          'Saved',
                                          '${favProduct.alt} has been saved to favorite',
                                          snackPosition: SnackPosition.TOP,
                                          colorText: Colors.black,
                                        );
                                        FavoritePhoto favoritePhoto =
                                            FavoritePhoto(
                                          id: favProduct.id,
                                          url: favProduct.url,
                                          alt: favProduct.alt,
                                          photographer: favProduct.photographer,
                                        );
                                        productController
                                            .saveData(favoritePhoto);
                                      } else {
                                        // Menampilkan pesan jika produk sudah ada dalam daftar favorit
                                        Get.snackbar(
                                          'Already Saved',
                                          '${favProduct.alt} is already in favorite',
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
      );
  }
}
