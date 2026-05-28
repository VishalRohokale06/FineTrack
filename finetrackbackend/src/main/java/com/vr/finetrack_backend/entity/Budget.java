package com.vr.finetrack_backend.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "budgets")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Budget {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String category;

    private Double limitAmount;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
}