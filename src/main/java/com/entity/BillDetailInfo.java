package com.entity;

import java.util.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class BillDetailInfo {
    private Integer id;
    private String code;
    private Date createdAt;
    private double totalPrice;
    private double discountAmount;
    private boolean paymentMethod;
    private int status;
    private Integer userId;
    private String staffName;
    private Integer customerId;
    private String customerName;
    private List<BillItemInfo> items;
}