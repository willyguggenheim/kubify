package com.kubify.example.springboot;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;

@RestController
public class HelloKubifyController {

	@RequestMapping("/")
	public String index() {
		return "Greetings from Kubify, Spring Boot edition!";
	}

}