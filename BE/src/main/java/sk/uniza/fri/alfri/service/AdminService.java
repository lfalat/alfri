package sk.uniza.fri.alfri.service;

import sk.uniza.fri.alfri.entity.User;

import java.util.List;

public interface AdminService {
  User changeUserRole(List<Integer> rolesIds, boolean addRole, Integer userId);
}
