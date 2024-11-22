package sk.uniza.fri.alfri.service.implementation;

import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.entity.Role;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.entity.UserRole;
import sk.uniza.fri.alfri.repository.RoleRepository;
import sk.uniza.fri.alfri.repository.UserRepository;
import sk.uniza.fri.alfri.service.AdminService;
import sk.uniza.fri.alfri.service.UserService;

@Service
@Slf4j
public class AdminServiceImpl implements AdminService {
  private final RoleRepository roleRepository;
  private final UserService userService;
  private final UserRepository userRepository;

  public AdminServiceImpl(RoleRepository roleRepository, UserService userService,
      UserRepository userRepository) {
    this.roleRepository = roleRepository;
    this.userService = userService;
    this.userRepository = userRepository;
  }

  @Override
  @Transactional
  public User changeUserRole(List<Integer> rolesIds, boolean addRole, Integer userId) {
    List<Role> rolesToChange = roleRepository.findAllById(rolesIds);
    User userToChangeRolesTo = userService.getUser(userId);

    if (rolesToChange.isEmpty()) {
      throw new IllegalArgumentException("No valid roles provided for the operation.");
    }

    Set<Integer> existingRoleIds = userToChangeRolesTo.getUserRoles().stream()
        .map(userRole -> userRole.getRole().getId()).collect(Collectors.toSet());

    if (addRole) {
      rolesToChange.stream().filter(role -> !existingRoleIds.contains(role.getId()))
          .forEach(filteredRole -> userToChangeRolesTo.getUserRoles()
              .add(UserRole.builder().user(userToChangeRolesTo).role(filteredRole).build()));
    } else {
      rolesToChange.forEach(role -> userToChangeRolesTo.getUserRoles()
          .removeIf(userRole -> Objects.equals(userRole.getRole().getId(), role.getId())));
    }

    return userRepository.save(userToChangeRolesTo);
  }
}
