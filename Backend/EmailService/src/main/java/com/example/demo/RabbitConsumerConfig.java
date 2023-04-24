package com.example.demo;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.amqp.support.converter.MessageConverter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;



@Configuration
public class RabbitConsumerConfig {
	

	@Bean
	public static MessageConverter jsonMessageConverter() {
		return new Jackson2JsonMessageConverter();
	}

	
}



    
	
