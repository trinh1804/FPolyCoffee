package entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class BestSellingDrink {
    private int drinkId;
    private String drinkName;
    private int totalQuantitySold;
    private long totalRevenue;
}
