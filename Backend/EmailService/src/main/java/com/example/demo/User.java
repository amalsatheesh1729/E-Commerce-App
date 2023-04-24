package com.example.demo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor

public class User 
{

	  int userId;
	  String email;
	  String password;
	  String name;
	  String address;
	  String role;
	  String profileimage;
	  String phonenumber;
	  String jwttoken;
}
