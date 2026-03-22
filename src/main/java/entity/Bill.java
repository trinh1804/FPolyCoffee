package entity;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Bill {
    Integer id;
    Date createdAt;
    double totalPrice;
    double discountAmount;
    boolean paymentMethod;
    int status;
    String code;
    Integer userId;
    Integer customerId;
    Integer discountId;

    public static final int STATUS_WAITING = 0;
    public static final int STATUS_FINISH = 1;
    public static final int STATUS_CANCEL = 2;
}
