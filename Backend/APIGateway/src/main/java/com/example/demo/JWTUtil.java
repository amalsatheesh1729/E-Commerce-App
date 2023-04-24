package com.example.demo;
import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import com.nimbusds.jose.JOSEException;
import com.nimbusds.jose.JWSAlgorithm;
import com.nimbusds.jose.JWSHeader;
import com.nimbusds.jose.KeyLengthException;
import com.nimbusds.jose.crypto.MACSigner;
import com.nimbusds.jose.crypto.MACVerifier;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;

@Component
public class JWTUtil {


	private static final String SECRET_KEY = "z%C*F-JaNcRfUjXn2r5u8x/A?D(G+KbPeSgVkYp3s6v9y$B&E)H@McQfTjWmZq4t";


	 public String getUsernameFromToken(String token) throws ParseException, JOSEException {
	        return extractAllClaims(token).getSubject();
	  }


    public Date getExpirationDateFromToken(String token) throws ParseException, JOSEException {
    	 return extractAllClaims(token).getExpirationTime();
    }

    private Boolean isTokenExpired(String token) throws ParseException, JOSEException {
        final Date expiration = getExpirationDateFromToken(token);
        System.out.println("The expiration Date is :"+expiration);
        System.out.println(expiration.before(new Date()));
        return expiration.before(new Date());
    }

    public String generateToken(UserDetails userDetails) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("role", userDetails.getAuthorities().toArray()[0]);
        return createToken(claims, userDetails.getUsername());
    }

    JWTClaimsSet extractAllClaims(String token) throws ParseException, JOSEException {
    	SignedJWT parsedJWT = SignedJWT.parse(token);
        return parsedJWT.getJWTClaimsSet();
    }


    public Boolean validateToken(String token) throws ParseException, JOSEException {
    	MACVerifier macVerifier = new MACVerifier(SECRET_KEY.getBytes());
    	SignedJWT parsedJWT = SignedJWT.parse(token);
        boolean isVerified = parsedJWT.verify(macVerifier);
        return (isVerified);
        //As of now not checking expiration . Ideally isVerified && isTokenExpired must be checked 
    }


    public String generateToken(String userName){
        Map<String,Object> claims=new HashMap<>();
        return createToken(claims,userName);
    }
    
    

    private String createToken(Map<String, Object> claims, String userName) {
    	JWTClaimsSet claimsSet= new JWTClaimsSet.Builder().subject(userName).issuer("amaluttan").
            issueTime(new Date()).expirationTime(new Date(new Date().getTime()/1000 + 3600)).
        	claim("customclaim", "verthe oru claim").claim("role",claims.get("role")).
        	build();
                
        SignedJWT signedJWT = new SignedJWT(new JWSHeader(JWSAlgorithm.HS256), claimsSet);  
        
        MACSigner macSigner = null;
		try {
			macSigner = new MACSigner(SECRET_KEY.getBytes());
		} catch (KeyLengthException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        try {
			signedJWT.sign(macSigner);
		} catch (JOSEException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
        return signedJWT.serialize();
        
    }
}