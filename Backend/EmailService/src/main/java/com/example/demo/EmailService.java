package com.example.demo;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class EmailService 
{
	
	@Autowired
    private JavaMailSender mailSender;

	@Autowired
	private UserProxy userProxy;
	
	
    public void sendEmail(String to, String subject, String body) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setSubject(subject);
        message.setText(body);

        mailSender.send(message);
    }
    
	@RabbitListener(queues="email_queue")
	public void rabbitlistnermethod(OrderModel od)
	{
		String subject = "Order Confirmation: Order ID " + od.orderId;
		String message = String.format("Hi %s,\n\nThis is to confirm that your order for Order ID %s is placed. "
		        + "Following are the details of your order:\n%s\n\nWe will ship to your account address within a few days.\n\nRegards,\nAmal M",
		        od.userName, od.orderId, od.details);
			
			
		User u=userProxy.findUserById(od.userid);
		sendEmail(u.getEmail(),subject,message);
	}
	

}
