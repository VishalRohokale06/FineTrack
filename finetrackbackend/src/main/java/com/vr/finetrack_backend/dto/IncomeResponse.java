package com.vr.finetrack_backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class IncomeResponse {

    private Long id;
    private String title;
    private Double amount;
    private String category;
    private String paymentMethod;
    private String notes;
}