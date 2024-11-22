package sk.uniza.fri.alfri.configuration;

import java.util.List;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import sk.uniza.fri.alfri.dto.user.RoleDto;
import sk.uniza.fri.alfri.dto.user.UserDto;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.entity.UserRole;

/** Created by petos on 11/12/24. */
@Configuration
public class ModelMapperConfiguration {
  @Bean
  public ModelMapper modelMapper() {
    ModelMapper modelMapper = new ModelMapper();

    // Map User to UserDto
    modelMapper.typeMap(User.class, UserDto.class)
        .addMappings(mapper -> mapper.skip(UserDto::setRoles) // skip default role mapping
        ).setPostConverter(context -> {
          User user = context.getSource();
          UserDto userDto = context.getDestination();

          // Manually map roles to RoleDto list
          List<RoleDto> roleDtos =
              modelMapper.map(user.getUserRoles().stream().map(UserRole::getRole).toList(),
                  new TypeToken<List<RoleDto>>() {}.getType());
          userDto.setRoles(roleDtos);
          return userDto;
        });

    return modelMapper;
  }
}
