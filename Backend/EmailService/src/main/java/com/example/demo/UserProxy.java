package com.example.demo;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@FeignClient(name ="user-service")
public interface UserProxy 
{
	
	@RequestMapping(method = RequestMethod.GET,path = "/user-service/{userid}")
	User findUserById(@PathVariable int userid);
	

}
