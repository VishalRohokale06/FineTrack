package com.vr.finetrack_backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDate;

@Data
@AllArgsConstructor
public class RecurringExpenseResponse {

    private Long id;
    private String title;
    private Double amount;
    private String category;
    private String paymentMethod;
    private String frequency;
    private LocalDate nextDueDate;
    private Boolean active;
}