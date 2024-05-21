export interface Role {
  id: number;
  name: string;
}
export interface RegisterUserDto {
  firstName: string;
  lastName: string;
  roleId: number;
  email: string;
  password: string;
}

export interface UserDto {
  userId: number;
  firstName: string;
  lastName: string;
  role: Role;
  email: string;
}

export interface LoginUserDto {
  email: string;
  password: string;
}

export interface ChangePasswordDto {
  email: string,
  oldPassword: string
  newPassword: string
}

export interface AuthResponseDto {
  jwtToken: string;
  expiresIn: number;
}

export interface SubjectDto {
  name: string;
  code: string;
  abbreviation: string;
  studyProgramName: string;
}

export interface StudyProgramDto {
  id: number;
  name: string;
}

export interface Page<T> {
  content: T[];
  pageable: {
    sort: {
      sorted: boolean;
      unsorted: boolean;
      empty: boolean;
    };
    offset: number;
    pageNumber: number;
    pageSize: number;
    paged: boolean;
    unpaged: boolean;
  };
  last: boolean;
  totalElements: number;
  totalPages: number;
  size: number;
  number: number;
  sort: {
    sorted: boolean;
    unsorted: boolean;
    empty: boolean;
  };
  first: boolean;
  numberOfElements: number;
  empty: boolean;
}
