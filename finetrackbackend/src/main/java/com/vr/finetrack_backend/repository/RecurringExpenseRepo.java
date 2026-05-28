package com.vr.finetrack_backend.repository;

import com.vr.finetrack_backend.entity.RecurringExpense;
import com.vr.finetrack_backend.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;

public interface RecurringExpenseRepo
        extends JpaRepository<RecurringExpense, Long> {

    List<RecurringExpense> findByUser(User user);

    List<RecurringExpense> findByActiveTrueAndNextDueDateLessThanEqual(
            LocalDate date
    );
}