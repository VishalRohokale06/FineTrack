package com.vr.finetrack_backend.controller;

import com.vr.finetrack_backend.dto.RecurringExpenseRequest;
import com.vr.finetrack_backend.dto.RecurringExpenseResponse;

import com.vr.finetrack_backend.service.RecurringExpenseService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/recurring-expenses")
public class RecurringExpenseController {

    private final RecurringExpenseService recurringExpenseService;

    public RecurringExpenseController(
            RecurringExpenseService recurringExpenseService
    ) {
        this.recurringExpenseService = recurringExpenseService;
    }

    @PostMapping
    public ResponseEntity<RecurringExpenseResponse> create(
            @RequestBody RecurringExpenseRequest request
    ) {
        return ResponseEntity.ok(
                recurringExpenseService.createRecurringExpense(request)
        );
    }

    @GetMapping
    public ResponseEntity<List<RecurringExpenseResponse>> getAll() {
        return ResponseEntity.ok(
                recurringExpenseService.getMyRecurringExpenses()
        );
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> delete(@PathVariable Long id) {
        return ResponseEntity.ok(
                recurringExpenseService.deleteRecurringExpense(id)
        );
    }
}