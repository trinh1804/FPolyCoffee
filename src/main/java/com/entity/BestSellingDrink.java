package com.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO – Top đồ uống bán chạy.
 * Không phải @Entity vì đây là kết quả tổng hợp từ nhiều bảng.
 */
@AllArgsConstructor
@NoArgsConstructor
@Data
public class BestSellingDrink {
    private int drinkId;
    private String drinkName;
    private int totalQuantitySold;
    private long totalRevenue;
}