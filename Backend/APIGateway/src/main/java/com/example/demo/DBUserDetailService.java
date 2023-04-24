package com.example.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.userdetails.ReactiveUserDetailsService;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;


@Data
@AllArgsConstructor
@NoArgsConstructor
@Component
public class DBUserDetailService implements ReactiveUserDetailsService  {

	 @Autowired
	 private WebClient.Builder webClientBuilder;
	
	 BCryptPasswordEncoder encoder=new BCryptPasswordEncoder();
	
	@Override
	public Mono<UserDetails> findByUsername(String email) {
		return webClientBuilder.build()
	            .get()
	            .uri("http://user-service/user-service/users/{email}", email)
	            .retrieve()
	            .bodyToMono(UserPOJO.class)
	            .flatMap(userPojo -> {
	                if (userPojo == null) {
	                    return Mono.error(new UsernameNotFoundException("User not found"));
	                }
	                User user = new User(userPojo.getEmail(), userPojo.getPassword(),
	                                      AuthorityUtils.commaSeparatedStringToAuthorityList(userPojo.getRole()));
	                return Mono.just(user);
	            });
	}

}
