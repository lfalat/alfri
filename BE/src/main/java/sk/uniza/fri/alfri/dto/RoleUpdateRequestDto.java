package sk.uniza.fri.alfri.dto;

import java.util.List;

/**
 * Created by petos on 11/22/24.
 */
public record RoleUpdateRequestDto(List<Integer> roleIds, boolean add) {
}
