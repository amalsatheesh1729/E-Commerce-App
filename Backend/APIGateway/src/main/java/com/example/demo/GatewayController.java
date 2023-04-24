package com.example.demo;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.server.ResponseStatusException;

import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;
@RestController
@Slf4j
public class GatewayController 
{

	@Autowired
	private DBUserDetailService userDetailService;
	
	@Autowired
	private JWTUtil jwtUtil;
	
	BCryptPasswordEncoder encoder=new BCryptPasswordEncoder();
	
	 @Autowired
	 private WebClient.Builder webClientBuilder;
	 
	 @RequestMapping(path = "/login", method = RequestMethod.POST)
	 public Mono<UserPOJO> login(@RequestBody AuthRequest ar) {
	     return userDetailService.findByUsername(ar.getEmail())
	             .filter(userDetails -> encoder.matches(ar.getPassword(), userDetails.getPassword()))
	             .flatMap(userDetails -> {
	                 return webClientBuilder.build()
	                         .get()
	                         .uri("lb://user-service/user-service/users/{email}", ar.getEmail())
	                         .retrieve()
	                         .bodyToMono(UserPOJO.class)
	                         .map(userPojo -> {
	                             userPojo.setJwttoken(jwtUtil.generateToken(userDetails));
	                             return userPojo;
	                         });
	             })
	             .switchIfEmpty(Mono.error(new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid credentials.")));
	 }

	@RequestMapping(path = "/logup", method = RequestMethod.POST)
	public Mono<UserPOJO> logup(@RequestBody UserPOJO user) {
		user.setPassword(encoder.encode(user.getPassword()));
		user.setRole("user");
		return  webClientBuilder.build().post().
				uri("lb://user-service/user-service/users").body(Mono.just(user), UserPOJO.class)
				.retrieve()
				.bodyToMono(UserPOJO.class);
					
	}
	
	
}
