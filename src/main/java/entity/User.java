package entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class User {
    Integer id;
    String fullName;
    String email;
    String phone;
    String password;
    boolean active;
    Integer roleId;
}
