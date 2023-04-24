import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_web/razorpay_web.dart';
import 'package:simple_online_store/DRY.dart';
import 'package:simple_online_store/Providers/UserProvider.dart';
import '../Models/DTO.dart';
import '../Providers/CartProvider.dart';
import '../Services/ProductServices.dart';
import '../Services/orderServices.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}


class _CartScreenState extends State<CartScreen> {
  List<ProductModel> products = [];
  CartModel? cart;
  CartDTO? cartDTO;
  CartProvider? cartstate;


  @override
  Widget build(BuildContext context) {
    cartstate = context.watch<CartProvider>();
    cartDTO = context
        .watch<CartProvider>()
        .cartDTO;

    if (cartDTO == null) {
      return const CircularProgressIndicator();
    }

    cart = cartDTO!.cart;
    products = cartDTO!.products!;

    return Scaffold(
        appBar: const AppBarCommon(),
        body: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.purple),
            borderRadius: BorderRadius.circular(60),
          ),
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery
                  .of(context)
                  .size
                  .width / 5,
              vertical: MediaQuery
                  .of(context)
                  .size
                  .height / 10),
          child: products.isEmpty ? CachedNetworkImage(
            imageUrl: 'https://mir-s3-cdn-cf.behance.net/projects/404/95974e121862329.Y3JvcCw5MjIsNzIxLDAsMTM5.png',
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ) :
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 3,
                child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                                child: Image.network(products[index].url)
                            ),
                            Flexible(child: Text(products[index].name)),
                            const SizedBox(width: 10),
                            Flexible(
                                child: IconButton(
                                    icon: const Icon(Icons.add), onPressed: () {
                                  if (products[index].quantity <
                                      products[index].availablequantity)
                                    cartstate!.incrementProductInCart(index);
                                  else
                                    showSnack(context,
                                        "You have exceeded the maximum available product",
                                        Colors.red);
                                })),
                            Flexible(
                                child: Text('${products[index].quantity}')),
                            Flexible(
                                child: IconButton(
                                    icon: Icon(Icons.remove), onPressed: () {
                                  if (products[index].quantity == 1) {
                                    cartstate!.removeProductFromCart(
                                        products[index]);
                                  }
                                  else {
                                    cartstate!.decrementProductInCart(index);
                                  }
                                }
                                )),
                            Flexible(
                                flex: 1,
                                child: Text('${products[index].amount}')),
                            const SizedBox(width: 10),
                          ]
                      );
                    }),
              ),
              Flexible(
                  flex: 1,
                  child: Text(
                    'The total is : ${cart!.total}', style: const TextStyle(
                      color: Colors.green,
                      fontSize: 25,
                      fontWeight: FontWeight.w200
                  ),)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SuccessButton(
                      title: 'Pay With Razorpay', onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Alert !!!",
                              style: TextStyle(color: Colors.red),),
                            content: const Text(
                                "Razor Pay is available in test mode only due to KYC issues . No actual money will be debited."
                                    "Please choose pay  later with kotak bank and mark the txn as success or failure"),
                            actions: [
                              // Ok button
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  payWithRazorPay(); // dismiss dialog
                                },
                              ),
                              // Cancel button
                              TextButton(
                                child: Text("CANCEL"),
                                onPressed: () {
                                  Navigator.of(context).pop(); // dismiss dialog
                                },
                              ),
                            ],
                          );
                        });
                  })
                ],
              )
            ],),
        )
    );
  }


  payWithRazorPay() {
    Razorpay razorpay = Razorpay();
    var options = {
      'key': 'rzp_test_L4pVBmjy3cTQit',
      'amount': '${cart!.total! * 100}',
      'name': '${context
          .read<UserProvider>()
          .userModel!
          .name}',
      'description': 'Products in Cart',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '${context
          .read<UserProvider>()
          .userModel!
          .phonenumber}',
        'email': '${context
            .read<UserProvider>()
            .userModel!
            .email}'},
      'external': {
        'wallets': ['paytm']
      }
    };
    razorpay.open(options);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
        handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
        handleExternalWalletSelected);
  }


  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response
            .message}\nMetadata:${response.message.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */

    placeorderafterpayment(response);
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void placeorderafterpayment(PaymentSuccessResponse response) {
    String orderdetail = "";
    for (var product in products) {
      orderdetail += "\n ${product.quantity} quantities of ${product.name}";
      product.availablequantity = product.availablequantity - product.quantity;
      product.quantity = 1;
      product.amount = product.price;
      updateProductToServer(product);
    }
    OrderModel order = OrderModel(
        userName: context
            .read<UserProvider>()
            .userModel!
            .name,
        userid: context
            .read<UserProvider>()
            .userModel!
            .userId,
        dateTime: DateTime.now().toString(),
        details: orderdetail,
        orderstatus: 'Placed',
        paymentinfo: 'Paid via Razorpay : ${response.paymentId}',
        totalordervalue: cart!.total
    );

    cartstate!.clearcart();
    showDialog(context: context, builder: (context) {
      return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40)),
          elevation: 16,
          child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 2,
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              padding: const EdgeInsets.all(50),
              child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    const Text('YOUR ORDER HAS BEEN PLACED SUCCESFULLY',
                        style: TextStyle(
                            color: Colors.green
                        )),
                    Text('\n\nOrder Place By  : ${order.userName}'),
                    Text('\n\nOrder Placed At  : ${order.dateTime.toString()}'),
                    Text('\n\nOrder Details : ${order.details}'),
                    Text('\n\nOrder Status : ${order.orderstatus}'),
                    Text('\n\nOrder Payment Status : ${order.paymentinfo}'),
                    Text('\n\nOrder Total : Rupees ${order.totalordervalue}'),
                    SizedBox(height: 30),
                    SuccessButton(title: 'Continue Shopping', onPressed: () {
                      Navigator.pushNamed(context, '/products');
                    })
                  ]
              )));
    });
    placeOrder(order);
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Ok"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}


