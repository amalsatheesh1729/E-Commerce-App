package com.example.demo;

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
@AllArgsConstructor
public class Notification
{

@Id
@GeneratedValue(strategy = GenerationType.AUTO)
int notifId; 
int userId;
boolean isRead;
String notification;

public Notification(String s,int userid)
{
	this.userId=userid;
	this.notification=s;
	this.isRead=false;
}
	
}
