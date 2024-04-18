package sk.uniza.fri.alfri.service;

import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.exception.InvalidCredentialsException;
import sk.uniza.fri.alfri.exception.UserAlreadyRegisteredException;

public interface IAuthService {
  User registerUser(User user) throws UserAlreadyRegisteredException;

  User verifyUser(User user) throws InvalidCredentialsException;
}