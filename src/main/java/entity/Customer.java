package entity;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Customer {
    Integer id;
    String fullName;
    String phone;
    String email;
    int point;
    boolean active;
    Date createdAt;
}
