package com.vr.finetrack_backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class BudgetAlertResponse {

    private String category;
    private Double budgetLimit;
    private Double spentAmount;
    private String message;
}