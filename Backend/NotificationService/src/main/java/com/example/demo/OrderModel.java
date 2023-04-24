package com.example.demo;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class OrderModel
{
	  
	  int orderId;
	  int userid;
	  String userName;
	  String dateTime;
	  String details;
	  String orderstatus;
	  String paymentinfo;
	  int totalordervalue;
	  
	  
	  
	  public OrderModel(String userName,String details,String orderStatus,String paymentinfo,int totalordervalue,String dateTime,int userid)
	  {
		  this.dateTime = dateTime;
		  this.userName=userName;
		  this.userid=userid;
		  this.details=details;
		  this.orderstatus=orderStatus;
		  this.paymentinfo=paymentinfo;
		  this.totalordervalue=totalordervalue;
	  }
}



enum OrderStatus{
	  Placed,
	  Shipped,
	  OutForDelivery,
	  Completed,
}


enum PaymentStatus{
	 Unpaid,
	 Pending,
	 Paid
}