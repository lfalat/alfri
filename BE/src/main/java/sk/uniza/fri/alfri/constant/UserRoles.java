package sk.uniza.fri.alfri.constant;

public enum UserRoles {
    STUDENT(1),
    TEACHER(2),
    ADMIN(4);

    private final int roleId;
    UserRoles(int roleId) {
        this.roleId = roleId;
    }

    public int getRoleId() {
        return this.roleId;
    }
}
