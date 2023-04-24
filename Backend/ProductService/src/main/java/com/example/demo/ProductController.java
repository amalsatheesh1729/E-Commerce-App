package com.example.demo;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
public class ProductController {

	@Autowired
	ProductRepository productRepository;

	
	//GET METHOD TO GET PRODUCTS
	@RequestMapping(method = RequestMethod.GET, path = "/product-service/products")
	@Cacheable(value = "popularproducts" ,condition = "#root.args[0]==true" )
	public Iterable<Product> getAllProducts( @RequestParam(required=false)  boolean popular ,
			@RequestParam(required = false) String category ,
			@RequestParam(required = false) String search) {
		System.out.println("popular is !"+popular);
		System.out.println("ITH DBYIL NINNANU DATA !!!");
		
		log.info("Entered method to get all products based on request param");
		if(popular)
		return	productRepository.findAllByAvailablequantityLessThan(5);
		
		if(category!=null)
		return productRepository.findAllByProductCategory(category);
		
		if(search!=null)
		return productRepository.search(search);

		return  productRepository.findAll();
	}

	//POST METHOD TO CREATE PRODUCT
	@RequestMapping(method = RequestMethod.POST, path = "/product-service/products")
	public Product createProduct(@RequestBody Product product) {
		log.info("Entered method to create product");
		return productRepository.save(product);
	}


	
	//PUT METHOD TO UPDATE PRODUCT IN BULK
	@RequestMapping(method = RequestMethod.PUT, path = "/product-service/products/all")
	@CachePut( value = "product", key = "#productid" )
	public void updateProductinBulk(@RequestBody List<Product> products) {
		log.info("Entered method to update product");
		productRepository.saveAll(products);
	}

	//PUT METHOD TO UPDATE PRODUCT
	@RequestMapping(method = RequestMethod.PUT, path = "/product-service/products")
	@CachePut( value = "product", key = "#productid" )
	public void updateProduct(@RequestBody Product product) {
		log.info("Entered method to update product");
		productRepository.save(product);
	}
	
	//GET METHOD TO GET A PRODUCT
	@RequestMapping(method = RequestMethod.GET, path = "/product-service/products/{productid}")
	@Cacheable( value = "product", key = "#productid" )
	public Product getProduct(@PathVariable int productid) {
		System.out.println("ITH DBYIL NINNANU DATA !!!");
		log.info("Entered method to get a single product");
		return productRepository.findById(productid).get();
	}
	
	//DELETE METHOD TO DELETE A PRODUCT
	@RequestMapping(method = RequestMethod.DELETE, path = "/product-service/products/{productid}")
	@CacheEvict( value = "product", key = "#productid" )
	public void deleteProduct(@PathVariable int productid) {
		log.info("Entered method to delete a single product");
		productRepository.deleteById(productid);
	}
	

}
