package com.vr.finetrack_backend.controller;

import com.vr.finetrack_backend.dto.BudgetAlertResponse;
import com.vr.finetrack_backend.dto.BudgetRequest;
import com.vr.finetrack_backend.dto.BudgetResponse;
import com.vr.finetrack_backend.dto.BudgetSummaryResponse;
import com.vr.finetrack_backend.service.BudgetService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/budgets")
public class BudgetController {

    private final BudgetService budgetService;

    public BudgetController(BudgetService budgetService) {
        this.budgetService = budgetService;
    }

    @PostMapping
    public ResponseEntity<BudgetResponse> createBudget(
            @Valid @RequestBody BudgetRequest request
    ) {
        return new ResponseEntity<>(
                budgetService.createBudget(request),
                HttpStatus.CREATED
        );
    }

    @GetMapping
    public ResponseEntity<List<BudgetResponse>> getMyBudgets() {
        return ResponseEntity.ok(
                budgetService.getMyBudgets()
        );
    }

    @PutMapping("/{id}")
    public ResponseEntity<BudgetResponse> updateBudget(
            @PathVariable Long id,
            @Valid @RequestBody BudgetRequest request
    ) {
        return ResponseEntity.ok(
                budgetService.updateBudget(id, request)
        );
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteBudget(
            @PathVariable Long id
    ) {
        return ResponseEntity.ok(
                budgetService.deleteBudget(id)
        );
    }

    @GetMapping("/alerts")
    public ResponseEntity<List<BudgetAlertResponse>> getBudgetAlerts() {
        return ResponseEntity.ok(
                budgetService.getBudgetAlerts()
        );
    }

    @GetMapping("/summary")
    public ResponseEntity<BudgetSummaryResponse> getBudgetSummary() {
        return ResponseEntity.ok(
                budgetService.getBudgetSummary()
        );
    }
}