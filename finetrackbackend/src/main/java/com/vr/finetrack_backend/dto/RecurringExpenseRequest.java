package com.vr.finetrack_backend.dto;

import lombok.Data;

@Data
public class RecurringExpenseRequest {

    private String title;
    private Double amount;
    private String category;
    private String paymentMethod;
    private String frequency;
}