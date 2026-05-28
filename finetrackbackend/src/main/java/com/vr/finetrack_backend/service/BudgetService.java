package com.vr.finetrack_backend.service;

import com.vr.finetrack_backend.dto.BudgetAlertResponse;
import com.vr.finetrack_backend.dto.BudgetRequest;
import com.vr.finetrack_backend.dto.BudgetResponse;
import com.vr.finetrack_backend.dto.BudgetSummaryResponse;
import com.vr.finetrack_backend.entity.Budget;
import com.vr.finetrack_backend.entity.Expense;
import com.vr.finetrack_backend.entity.User;
import com.vr.finetrack_backend.exception.CustomException;
import com.vr.finetrack_backend.repository.BudgetRepo;
import com.vr.finetrack_backend.repository.ExpenseRepo;
import com.vr.finetrack_backend.repository.UserRepo;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

import static java.util.stream.Collectors.toList;

@Service
public class BudgetService {

    private final BudgetRepo budgetRepo;
    private final ExpenseRepo expenseRepo;
    private final UserRepo userRepo;

    public BudgetService(
            BudgetRepo budgetRepo,
            ExpenseRepo expenseRepo,
            UserRepo userRepo
    ) {
        this.budgetRepo = budgetRepo;
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

    public BudgetResponse createBudget(BudgetRequest request) {

        User currentUser = getCurrentUser();

        Budget budget = Budget.builder()
                .category(request.getCategory())
                .limitAmount(request.getLimitAmount())
                .user(currentUser)
                .build();

        Budget savedBudget = budgetRepo.save(budget);

        return new BudgetResponse(
                savedBudget.getId(),
                savedBudget.getCategory(),
                savedBudget.getLimitAmount(),
                0.0
        );
    }

    public List<BudgetResponse> getMyBudgets() {

        User currentUser = getCurrentUser();

        List<Budget> budgets = budgetRepo.findByUser(currentUser);
        List<Expense> expenses = expenseRepo.findByUser(currentUser);

        return budgets.stream()
                .map(budget -> {
                    double spentAmount = expenses.stream()
                            .filter(expense ->
                                    expense.getCategory().equalsIgnoreCase(budget.getCategory()))
                            .mapToDouble(Expense::getAmount)
                            .sum();

                    return new BudgetResponse(
                            budget.getId(),
                            budget.getCategory(),
                            budget.getLimitAmount(),
                            spentAmount
                    );
                })
                .toList();
    }

    public BudgetResponse updateBudget(Long id, BudgetRequest request) {

        User currentUser = getCurrentUser();

        Budget budget = budgetRepo.findByIdAndUser(id, currentUser)
                .orElseThrow(() -> new CustomException("Budget not found"));

        budget.setCategory(request.getCategory());
        budget.setLimitAmount(request.getLimitAmount());

        Budget updatedBudget = budgetRepo.save(budget);

        double spentAmount = expenseRepo.findByUser(currentUser)
                .stream()
                .filter(expenses -> expenses.getCategory().equalsIgnoreCase(budget.getCategory()))
                .mapToDouble(Expense::getAmount)
                .sum();

            return new BudgetResponse(
                updatedBudget.getId(),
                updatedBudget.getCategory(),
                updatedBudget.getLimitAmount(),
                    spentAmount
        );
    }

    public String deleteBudget(Long id) {

        User currentUser = getCurrentUser();

        Budget budget = budgetRepo.findByIdAndUser(id, currentUser)
                .orElseThrow(() -> new CustomException("Budget not found"));

        budgetRepo.delete(budget);

        return "Budget deleted successfully";
    }

    public List<BudgetAlertResponse> getBudgetAlerts() {

        User currentUser = getCurrentUser();

        List<Budget> budgets = budgetRepo.findByUser(currentUser);
        List<Expense> expenses = expenseRepo.findByUser(currentUser);

        List<BudgetAlertResponse> alerts = new ArrayList<>();

        for (Budget budget : budgets) {

            double spentAmount = expenses.stream()
                    .filter(expense ->
                            expense.getCategory()
                                    .equalsIgnoreCase(budget.getCategory())
                    )
                    .mapToDouble(Expense::getAmount)
                    .sum();

            if (spentAmount > budget.getLimitAmount()) {
                alerts.add(
                        new BudgetAlertResponse(
                                budget.getCategory(),
                                budget.getLimitAmount(),
                                spentAmount,
                                "Budget exceeded"
                        )
                );
            }
        }

        return alerts;
    }

    public BudgetSummaryResponse getBudgetSummary() {

        User currentUser = getCurrentUser();

        List<Budget> budgets = budgetRepo.findByUser(currentUser);
        List<Expense> expenses = expenseRepo.findByUser(currentUser);

        double totalBudget = budgets.stream()
                .mapToDouble(Budget::getLimitAmount)
                .sum();

        double totalSpent = expenses.stream()
                .mapToDouble(Expense::getAmount)
                .sum();

        double remainingAmount = totalBudget - totalSpent;

        return new BudgetSummaryResponse(
                totalBudget,
                totalSpent,
                remainingAmount
        );
    }
}