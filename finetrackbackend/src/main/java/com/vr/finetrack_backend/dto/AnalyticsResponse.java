package com.vr.finetrack_backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class AnalyticsResponse {

    private Double totalIncome;
    private Double totalExpenses;
    private Double netBalance;
    private List<CategoryBreakdownResponse> categoryBreakdown;
}