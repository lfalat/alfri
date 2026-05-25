package sk.uniza.fri.alfri.service.implementation;

import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.entity.Role;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.entity.UserRole;
import sk.uniza.fri.alfri.repository.RoleRepository;
import sk.uniza.fri.alfri.repository.UserRepository;
import sk.uniza.fri.alfri.service.UserService;

import java.util.List;
import java.util.Optional;

@Service
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;

    public UserServiceImpl(UserRepository userRepository, RoleRepository roleRepository) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
    }

    @Override
    public User getUser(String email) {
        Optional<User> user = this.userRepository.findByEmail(email);
        return user.orElse(null);
    }

    @Override
    public User getUser(Integer userId) {
        return userRepository.findById(userId).orElseThrow(() -> new EntityNotFoundException(
                String.format("User with userId %d was not found!", userId)));
    }

    @Override
    public List<Role> getRoles() {
        return roleRepository.findAll();
    }

    @Override
    public List<Role> getCurrentUserRoles(String currentUserEmail) {
        User user =
                userRepository.findByEmail(currentUserEmail).orElseThrow(() -> new EntityNotFoundException(
                        String.format("User with email %s was not found!", currentUserEmail)));

        return user.getUserRoles().stream().map(UserRole::getRole).toList();
    }

    @Override
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @Override
    public void deleteUser(Integer id) {
        this.userRepository.deleteById(id);
    }
}
