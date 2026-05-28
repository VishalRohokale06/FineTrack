package com.vr.finetrack_backend.service;

import com.vr.finetrack_backend.dto.RecurringExpenseRequest;
import com.vr.finetrack_backend.dto.RecurringExpenseResponse;
import com.vr.finetrack_backend.entity.Expense;
import com.vr.finetrack_backend.entity.RecurringExpense;
import com.vr.finetrack_backend.entity.User;
import com.vr.finetrack_backend.exception.CustomException;
import com.vr.finetrack_backend.repository.ExpenseRepo;
import com.vr.finetrack_backend.repository.RecurringExpenseRepo;
import com.vr.finetrack_backend.repository.UserRepo;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class RecurringExpenseService {

    private final RecurringExpenseRepo recurringExpenseRepo;
    private final ExpenseRepo expenseRepo;
    private final UserRepo userRepo;

    public RecurringExpenseService(
            RecurringExpenseRepo recurringExpenseRepo,
            ExpenseRepo expenseRepo,
            UserRepo userRepo
    ) {
        this.recurringExpenseRepo = recurringExpenseRepo;
        this.expenseRepo = expenseRepo;
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

    public RecurringExpenseResponse createRecurringExpense(
            RecurringExpenseRequest request
    ) {
        User currentUser = getCurrentUser();

        RecurringExpense recurringExpense = RecurringExpense.builder()
                .title(request.getTitle())
                .amount(request.getAmount())
                .category(request.getCategory())
                .paymentMethod(request.getPaymentMethod())
                .frequency(request.getFrequency())
                .nextDueDate(calculateNextDueDate(request.getFrequency()))
                .active(true)
                .user(currentUser)
                .build();

        RecurringExpense saved = recurringExpenseRepo.save(recurringExpense);

        return mapToResponse(saved);
    }

    public List<RecurringExpenseResponse> getMyRecurringExpenses() {
        User currentUser = getCurrentUser();

        return recurringExpenseRepo.findByUser(currentUser)
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    public String deleteRecurringExpense(Long id) {
        User currentUser = getCurrentUser();

        RecurringExpense recurringExpense =
                recurringExpenseRepo.findById(id)
                        .orElseThrow(() ->
                                new CustomException("Recurring expense not found")
                        );

        if (!recurringExpense.getUser().getId().equals(currentUser.getId())) {
            throw new CustomException("Unauthorized");
        }

        recurringExpenseRepo.delete(recurringExpense);

        return "Recurring expense deleted successfully";
    }

    @Scheduled(cron = "0 0 9 * * *")
    public void processRecurringExpenses() {
        LocalDate today = LocalDate.now();

        List<RecurringExpense> dueExpenses =
                recurringExpenseRepo.findByActiveTrueAndNextDueDateLessThanEqual(today);

        for (RecurringExpense recurring : dueExpenses) {
            Expense expense = Expense.builder()
                    .title(recurring.getTitle())
                    .amount(recurring.getAmount())
                    .category(recurring.getCategory())
                    .paymentMethod(recurring.getPaymentMethod())
                    .notes("Auto-generated recurring expense")
                    .createdAt(LocalDateTime.now())
                    .user(recurring.getUser())
                    .build();

            expenseRepo.save(expense);

            recurring.setNextDueDate(
                    calculateNextDueDate(recurring.getFrequency())
            );

            recurringExpenseRepo.save(recurring);
        }
    }

    private LocalDate calculateNextDueDate(String frequency) {
        LocalDate today = LocalDate.now();

        return switch (frequency.toUpperCase()) {
            case "DAILY" -> today.plusDays(1);
            case "WEEKLY" -> today.plusWeeks(1);
            case "MONTHLY" -> today.plusMonths(1);
            case "YEARLY" -> today.plusYears(1);
            default -> throw new CustomException("Invalid frequency");
        };
    }

    private RecurringExpenseResponse mapToResponse(
            RecurringExpense recurringExpense
    ) {
        return new RecurringExpenseResponse(
                recurringExpense.getId(),
                recurringExpense.getTitle(),
                recurringExpense.getAmount(),
                recurringExpense.getCategory(),
                recurringExpense.getPaymentMethod(),
                recurringExpense.getFrequency(),
                recurringExpense.getNextDueDate(),
                recurringExpense.getActive()
        );
    }
}