package com.vr.finetrack_backend.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@Table(name = "recurring_expenses")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RecurringExpense {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;

    private Double amount;

    private String category;

    private String paymentMethod;

    private String frequency;

    private LocalDate nextDueDate;

    private Boolean active;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
}