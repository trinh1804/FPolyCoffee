package entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Drink {
    Integer id;
    String name;
    double price;
    String description;
    String image;
    boolean active;
    Integer categoryId;
}
