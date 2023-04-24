package com.example.demo;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@AllArgsConstructor
@NoArgsConstructor
@Data

@Document(indexName = "product")
public class Product {

	   @Id
	   int productId;
	   String productCategory;
	   int  price;
	   String name;
	   String description;
	   String url;
	   String ownerId;
	   int availablequantity;
	   int quantity;
	   int amount;
	
}
