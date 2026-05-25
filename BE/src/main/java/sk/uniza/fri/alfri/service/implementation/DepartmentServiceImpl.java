package sk.uniza.fri.alfri.service.implementation;

import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.entity.Department;
import sk.uniza.fri.alfri.repository.DepartmentRepository;
import sk.uniza.fri.alfri.service.DepartmentService;

import java.util.List;

@Service
public class DepartmentServiceImpl implements DepartmentService {
    private final DepartmentRepository departmentRepository;

    public DepartmentServiceImpl(DepartmentRepository departmentRepository) {
        this.departmentRepository = departmentRepository;
    }

    @Override
    public List<Department> findAll() {
        return departmentRepository.findAll();
    }
}
