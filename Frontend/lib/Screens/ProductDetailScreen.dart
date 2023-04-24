import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_online_store/DRY.dart';
import 'package:simple_online_store/Providers/CartProvider.dart';
import '../Models/DTO.dart';
import '../Services/ProductServices.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';

class ProductDetailScreen extends StatefulWidget {
  ProductDetailScreen({Key? key, required this.productid}) : super(key: key);

  int productid;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductModel? product;

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  getProduct() async {
    product = await getProductFromServer(widget.productid);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cartState=context.watch<CartProvider>();
    return Scaffold(
        appBar:const AppBarCommon(),
        body: product == null
            ? const CircularProgressIndicator()
            : Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.purple),
                  borderRadius: BorderRadius.circular(60),
                ),
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width>=600?MediaQuery.of(context).size.width / 5:1,
                    vertical: MediaQuery.of(context).size.height / 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                        flex: 2,
                        child: Image.network('${product!.url}')),
                    Flexible(
                        child: Text(
                      '${product!.name}',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
                    )),
                    Flexible(
                      child: Container(
                        width: MediaQuery.of(context).size.width/3,
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.width / 50,
                            horizontal:
                                MediaQuery.of(context).size.height / 50),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.purple),
                          borderRadius: BorderRadius.circular(60),
                        ),
                            child: SingleChildScrollView(
                              child: Text(
                          '${product!.description}',
                          overflow: TextOverflow.clip,
                        ),
                            ))),
                    !cartState.cartDTO!.products!.any((element) => element.productId==product!.productId)
                        ? Flexible(
                            child: SuccessButton(
                                title: 'Add To Cart',
                                onPressed: () {
                                    cartState.addProductToCart(product!);
                                }))
                        : Flexible(
                        child:WarningButton(
                            onPressed: () {
                                cartState.removeProductFromCart(product!);
                            },
                            title: "Remove From Cart",
                          )),
                  ],
                ),
              ));
  }
}
