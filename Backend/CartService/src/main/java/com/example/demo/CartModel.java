package com.example.demo;
import java.util.ArrayList;
import java.util.List;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
@Entity
public class CartModel 
{
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	int cartId;
	int userId;
	List<Integer> productids;
	int total;
	
	
	public CartModel(int userid)
	{
		this.userId=userid;
		total=0;
		productids=new ArrayList<Integer>();
	}
}
