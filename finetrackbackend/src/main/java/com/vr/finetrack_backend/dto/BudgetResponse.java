package com.vr.finetrack_backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class BudgetResponse {

    private Long id;
    private String category;
    private Double limitAmount;
    private Double spentAmount;
}