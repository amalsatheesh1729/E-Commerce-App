package com.example.demo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.web.server.SecurityWebFilterChain;
import org.springframework.web.cors.reactive.UrlBasedCorsConfigurationSource;



@Configuration
@EnableWebFluxSecurity
public class WebSecurityConfig {

	@Autowired
    private AuthenticationManager authenticationManager;
	
	@Autowired
    private SecurityContextRepository securityContextRepository;
	
	@Autowired
	private org.springframework.web.cors.reactive.CorsConfigurationSource urlbasedcustomcors;
	
	@Bean
	public SecurityWebFilterChain securityFilterChain(ServerHttpSecurity http) throws Exception {
		 return http.csrf().disable().cors().configurationSource(urlbasedcustomcors).and().
	                 authorizeExchange()
	                .pathMatchers(new String[]{"/login","/logup"}).permitAll()
	                .anyExchange().authenticated().and()
	                .authenticationManager(authenticationManager)
	                .securityContextRepository(securityContextRepository)
	                .build();
	}
	
	   	

}
