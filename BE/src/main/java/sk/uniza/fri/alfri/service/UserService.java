package sk.uniza.fri.alfri.service;

import java.util.List;
import sk.uniza.fri.alfri.entity.Role;
import sk.uniza.fri.alfri.entity.User;

public interface UserService {
  User getUser(String id);

  List<Role> getRoles();

  List<Role> getCurrentUserRoles(String currentUserEmail);

  List<User> getAllUsers();
}
