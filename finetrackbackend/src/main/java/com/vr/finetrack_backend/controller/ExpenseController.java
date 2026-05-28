package com.vr.finetrack_backend.controller;

import com.vr.finetrack_backend.dto.*;
import com.vr.finetrack_backend.service.ExpenseService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/expenses")
public class ExpenseController {

    private final ExpenseService expenseService;

    public ExpenseController(ExpenseService expenseService) {
        this.expenseService = expenseService;
    }

    @PostMapping
    public ResponseEntity<ExpenseResponse> addExpense(
            @Valid @RequestBody ExpenseRequest request
    ) {
        return new ResponseEntity<>(
                expenseService.addExpense(request),
                HttpStatus.CREATED
        );
    }

    @GetMapping
    public ResponseEntity<List<ExpenseResponse>> getMyExpenses() {
        return ResponseEntity.ok(
                expenseService.getMyExpenses()
        );
    }

    @GetMapping("/expense/{id}")
    public ResponseEntity<ExpenseResponse> getExpenseById(
            @PathVariable Long id
    ) {
        return ResponseEntity.ok(
                expenseService.getExpenseById(id)
        );
    }

    @PutMapping("/expense/{id}")
    public ResponseEntity<ExpenseResponse> updateExpense(
            @PathVariable Long id,
            @Valid @RequestBody ExpenseRequest request
    ) {
        return ResponseEntity.ok(
                expenseService.updateExpense(id, request)
        );
    }

    @DeleteMapping("/expense/{id}")
    public ResponseEntity<String> deleteExpense(
            @PathVariable Long id
    ) {
        return ResponseEntity.ok(
                expenseService.deleteExpense(id)
        );
    }

    @GetMapping("/dashboard")
    public ResponseEntity<DashboardResponse> getDashboardData() {
        return ResponseEntity.ok(
                expenseService.getDashboardData()
        );
    }

    @GetMapping("/analytics")
    public ResponseEntity<AnalyticsResponse> getAnalyticsData(
            @RequestParam Integer month,
            @RequestParam Integer year
    ) {
        return ResponseEntity.ok(
                expenseService.getAnalyticsData(month, year)
        );
    }

    @GetMapping("/ai-insights")
    public ResponseEntity<AIInsightResponse> getAIInsights(
            @RequestParam Integer month,
            @RequestParam Integer year
    ) {
        return ResponseEntity.ok(
                expenseService.getAIInsights(month, year)
        );
    }
}