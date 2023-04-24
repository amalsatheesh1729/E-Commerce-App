package com.example.demo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextImpl;
import org.springframework.security.web.server.context.ServerSecurityContextRepository;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;


@Component
public class SecurityContextRepository implements ServerSecurityContextRepository {

	@Autowired
    private AuthenticationManager authenticationManager;

    @Override
    public Mono<Void> save(ServerWebExchange swe, SecurityContext sc) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    
    @Override
    public Mono<SecurityContext> load(ServerWebExchange swe) {
    	return Mono.justOrEmpty(swe.getRequest().getHeaders().getFirst(org.springframework.http.HttpHeaders.AUTHORIZATION))
    	        .filter(authHeader -> authHeader.startsWith("Bearer "))
    	        .flatMap(authHeader -> {
    	            String authToken = authHeader.substring(7);
    	            Authentication auth = new UsernamePasswordAuthenticationToken(authToken, authToken);
    	            return authenticationManager.authenticate(auth).map(SecurityContextImpl::new);
    	        });
    }

	
}
