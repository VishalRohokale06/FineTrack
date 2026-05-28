package com.vr.finetrack_backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
public class ExpenseResponse {

    private Long id;
    private String title;
    private Double amount;
    private String category;
    private String paymentMethod;
    private String notes;
    private LocalDateTime createdAt;
}