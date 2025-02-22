package sk.uniza.fri.alfri.constant;

import lombok.Getter;

@Getter
public enum UserRoles {
    STUDENT(1),
    TEACHER(2),
    VEDENIE(3),
    ADMIN(4);

    private final int roleId;

    UserRoles(int roleId) {
        this.roleId = roleId;
    }

}
