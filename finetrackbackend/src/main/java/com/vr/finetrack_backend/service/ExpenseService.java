package com.vr.finetrack_backend.service;

import com.vr.finetrack_backend.dto.*;
import com.vr.finetrack_backend.entity.Expense;
import com.vr.finetrack_backend.entity.Income;
import com.vr.finetrack_backend.entity.User;
import com.vr.finetrack_backend.exception.CustomException;
import com.vr.finetrack_backend.repository.ExpenseRepo;
import com.vr.finetrack_backend.repository.IncomeRepo;
import com.vr.finetrack_backend.repository.UserRepo;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class ExpenseService {

    private final ExpenseRepo expenseRepo;
    private final UserRepo userRepo;
    private final IncomeRepo incomeRepo;

    public ExpenseService(
            ExpenseRepo expenseRepo,
            UserRepo userRepo,
            IncomeRepo incomeRepo
    ) {
        this.expenseRepo = expenseRepo;
        this.userRepo = userRepo;
        this.incomeRepo = incomeRepo;
    }

    private User getCurrentUser() {
        String email = SecurityContextHolder
                .getContext()
                .getAuthentication()
                .getName();

        return userRepo.findByEmail(email)
                .orElseThrow(() -> new CustomException("User not found"));
    }

    public ExpenseResponse addExpense(ExpenseRequest request) {

        User currentUser = getCurrentUser();

        Expense expense = Expense.builder()
                .title(request.getTitle())
                .amount(request.getAmount())
                .category(request.getCategory())
                .paymentMethod(request.getPaymentMethod())
                .notes(request.getNotes())
                .createdAt(LocalDateTime.now())
                .user(currentUser)
                .build();

        Expense savedExpense = expenseRepo.save(expense);

        return new ExpenseResponse(
                savedExpense.getId(),
                savedExpense.getTitle(),
                savedExpense.getAmount(),
                savedExpense.getCategory(),
                savedExpense.getPaymentMethod(),
                savedExpense.getNotes(),
                savedExpense.getCreatedAt()
        );
    }

    public List<ExpenseResponse> getMyExpenses() {

        User currentUser = getCurrentUser();

        List<Expense> expenses = expenseRepo.findByUser(currentUser);

        return expenses.stream()
                .map(expense -> new ExpenseResponse(
                        expense.getId(),
                        expense.getTitle(),
                        expense.getAmount(),
                        expense.getCategory(),
                        expense.getPaymentMethod(),
                        expense.getNotes(),
                        expense.getCreatedAt()
                ))
                .toList();
    }

    public ExpenseResponse getExpenseById(Long id) {

        User currentUser = getCurrentUser();

        Expense expense = expenseRepo.findByIdAndUser(id, currentUser)
                .orElseThrow(() -> new CustomException("Expense not found"));

        return new ExpenseResponse(
                expense.getId(),
                expense.getTitle(),
                expense.getAmount(),
                expense.getCategory(),
                expense.getPaymentMethod(),
                expense.getNotes(),
                expense.getCreatedAt()
        );
    }

    public ExpenseResponse updateExpense(Long id, ExpenseRequest request) {

        User currentUser = getCurrentUser();

        Expense expense = expenseRepo.findByIdAndUser(id, currentUser)
                .orElseThrow(() -> new CustomException("Expense not found"));

        expense.setTitle(request.getTitle());
        expense.setAmount(request.getAmount());
        expense.setCategory(request.getCategory());
        expense.setPaymentMethod(request.getPaymentMethod());
        expense.setNotes(request.getNotes());

        Expense updatedExpense = expenseRepo.save(expense);

        return new ExpenseResponse(
                updatedExpense.getId(),
                updatedExpense.getTitle(),
                updatedExpense.getAmount(),
                updatedExpense.getCategory(),
                updatedExpense.getPaymentMethod(),
                updatedExpense.getNotes(),
                updatedExpense.getCreatedAt()
        );
    }

    public String deleteExpense(Long id) {

        User currentUser = getCurrentUser();

        Expense expense = expenseRepo.findByIdAndUser(id, currentUser)
                .orElseThrow(() -> new CustomException("Expense not found"));

        expenseRepo.delete(expense);

        return "Expense deleted successfully";
    }

    public DashboardResponse getDashboardData() {
        User currentUser = getCurrentUser();

        List<Expense> expenses = expenseRepo.findByUser(currentUser);
        List<Income> incomes = incomeRepo.findByUser(currentUser);

        Double totalExpense = expenses.stream()
                .mapToDouble(Expense::getAmount)
                .sum();

        Double totalIncome = incomes.stream()
                .mapToDouble(Income::getAmount)
                .sum();

        Double netBalance = totalIncome - totalExpense;

        List<ExpenseResponse> recentExpenses = expenses.stream()
                .sorted((e1, e2) ->
                        e2.getCreatedAt().compareTo(e1.getCreatedAt())
                )
                .limit(5)
                .map(expense -> new ExpenseResponse(
                        expense.getId(),
                        expense.getTitle(),
                        expense.getAmount(),
                        expense.getCategory(),
                        expense.getPaymentMethod(),
                        expense.getNotes(),
                        expense.getCreatedAt()
                ))
                .toList();

        return new DashboardResponse(
                totalIncome,
                totalExpense,
                netBalance,
                recentExpenses
        );
    }

    public AnalyticsResponse getAnalyticsData(Integer month, Integer year) {

        User currentUser = getCurrentUser();

        List<Expense> expenses = expenseRepo.findByUser(currentUser)
                .stream()
                .filter(expense ->
                        expense.getCreatedAt().getMonthValue() == month &&
                                expense.getCreatedAt().getYear() == year
                )
                .toList();

        List<Income> incomes = incomeRepo.findByUser(currentUser)
                .stream()
                .filter(income ->
                        income.getCreatedAt().getMonthValue() == month &&
                                income.getCreatedAt().getYear() == year
                )
                .toList();

        Double totalExpenses = expenses.stream()
                .mapToDouble(Expense::getAmount)
                .sum();

        Double totalIncome = incomes.stream()
                .mapToDouble(Income::getAmount)
                .sum();

        Double netBalance = totalIncome - totalExpenses;

        Map<String, Double> groupedExpenses = expenses.stream()
                .collect(Collectors.groupingBy(
                        Expense::getCategory,
                        Collectors.summingDouble(Expense::getAmount)
                ));

        List<CategoryBreakdownResponse> categoryBreakdown =
                groupedExpenses.entrySet()
                        .stream()
                        .map(entry -> new CategoryBreakdownResponse(
                                entry.getKey(),
                                entry.getValue()
                        ))
                        .toList();

        return new AnalyticsResponse(
                totalIncome,
                totalExpenses,
                netBalance,
                categoryBreakdown
        );

    }

    public AIInsightResponse getAIInsights(Integer month, Integer year) {

        User currentUser = getCurrentUser();

        List<Expense> expenses = expenseRepo.findByUser(currentUser)
                .stream()
                .filter(expense ->
                        expense.getCreatedAt().getMonthValue() == month &&
                                expense.getCreatedAt().getYear() == year
                )
                .toList();

        List<String> insights = new ArrayList<>();

        if (expenses.isEmpty()) {
            insights.add("No expenses recorded this month.");
            return new AIInsightResponse(insights);
        }

        double total = expenses.stream()
                .mapToDouble(Expense::getAmount)
                .sum();

        Map<String, Double> grouped = expenses.stream()
                .collect(Collectors.groupingBy(
                        Expense::getCategory,
                        Collectors.summingDouble(Expense::getAmount)
                ));

        Map.Entry<String, Double> topCategory =
                grouped.entrySet()
                        .stream()
                        .max(Map.Entry.comparingByValue())
                        .orElse(null);

        if (topCategory != null) {
            insights.add(
                    topCategory.getKey() +
                            " is your highest spending category."
            );

            insights.add(
                    "You spent ₹" +
                            topCategory.getValue() +
                            " on " +
                            topCategory.getKey()
            );

            double percent =
                    (topCategory.getValue() / total) * 100;

            if (percent > 50) {
                insights.add(
                        "More than half your spending is in " +
                                topCategory.getKey()
                );
            }
        }

        if (total > 10000) {
            insights.add(
                    "High spending month detected. Total ₹" + total
            );
        }

        return new AIInsightResponse(insights);
    }
}