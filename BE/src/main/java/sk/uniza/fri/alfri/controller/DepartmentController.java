package sk.uniza.fri.alfri.controller;

import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import sk.uniza.fri.alfri.dto.DepartmentDto;
import sk.uniza.fri.alfri.entity.Department;
import sk.uniza.fri.alfri.service.DepartmentService;

import java.util.List;

@RestController
@Slf4j
@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_TEACHER', 'ROLE_VEDENIE')")
@RequestMapping("/api/department")
public class DepartmentController {
    private final ModelMapper modelMapper;
    private final DepartmentService departmentService;

    public DepartmentController(DepartmentService departmentService, ModelMapper modelMapper) {
        this.departmentService = departmentService;
        this.modelMapper = modelMapper;
    }

    @GetMapping
    public ResponseEntity<List<DepartmentDto>> findAll() {
        log.info("Getting all departments");

        List<Department> departments = departmentService.findAll();

        List<DepartmentDto> departmentDtos = departments.stream()
                .map(department -> modelMapper.map(department, DepartmentDto.class)).toList();
        log.info("{} departments returned", departmentDtos.size());

        return ResponseEntity.ok(departmentDtos);
    }
}
