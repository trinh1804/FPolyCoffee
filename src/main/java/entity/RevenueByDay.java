package entity;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class RevenueByDay {
    Date revenueDate;
    int totalBills;
    long totalRevenue;
}
