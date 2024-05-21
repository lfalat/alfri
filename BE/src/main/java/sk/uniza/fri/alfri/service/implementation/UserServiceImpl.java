package sk.uniza.fri.alfri.service.implementation;

import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.repository.UserRepository;
import sk.uniza.fri.alfri.service.UserService;

import java.util.Optional;

@Service
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;

    public UserServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public User getUser(String id) {
        Optional<User> user = this.userRepository.findByEmail(id);
        return user.orElse(null);
    }


}
