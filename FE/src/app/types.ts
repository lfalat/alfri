export interface Role {
  id: number,
  name: string
}
export interface RegisterUserDto {
  firstName: string,
  lastName: string,
  roleId: number,
  email: string,
  password: string
}
