package sk.uniza.fri.alfri.service;

import sk.uniza.fri.alfri.entity.Department;

import java.util.List;

/**
 * Created by petos on 11/23/24.
 */
public interface DepartmentService {
    List<Department> findAll();
}
