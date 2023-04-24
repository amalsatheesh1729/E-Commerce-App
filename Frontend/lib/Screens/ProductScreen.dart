import 'package:flutter/material.dart';
import 'package:simple_online_store/DRY.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../Models/DTO.dart';
import '../Services/ProductServices.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductScreen extends StatefulWidget {
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<ProductModel> products = [];
  List<ProductModel> cacheproducts = [];
  TextEditingController _searchController = TextEditingController();
  static var categories = [
    'All Products',
    'Pickle',
    'Cake',
    'Snacks',
    'Fruits',
    'Vegetables',
  ];

  String _selectedCategory = categories[0];

  @override
  void initState() {
    super.initState();
    fetchproducts(1);
  }

  fetchproducts(int choice, {String? search, String? category}) async {
    products =
        await getProductsFromServer(choice, search: search, category: category);
    cacheproducts = await getProductsFromServerForCache();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCommon(),
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("./lib/assets/cover3.jpg")),
          ),
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width>=600?MediaQuery.of(context).size.width / 5:1,
                vertical: MediaQuery.of(context).size.height / 15),
            child: ListView(
              children: [
                Text(
                  'Redis Cache of most popular products  i.e products with available quantity<5  !!!',
                  style: const TextStyle(
                      color: Colors.green,
                      fontSize: 15,
                      fontStyle: FontStyle.italic),
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 2),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.5,
                    height: 400,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                  ),
                  items: cacheproducts.map((product) {
                    return Builder(
                      builder: (BuildContext context) {
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, '/products/${product.productId}',
                                arguments: '${product.productId}');
                          },
                          child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: CachedNetworkImage(
                                imageUrl: product.url,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )),
                        );
                      },
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      value.isEmpty
                          ? fetchproducts(1)
                          : fetchproducts(3, search: value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Elastic Search...',
                      // Add a clear button to the search bar
                      suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            fetchproducts(1);
                            setState(() {});
                          }),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    )),
                SizedBox(
                  height: 25,
                ),
                DropdownButton<String>(
                    alignment: Alignment.topLeft,
                    value: _selectedCategory,
                    icon: const Icon(Icons.arrow_drop_down_outlined),
                    iconSize: 24,
                    elevation: 16,
                    autofocus: false,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                      value != 'All Products'
                          ? fetchproducts(2, category: value)
                          : fetchproducts(1);
                    },
                    items: categories
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()),
                SizedBox(
                  height: 25,
                ),
                products.isEmpty
                    ? CircularProgressIndicator()
                    : GridView.builder(
                        physics:
                            const ScrollPhysics(), // to disable GridView's scrolling
                        shrinkWrap: true,
                        gridDelegate:
                             SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: MediaQuery.of(context).size.width>=600?3:2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 20),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(context,
                                  '/products/${products[index].productId}',
                                  arguments: '${products[index].productId}');
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                shape: BoxShape.rectangle,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                      flex: 3,
                                      child: CachedNetworkImage(
                                        imageUrl: products[index].url,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      )),
                                  Flexible(
                                      flex: 1,
                                      child: Text(
                                        '${products[index].name}',
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w200),
                                      )),
                                  Flexible(
                                      flex: 1,
                                      child: Text(
                                        '\u20B9 ${products[index].price}',
                                        style: TextStyle(fontSize: 16.0),
                                      ))
                                ],
                              ),
                            ),
                          );
                        },
                      )
              ],
            ),
          )),
    );
  }
}
