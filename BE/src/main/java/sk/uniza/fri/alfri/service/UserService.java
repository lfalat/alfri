package sk.uniza.fri.alfri.service;

import sk.uniza.fri.alfri.entity.Role;
import sk.uniza.fri.alfri.entity.User;

import java.util.List;

public interface UserService {
    User getUser(String email);

    User getUser(Integer id);

    List<Role> getRoles();

    List<Role> getCurrentUserRoles(String currentUserEmail);

    List<User> getAllUsers();

    void deleteUser(Integer id);
}
