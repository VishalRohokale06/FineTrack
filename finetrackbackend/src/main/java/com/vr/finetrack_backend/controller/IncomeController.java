package com.vr.finetrack_backend.controller;

import com.vr.finetrack_backend.dto.IncomeRequest;
import com.vr.finetrack_backend.dto.IncomeResponse;
import com.vr.finetrack_backend.service.IncomeService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/income")
public class IncomeController {

    private final IncomeService incomeService;

    public IncomeController(IncomeService incomeService) {
        this.incomeService = incomeService;
    }

    @PostMapping
    public ResponseEntity<IncomeResponse> addIncome(
            @RequestBody IncomeRequest request
    ) {
        return ResponseEntity.ok(
                incomeService.addIncome(request)
        );
    }

    @GetMapping
    public ResponseEntity<List<IncomeResponse>> getMyIncome() {
        return ResponseEntity.ok(
                incomeService.getMyIncome()
        );
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteIncome(
            @PathVariable Long id
    ) {
        return ResponseEntity.ok(
                incomeService.deleteIncome(id)
        );
    }
}