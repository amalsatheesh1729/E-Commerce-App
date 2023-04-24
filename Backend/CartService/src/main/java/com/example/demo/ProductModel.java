package com.example.demo;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
@AllArgsConstructor

public class ProductModel
{
		  
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
