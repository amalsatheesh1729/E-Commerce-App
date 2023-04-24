package com.example.demo;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
//every user needs only a single cart 
//we can have a singleton instance of cart object allocated to each user
public class CartController {

	@Autowired
	CartRepo cartRepo;
	
	@Autowired
	ProductProxy productProxy;
	
	@RequestMapping(method = RequestMethod.GET,path = "/cart-service/{userid}")
	CartDTO getCartOfUser(@PathVariable int userid)
	{
		CartDTO cartdto=new CartDTO();
	
		CartModel cart=cartRepo.findByUserId(userid)==null?createCartForUser(userid):cartRepo.findByUserId(userid);
		cartdto.setCart(cart);
	
		for(int id : cart.productids) {
			cartdto.products.add(productProxy.getProduct(id));
		}
		
	return cartdto;
	}
	
	private CartModel createCartForUser(int userid)
	{
		CartModel cart=new CartModel(userid);
		cartRepo.save(cart);
		return cart;
	}
	
	@RequestMapping(method = RequestMethod.PUT,path = "/cart-service/{userid}")
	CartDTO updateCart(@RequestBody CartDTO cartdto)
	{	
	
		CartModel cart=cartRepo.findByUserId(cartdto.cart.userId);
		List<Integer> productids=new ArrayList<>();
		int sum=0;
		for(ProductModel product : cartdto.getProducts()){
			sum+=product.amount;
			productids.add(product.productId);
		}
		cart.setProductids(productids);
		cart.setTotal(sum);
		cartRepo.save(cart);
		return cartdto;
	}
	
	
	
}
