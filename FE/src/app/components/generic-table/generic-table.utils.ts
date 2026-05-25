import { Page } from '../../types';

export class GenericTableUtils {
  public static readonly EMPTY_PAGE: Page<never> = {
    content: [],
    pageable: {
      sort: {
        sorted: false,
        unsorted: true,
        empty: true,
      },
      offset: 0,
      pageNumber: 0,
      pageSize: 10,
      paged: true,
      unpaged: false,
    },
    last: true,
    totalElements: 0,
    totalPages: 0,
    size: 20,
    number: 0,
    sort: {
      sorted: false,
      unsorted: true,
      empty: true,
    },
    first: true,
    numberOfElements: 0,
    empty: true,
  };

  public static pageOf<T>(content: T[]): Page<T> {
    return {
      ...GenericTableUtils.EMPTY_PAGE,
      content,
      size: content.length,
      numberOfElements: content.length,
    };
  }
}
