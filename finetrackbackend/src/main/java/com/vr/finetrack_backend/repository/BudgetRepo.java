package com.vr.finetrack_backend.repository;

import com.vr.finetrack_backend.entity.Budget;
import com.vr.finetrack_backend.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface BudgetRepo extends JpaRepository<Budget, Long> {

    List<Budget> findByUser(User user);

    Optional<Budget> findByIdAndUser(Long id, User user);

    Optional<Budget> findByCategoryAndUser(String category, User user);
}