

import 'package:flutter/material.dart';
import '../Models/DTO.dart';
import '../Services/cartServices.dart';


class CartProvider extends ChangeNotifier{

  CartDTO? cartDTO;

    setUserCartState(CartDTO cartDTO){
      this.cartDTO=cartDTO;
      notifyListeners();
    }


  addProductToCart(ProductModel product)
  {
    cartDTO!.products!.add(product);
    cartDTO!.cart!.total=cartDTO!.products!.map((product) => product.amount).reduce((value, element) => value + element);
    notifyListeners();
    updateUserCartToServer(cartDTO!);
  }

  removeProductFromCart(ProductModel product)
  {
    cartDTO!.products!.removeWhere((element) => element.productId==product.productId);
    cartDTO!.cart!.total=cartDTO!.products!.isEmpty?0:cartDTO!.products!.map((product) => product.amount).reduce((value, element) => value + element);
    notifyListeners();
    updateUserCartToServer(cartDTO!);
  }

  incrementProductInCart(int index)
  {
    cartDTO!.products![index].quantity++;
    cartDTO!.products![index].amount= cartDTO!.products![index].quantity*cartDTO!.products![index].price;
    cartDTO!.cart!.total=cartDTO!.products!.map((product) => product.amount).reduce((value, element) => value + element);
    notifyListeners();
  }

  decrementProductInCart(int index)
  {
    cartDTO!.products![index].quantity--;
    cartDTO!.products![index].amount= cartDTO!.products![index].quantity*cartDTO!.products![index].price;
    cartDTO!.cart!.total=cartDTO!.products!.map((product) => product.amount).reduce((value, element) => value + element);
    notifyListeners();
  }

  clearcart(){
    cartDTO!.products!.clear();
    updateUserCartToServer(cartDTO!);
    notifyListeners();
  }

}