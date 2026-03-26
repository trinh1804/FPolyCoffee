package com.entity;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO – Doanh thu theo ngày.
 * Không phải @Entity, dùng để nhận kết quả native query tổng hợp.
 */
@AllArgsConstructor
@NoArgsConstructor
@Data
public class RevenueByDay {
    private Date revenueDate;
    private int totalBills;
    private long totalRevenue;
}