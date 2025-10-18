// src/models/user.model.ts
import { v4 as uuidv4 } from 'uuid';
import database from '../config/database';
import { IUser, IUserCreate } from '../interfaces/user.interface';

class UserModel {
  private tableName = 'users';

  /**
   * Tìm user theo email
   */
  async findByEmail(email: string): Promise<IUser | null> {
    const query = `
      SELECT 
        id, email, password, first_name, last_name, phone, 
        date_of_birth, skin_type, is_active, is_verified, 
        created_at, updated_at
      FROM ${this.tableName} 
      WHERE email = $1 AND is_active = true
    `;
    
    try {
      const result = await database.query(query, [email.toLowerCase()]);
      if (result.rows.length === 0) {
        return null;
      }
      
      // Map database fields to interface
      const user = result.rows[0];
      return {
        id: user.id,
        email: user.email,
        password: user.password,
        first_name: user.first_name,
        last_name: user.last_name,
        phone: user.phone,
        date_of_birth: user.date_of_birth,
        skin_type: user.skin_type,
        is_active: user.is_active,
        is_verified: user.is_verified,
        created_at: user.created_at,
        updated_at: user.updated_at
      };
    } catch (error) {
      console.error('Error finding user by email:', error);
      throw error;
    }
  }

  /**
   * Tìm user theo ID
   */
  async findById(id: string): Promise<IUser | null> {
    const query = `
      SELECT 
        id, email, password, first_name, last_name, phone, 
        date_of_birth, skin_type, is_active, is_verified, 
        created_at, updated_at
      FROM ${this.tableName} 
      WHERE id = $1 AND is_active = true
    `;
    
    try {
      const result = await database.query(query, [id]);
      if (result.rows.length === 0) {
        return null;
      }

      const user = result.rows[0];
      return {
        id: user.id,
        email: user.email,
        password: user.password,
        first_name: user.first_name,
        last_name: user.last_name,
        phone: user.phone,
        date_of_birth: user.date_of_birth,
        skin_type: user.skin_type,
        is_active: user.is_active,
        is_verified: user.is_verified,
        created_at: user.created_at,
        updated_at: user.updated_at
      };
    } catch (error) {
      console.error('Error finding user by ID:', error);
      throw error;
    }
  }

  /**
   * Tạo user mới
   */
  async create(userData: IUserCreate & { hashedPassword: string }): Promise<IUser> {
    const id = uuidv4();
    const now = new Date();

    const query = `
      INSERT INTO ${this.tableName} (
        id, email, password, first_name, last_name, phone, date_of_birth,
        is_active, is_verified, created_at, updated_at
      )
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
      RETURNING id, email, password, first_name, last_name, phone, 
                date_of_birth, skin_type, is_active, is_verified, 
                created_at, updated_at
    `;

    const values = [
      id,
      userData.email.toLowerCase(),
      userData.hashedPassword,
      userData.firstName,
      userData.lastName,
      userData.phone || null,
      userData.dateOfBirth || null,
      true, // is_active
      false, // is_verified
      now, // created_at
      now // updated_at
    ];

    try {
      const result = await database.query(query, values);
      const user = result.rows[0];
      
      return {
        id: user.id,
        email: user.email,
        password: user.password,
        first_name: user.first_name,
        last_name: user.last_name,
        phone: user.phone,
        date_of_birth: user.date_of_birth,
        skin_type: user.skin_type,
        is_active: user.is_active,
        is_verified: user.is_verified,
        created_at: user.created_at,
        updated_at: user.updated_at
      };
    } catch (error) {
      console.error('Error creating user:', error);
      throw error;
    }
  }

  /**
   * Cập nhật thông tin user
   */
  async update(id: string, updateData: Partial<Omit<IUser, 'id' | 'created_at'>>): Promise<IUser | null> {
    const fields = [];
    const values = [];
    let paramCount = 1;

    // Build dynamic update query
    Object.entries(updateData).forEach(([key, value]) => {
      if (value !== undefined && key !== 'id' && key !== 'created_at') {
        fields.push(`${key} = $${paramCount}`);
        values.push(value);
        paramCount++;
      }
    });

    if (fields.length === 0) {
      throw new Error('No fields to update');
    }

    // Add updated_at
    fields.push(`updated_at = $${paramCount}`);
    values.push(new Date());
    paramCount++;

    // Add id for WHERE clause
    values.push(id);

    const query = `
      UPDATE ${this.tableName}
      SET ${fields.join(', ')}
      WHERE id = $${paramCount}
      RETURNING id, email, password, first_name, last_name, phone, 
                date_of_birth, skin_type, is_active, is_verified, 
                created_at, updated_at
    `;

    try {
      const result = await database.query(query, values);
      if (result.rows.length === 0) {
        return null;
      }

      const user = result.rows[0];
      return {
        id: user.id,
        email: user.email,
        password: user.password,
        first_name: user.first_name,
        last_name: user.last_name,
        phone: user.phone,
        date_of_birth: user.date_of_birth,
        skin_type: user.skin_type,
        is_active: user.is_active,
        is_verified: user.is_verified,
        created_at: user.created_at,
        updated_at: user.updated_at
      };
    } catch (error) {
      console.error('Error updating user:', error);
      throw error;
    }
  }

  /**
   * Xóa user (soft delete)
   */
  async delete(id: string): Promise<boolean> {
    const query = `
      UPDATE ${this.tableName}
      SET is_active = false, updated_at = $1
      WHERE id = $2
    `;

    try {
      const result = await database.query(query, [new Date(), id]);
      return result.rowCount > 0;
    } catch (error) {
      console.error('Error deleting user:', error);
      throw error;
    }
  }

  /**
   * Verify user email
   */
  async verifyEmail(id: string): Promise<boolean> {
    const query = `
      UPDATE ${this.tableName}
      SET is_verified = true, updated_at = $1
      WHERE id = $2
    `;

    try {
      const result = await database.query(query, [new Date(), id]);
      return result.rowCount > 0;
    } catch (error) {
      console.error('Error verifying email:', error);
      throw error;
    }
  }
}

export default new UserModel();
