package com.vr.finetrack_backend.service;

import com.vr.finetrack_backend.entity.Expense;
import com.vr.finetrack_backend.entity.Income;
import com.vr.finetrack_backend.entity.User;

import com.vr.finetrack_backend.repository.ExpenseRepo;
import com.vr.finetrack_backend.repository.IncomeRepo;
import com.vr.finetrack_backend.repository.UserRepo;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FinanceContextService {

    private final UserRepo userRepo;
    private final ExpenseRepo expenseRepository;
    private final IncomeRepo incomeRepository;

    public String buildContext() {

        String email =
                SecurityContextHolder.getContext()
                        .getAuthentication()
                        .getName();

        User user =
                userRepo.findByEmail(email)
                        .orElseThrow();

        List<Expense> expenses =
                expenseRepository.findByUser(user);

        List<Income> incomes =
                incomeRepository.findByUser(user);

        double totalExpense =
                expenses.stream()
                        .mapToDouble(Expense::getAmount)
                        .sum();

        double totalIncome =
                incomes.stream()
                        .mapToDouble(Income::getAmount)
                        .sum();

        double savings =
                totalIncome - totalExpense;

        return """
                Anyalyze the below data and give short answer in less time: 
                User Financial Summary

                Total Income: ₹%.2f
                Total Expense: ₹%.2f
                Current Savings: ₹%.2f

                Expenses:
                %s
                """
                .formatted(
                        totalIncome,
                        totalExpense,
                        savings,
                        expensesToText(expenses)
                );
    }

    private String expensesToText(List<Expense> expenses) {

        StringBuilder sb = new StringBuilder();

        for (Expense expense : expenses) {

            sb.append("- ")
                    .append(expense.getCategory())
                    .append(": ₹")
                    .append(expense.getAmount())
                    .append("\n");
        }

        return sb.toString();
    }
}