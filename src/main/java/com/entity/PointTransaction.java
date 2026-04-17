package com.entity;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "POINT")
@AllArgsConstructor
@NoArgsConstructor
@Data
public class PointTransaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "bonus_point", nullable = false)
    private int bonusPoint;

    @Column(name = "deduct_point", nullable = false)
    private int deductPoint;

    @Temporal(TemporalType.DATE)
    @Column(name = "transaction_date", nullable = false)
    private Date transactionDate;

    @Column(name = "note", length = 255)
    private String note;

    @Column(name = "customer_id", nullable = false)
    private Integer customerId;

    @Column(name = "bill_id", nullable = false)
    private Integer billId;
}
