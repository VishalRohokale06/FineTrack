package com.vr.finetrack_backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class BudgetRequest {

    @NotBlank
    private String category;

    @NotNull
    private Double limitAmount;
}