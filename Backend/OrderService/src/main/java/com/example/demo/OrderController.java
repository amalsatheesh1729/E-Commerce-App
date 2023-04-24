package com.example.demo;

import java.util.List;
import java.util.Optional;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class OrderController {

	@Autowired
	private OrderRepo orderRepo;
	
	@Autowired
	private AmqpTemplate rabbitTemplate;
	
	//For Admin Onlyto see all 
	@RequestMapping(method = RequestMethod.GET,path = "/order-service/orders")
	 List<OrderModel> getAllOrdersForAdmin(){
		 return orderRepo.findAll();
	 }
	
	//For Users to get their orders
	@RequestMapping(method = RequestMethod.GET,path = "/order-service/orders/users/{userid}")
	 List<OrderModel> getAllOrdersForUser(@PathVariable int userid){
		return orderRepo.findAllByuserid(userid);
	 }
	 
	 @RequestMapping(method = RequestMethod.GET,path = "/order-service/orders/{orderid}")
	 Optional<OrderModel> getOrderById(@PathVariable int orderid)
	 {
		 return orderRepo.findById(orderid);
	 }
	
	@RequestMapping(method = RequestMethod.POST,path = "/order-service/orders")
	OrderModel createOrder(@RequestBody OrderModel ordermodel)
	 {
		OrderModel order= orderRepo.save(ordermodel);
		//we send message to rabbitMQ queue
		//ideally all these logic should be in a service interface/implementation logic
		rabbitTemplate.convertAndSend("order_exchange","order_routing_key",ordermodel);
		rabbitTemplate.convertAndSend("order_exchange","email_routing_key",ordermodel);
		return order;
	 }
	  
	
	  
}
