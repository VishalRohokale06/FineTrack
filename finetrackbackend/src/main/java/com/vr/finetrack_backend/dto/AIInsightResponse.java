package com.vr.finetrack_backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class AIInsightResponse {
    private List<String> insights;
}