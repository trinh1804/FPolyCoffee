package entity;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Lịch sử tích điểm / đổi điểm của khách hàng.
 */
@AllArgsConstructor
@NoArgsConstructor
@Data
public class PointTransaction {
    Integer id;
    int bonusPoint;
    int deductPoint;
    Date transactionDate;
    String note;
    Integer customerId;
    Integer billId;
}
