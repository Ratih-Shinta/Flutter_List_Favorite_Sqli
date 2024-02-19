import 'package:flutter/material.dart';
import 'package:flutter_list_favorite_sqli/controllers/product_controller.dart';
import 'package:get/get.dart';
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
      body: FutureBuilder(
        future: productController.getFavorites(),
        builder: (context, snapshot) {
          return Obx(
            () => ListView.builder(
              itemCount: productController.favoritesPhoto.length,
              itemBuilder: (BuildContext context, int index) {
                final favProduct = productController.favoritesPhoto[index];
                return Container(
                  margin:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    image: DecorationImage(
                      image: NetworkImage(favProduct.src!),
                      fit: BoxFit.cover,
                    ),
                  ),
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
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  favProduct.alt!,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Get.snackbar(
                                    'Delete Favorite',
                                    'Photo ${favProduct.alt} been deleted from favorite',
                                    colorText: Colors.black,
                                  );
                                  productController.deleteFavorite(favProduct);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
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
        },
      ),
    );
  }
}
