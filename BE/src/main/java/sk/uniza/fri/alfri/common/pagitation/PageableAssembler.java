package sk.uniza.fri.alfri.common.pagitation;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

public class PageableAssembler {
    private PageableAssembler() {
    }

    public static Pageable from(PageDefinition pageDefinition) {
        Sort sort = SortAssembler.from(pageDefinition.getSort());
        Pageable pageable = PageRequest.of(pageDefinition.getPage(), pageDefinition.getSize());

        if (sort != null) {
            pageable = PageRequest.of(pageDefinition.getPage(), pageDefinition.getSize(), sort);
        }

        return pageable;
    }
}
