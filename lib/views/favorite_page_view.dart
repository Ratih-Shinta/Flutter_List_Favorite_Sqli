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
      body: Obx(
        () => productController.favorite.isEmpty
            ? Center(
                child: Text("Wishlist is empty."),
              )
            : FutureBuilder(
                future: productController.getFavorites(),
                builder: (context, snapshot) => ListView.builder(
                  itemCount: productController.favorite.length,
                  itemBuilder: (BuildContext context, int index) {
                    final productId = productController.favorite[index];
                    return Container(
                      margin: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.03),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        image: DecorationImage(
                          image: AssetImage('assets/webcam-toy-photo43.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              padding: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
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
                                        productId.alt!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white, // Warna teks
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        productId.photographer!,
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
                                      // Aksi ketika tombol ditekan
                                    },
                                    icon: Icon(Icons.delete,
                                        color: Colors.red, size: 20),
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
              ),
      ),
    );
  }
}
