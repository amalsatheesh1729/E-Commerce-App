package com.example.demo;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@FeignClient(name ="product-service") 
public interface ProductProxy 
{

	@RequestMapping(method = RequestMethod.GET, path = "/product-service/products/{productid}")
	public ProductModel getProduct(@PathVariable int productid); 
	
	
	
}
