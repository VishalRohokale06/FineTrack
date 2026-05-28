package com.vr.finetrack_backend.service;


import com.vr.finetrack_backend.dto.AuthResponse;
import com.vr.finetrack_backend.dto.LoginRequest;
import com.vr.finetrack_backend.dto.RegisterRequest;
import com.vr.finetrack_backend.entity.User;
import com.vr.finetrack_backend.repository.UserRepo;
import com.vr.finetrack_backend.security.JwtService;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final JwtService jwtService;
    private final UserRepo userRepository;
    private final PasswordEncoder passwordEncoder;

    public AuthService(
            JwtService jwtService,
            UserRepo userRepository,
            PasswordEncoder passwordEncoder
    ) {
        this.jwtService = jwtService;
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public AuthResponse register(RegisterRequest request) {

        if (userRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("Email already registered");
        }

        User user = User.builder()
                .fullName(request.getFullName())
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .build();

        userRepository.save(user);

        String token = jwtService.generateToken(user.getEmail());

        return new AuthResponse(
                token,
                "User registered successfully"
        );
    }

    public AuthResponse login(LoginRequest request) {

        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new IllegalArgumentException("Invalid password");
        }

        String token = jwtService.generateToken(user.getEmail());

        return new AuthResponse(
                token,
                "Login successful"
        );
    }
}