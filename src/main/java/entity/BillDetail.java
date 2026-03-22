package entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class BillDetail {
    Integer billId;
    Integer drinkId;
    int quantity;
    double unitPrice;
    double totalPrice;
}
