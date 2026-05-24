package sk.uniza.fri.alfri.service;

import sk.uniza.fri.alfri.entity.User;

import java.util.Optional;

public interface IAuthService {
    Optional<String> getCurrentUserEmail();

    Optional<User> getCurrentUser();
}
