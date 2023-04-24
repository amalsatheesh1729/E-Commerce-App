package com.example.demo;

import java.util.List;

import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class NotificationController {

	@Autowired
	private NotificationRepo notificationRepo;

	@RequestMapping(method = RequestMethod.GET, path = "/notification-service/notifications/{userid}")
	public List<Notification> getOrderNotificationForUser(@PathVariable int userid) {
		return notificationRepo.findAllByUserIdAndIsRead(userid, false);
	}

	@RequestMapping(method = RequestMethod.PUT, path = "/notification-service/notifications/{notifid}")
	public  Notification updateOrderNotificationForUser(@PathVariable int notifid) {
		       Notification n= notificationRepo.findById(notifid).get();
		       n.isRead=true;
			   notificationRepo.save(n);
			   return n;
	}
	
	@RabbitListener(queues = "order_queue")
	void rabbitlistnermethod(OrderModel od) {

		String s = "Your notification for order with order id : " + od.orderId + " placed at "+od.dateTime; 
		Notification n = new Notification(s, od.userid);
		notificationRepo.save(n);
	}

}
