package com.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class BillItemInfo {
    private Integer drinkId;
    private String drinkName;
    private int quantity;
    private double unitPrice;
    private double totalPrice;
}