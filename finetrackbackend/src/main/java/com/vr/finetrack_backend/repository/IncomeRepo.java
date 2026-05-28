package com.vr.finetrack_backend.repository;

import com.vr.finetrack_backend.entity.Income;
import com.vr.finetrack_backend.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface IncomeRepo extends JpaRepository<Income, Long> {

    List<Income> findByUser(User user);

    Optional<Income> findByIdAndUser(Long id, User user);
}