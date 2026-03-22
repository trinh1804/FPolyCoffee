package entity;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Category {
    Integer id;
    String name;
    String description;
    String image;
    boolean active;
    Date createdAt;
}
