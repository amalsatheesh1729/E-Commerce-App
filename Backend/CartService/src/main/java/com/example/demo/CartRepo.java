package com.example.demo;

import org.springframework.data.jpa.repository.JpaRepository;

public interface CartRepo extends JpaRepository<CartModel,Integer> {

	CartModel findByUserId(int userid); 
}
