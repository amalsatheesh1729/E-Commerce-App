package com.example.demo;

import java.util.ArrayList;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
@AllArgsConstructor

public class CartDTO
{
	
	CartModel cart;
	ArrayList<ProductModel> products=new ArrayList<>();
	
}
