package com.vr.finetrack_backend.service;

import com.vr.finetrack_backend.dto.IncomeRequest;
import com.vr.finetrack_backend.dto.IncomeResponse;
import com.vr.finetrack_backend.entity.Income;
import com.vr.finetrack_backend.entity.User;
import com.vr.finetrack_backend.exception.CustomException;
import com.vr.finetrack_backend.repository.IncomeRepo;
import com.vr.finetrack_backend.repository.UserRepo;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class IncomeService {

    private final IncomeRepo incomeRepo;
    private final UserRepo userRepo;

    public IncomeService(
            IncomeRepo incomeRepo,
            UserRepo userRepo
    ) {
        this.incomeRepo = incomeRepo;
        this.userRepo = userRepo;
    }

    private User getCurrentUser() {
        String email = SecurityContextHolder
                .getContext()
                .getAuthentication()
                .getName();

        return userRepo.findByEmail(email)
                .orElseThrow(() -> new CustomException("User not found"));
    }

    public IncomeResponse addIncome(IncomeRequest request) {
        User currentUser = getCurrentUser();

        Income income = Income.builder()
                .title(request.getTitle())
                .amount(request.getAmount())
                .category(request.getCategory())
                .paymentMethod(request.getPaymentMethod())
                .notes(request.getNotes())
                .createdAt(LocalDateTime.now())
                .user(currentUser)
                .build();

        Income saved = incomeRepo.save(income);

        return map(saved);
    }

    public List<IncomeResponse> getMyIncome() {
        User currentUser = getCurrentUser();

        return incomeRepo.findByUser(currentUser)
                .stream()
                .map(this::map)
                .toList();
    }

    public String deleteIncome(Long id) {
        User currentUser = getCurrentUser();

        Income income = incomeRepo.findByIdAndUser(id, currentUser)
                .orElseThrow(() -> new CustomException("Income not found"));

        incomeRepo.delete(income);

        return "Income deleted successfully";
    }

    private IncomeResponse map(Income income) {
        return new IncomeResponse(
                income.getId(),
                income.getTitle(),
                income.getAmount(),
                income.getCategory(),
                income.getPaymentMethod(),
                income.getNotes()
        );
    }
}