package com.vr.finetrack_backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class BudgetSummaryResponse {

    private Double totalBudget;
    private Double totalSpent;
    private Double remainingAmount;
}