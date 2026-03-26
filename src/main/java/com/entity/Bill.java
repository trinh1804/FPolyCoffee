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
@Table(name = "BILL")
@AllArgsConstructor
@NoArgsConstructor
@Data
public class Bill {

    public static final int STATUS_WAITING = 0;
    public static final int STATUS_FINISH = 1;
    public static final int STATUS_CANCEL = 2;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Temporal(TemporalType.DATE)
    @Column(name = "created_at", nullable = false)
    private Date createdAt;

    @Column(name = "total_price", nullable = false)
    private double totalPrice;

    @Column(name = "discount_amount", nullable = false)
    private double discountAmount;

    @Column(name = "payment_method", nullable = false)
    private boolean paymentMethod;

    @Column(name = "status", nullable = false)
    private int status;

    @Column(name = "code", nullable = false, unique = true, length = 30)
    private String code;

    @Column(name = "user_id")
    private Integer userId;

    @Column(name = "customer_id")
    private Integer customerId;

    @Column(name = "discount_id")
    private Integer discountId;
}
