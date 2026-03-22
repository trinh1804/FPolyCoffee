package entity;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class DiscountCode {
    Integer id;
    String code;
    double discountValue;
    boolean discountType;
    Date startDate;
    Date endDate;
    boolean active;
    String conditionNote;
}
