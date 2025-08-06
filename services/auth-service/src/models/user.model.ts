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
      SELECT * FROM ${this.tableName} 
      WHERE email = $1 AND is_active = true
    `;
    
    const result = await database.query(query, [email]);
    return result.rows[0] || null;
  }

  /**
   * Tìm user theo ID
   */
  async findById(id: string): Promise<IUser | null> {
    const query = `
      SELECT * FROM ${this.tableName} 
      WHERE id = $1 AND is_active = true
    `;
    
    const result = await database.query(query, [id]);
    return result.rows[0] || null;
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
      RETURNING *
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

    const result = await database.query(query, values);
    return result.rows[0];
  }

  /**
   * Cập nhật thông tin user
   */
  async update(id: string, updateData: Partial<IUser>): Promise<IUser | null> {
    const fields = [];
    const values = [];
    let paramCount = 1;

    // Build dynamic update query
    Object.entries(updateData).forEach(([key, value]) => {
      if (value !== undefined) {
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
      RETURNING *
    `;

    const result = await database.query(query, values);
    return result.rows[0] || null;
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

    const result = await database.query(query, [new Date(), id]);
    return result.rowCount > 0;
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

    const result = await database.query(query, [new Date(), id]);
    return result.rowCount > 0;
  }
}

export default new UserModel();
