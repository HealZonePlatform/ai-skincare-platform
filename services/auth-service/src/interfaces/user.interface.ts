// src/interfaces/user.interface.ts
export interface IUser {
  id: string;
  email: string;
  password: string;
  first_name: string;
  last_name: string;
  phone?: string;
  date_of_birth?: Date;
  skin_type?: string;
  is_active: boolean;
  is_verified: boolean;
  created_at: Date;
  updated_at: Date;
}

export interface IUserCreate {
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  phone?: string;
  dateOfBirth?: Date;
}

export interface IUserLogin {
  email: string;
  password: string;
}

export interface IUserResponse extends Omit<IUser, 'password'> {
  // User response without password field
}
