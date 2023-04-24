package com.example.demo;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import lombok.extern.slf4j.Slf4j;

@RestController
@EnableDiscoveryClient
@Slf4j
public class UserController {

	@Autowired
	UserRepository userrepo;

	// get-all users
	@RequestMapping(method = RequestMethod.GET, path = "/user-service/users")
	List<User> getallusers() {
		log.info("Enter Method to get all users ");
		return userrepo.findAll();

	}

	// get-user by email
	@RequestMapping(method = RequestMethod.GET, path = "/user-service/users/{email}")
	User getUserByEmail(@PathVariable String email) {
		log.info("Enter Method to get user by email ");
		return userrepo.findByEmail(email);
	}

	// get-user by user-id
	@RequestMapping(method = RequestMethod.GET, path = "/user-service/{userid}")
	User findUserById(@PathVariable int userid) {
		log.info("Enter Method to get user by userid ");
		return userrepo.findById(userid).get();
	}

	// add a user
	@RequestMapping(method = RequestMethod.POST, path = "/user-service/users")
	User addUser(@RequestBody User user) {
		log.info("Enter Method to get add a user ");
		try {
			if (userrepo.findByEmail(user.getEmail()) == null)
				return userrepo.save(user);

			throw new Exception("User Already Exists In The Database.");
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
		log.info("User already in DB ");
		return null;
	}

	// update an user
	@RequestMapping(method = RequestMethod.PUT, path = "/user-service/users")
	User updateUser(@RequestBody User user) {
		log.info("Enter Method to get update a user ");
		return userrepo.save(user);
	}

	// delete an user
	@RequestMapping(method = RequestMethod.DELETE, path = "/user-service/users/delete/{userid}")
	void deleteUserById(@PathVariable int userid) {
		log.info("Enter Method to delete user by userid ");
		userrepo.deleteById(userid);

	}

}
