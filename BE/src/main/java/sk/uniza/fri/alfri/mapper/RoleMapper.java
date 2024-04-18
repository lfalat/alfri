package sk.uniza.fri.alfri.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;
import sk.uniza.fri.alfri.entity.Role;

@Mapper
public interface RoleMapper {
  RoleMapper INSTANCE = Mappers.getMapper(RoleMapper.class);

  @Mapping(target = "name", ignore = true)
  @Mapping(source = "roleId", target = "id")
  Role mapRoleIdToRole(Integer roleId);
}
