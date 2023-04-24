package com.example.demo;
import java.text.ParseException;
import java.util.*;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.ReactiveAuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.web.context.SecurityContextRepository;
import org.springframework.security.web.server.context.ServerSecurityContextRepository;
import org.springframework.stereotype.Component;

import com.nimbusds.jose.JOSEException;
import com.nimbusds.jwt.JWTClaimsSet;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import reactor.core.publisher.Mono;

@Component
@AllArgsConstructor
@NoArgsConstructor
public class AuthenticationManager implements ReactiveAuthenticationManager {

	@Autowired
    private JWTUtil jwtUtil;

    @Override
    public Mono<Authentication> authenticate(Authentication authentication) {
        String authToken = authentication.getCredentials().toString();
        try {
			return Mono.just(jwtUtil.validateToken(authToken))
			    .filter(valid -> valid)
			    .switchIfEmpty(Mono.empty())
			    .map(valid -> {
			    	 JWTClaimsSet claimset = null;
					try {
						claimset = jwtUtil.extractAllClaims(authToken);
					} catch (ParseException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					} catch (JOSEException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}
			
			         List<String> rolesMap = new ArrayList<>(Arrays.asList(claimset.getClaim("role").toString()));
			         String username = null;
					try {
						username = jwtUtil.getUsernameFromToken(authToken);
					} catch (ParseException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (JOSEException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
			         return new UsernamePasswordAuthenticationToken(
			            username,
			            null,
			            rolesMap.stream().map(SimpleGrantedAuthority::new).collect(Collectors.toList())
			        		 );
			    });
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JOSEException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
    }
    
}