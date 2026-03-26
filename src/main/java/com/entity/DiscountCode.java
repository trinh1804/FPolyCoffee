package com.entity;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "DISCOUNTCODE")
@AllArgsConstructor
@NoArgsConstructor
@Data
public class DiscountCode {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "code", nullable = false, unique = true, length = 20)
    private String code;

    @Column(name = "discount_value", nullable = false)
    private double discountValue;

    /**
     * discount_type (BIT):
     * false (0) = giảm số tiền cố định
     * true (1) = giảm theo %
     */
    @Column(name = "discount_type", nullable = false)
    private boolean discountType;

    @Temporal(TemporalType.DATE)
    @Column(name = "start_date", nullable = false)
    private Date startDate;

    @Temporal(TemporalType.DATE)
    @Column(name = "end_date", nullable = false)
    private Date endDate;

    @Column(name = "status", nullable = false)
    private boolean active;

    @Column(name = "condition_note", columnDefinition = "NVARCHAR(MAX)", nullable = false)
    private String conditionNote;
}
