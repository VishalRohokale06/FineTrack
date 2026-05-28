package com.vr.finetrack_backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class ExpenseRequest {

    @NotBlank
    private String title;

    @NotNull
    private Double amount;

    @NotBlank
    private String category;

    @NotBlank
    private String paymentMethod;

    private String notes;
}
