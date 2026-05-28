package com.vr.finetrack_backend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class FinetrackBackendApplication {

	public static void main(String[] args) {
		SpringApplication.run(FinetrackBackendApplication.class, args);
	}

}
