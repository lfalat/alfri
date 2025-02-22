package sk.uniza.fri.alfri.service.implementation;

import jakarta.transaction.Transactional;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.entity.Role;
import sk.uniza.fri.alfri.entity.Subject;
import sk.uniza.fri.alfri.entity.Teacher;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.entity.UserRole;
import sk.uniza.fri.alfri.repository.RoleRepository;
import sk.uniza.fri.alfri.repository.SubjectRepository;
import sk.uniza.fri.alfri.repository.TeacherRepository;
import sk.uniza.fri.alfri.repository.UserRepository;
import sk.uniza.fri.alfri.service.AdminService;
import sk.uniza.fri.alfri.service.TeacherService;
import sk.uniza.fri.alfri.service.UserService;

import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@Transactional
public class AdminServiceImpl implements AdminService {
    public static final String TEACHER = "teacher";
    private final RoleRepository roleRepository;
    private final UserRepository userRepository;
    private final UserService userService;
    private final TeacherService teacherService;
    private final SubjectRepository subjectRepository;
    private final TeacherRepository teacherRepository;
    private final ModelMapper modelMapper;

    public AdminServiceImpl(RoleRepository roleRepository, UserService userService,
                            UserRepository userRepository, TeacherService teacherService,
                            SubjectRepository subjectRepository, TeacherRepository teacherRepository,
                            ModelMapper modelMapper) {
        this.roleRepository = roleRepository;
        this.userService = userService;
        this.userRepository = userRepository;
        this.teacherService = teacherService;
        this.subjectRepository = subjectRepository;
        this.teacherRepository = teacherRepository;
        this.modelMapper = modelMapper;
    }

    @Override
    public User changeUserRole(List<Integer> rolesIds, boolean addRole, Integer userId) {
        if (rolesIds.isEmpty()) {
            throw new IllegalArgumentException("No valid roles provided for the operation.");
        }

        List<Role> rolesToChange = roleRepository.findAllById(rolesIds);

        Integer teacherRoleId =
                rolesToChange.stream().filter(role -> role.getName().equalsIgnoreCase(TEACHER))
                        .map(Role::getId).findFirst().orElse(null);

        User userToChangeRolesTo = userService.getUser(userId);

        if (teacherRoleId != null && rolesIds.contains(teacherRoleId)) {
            if (addRole) {
                teacherService.createTeacher(userId);
            } else {
                teacherService.deleteTeacher(userId);
            }
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

    @Override
    public Teacher setSubjectsToTeacherByUserId(Integer userId, List<String> subjectCodes) {
        Teacher teacher = teacherService.findByUserId(userId);

        List<Subject> subjects = subjectRepository.findByCodeIn(subjectCodes);

        teacher.setSubjects(subjects);

        return teacherRepository.save(teacher);
    }
}
