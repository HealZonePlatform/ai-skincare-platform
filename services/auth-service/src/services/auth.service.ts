// src/services/auth.service.ts
import { IUser, IUserCreate, IUserLogin } from '../interfaces/user.interface';
import { IAuthResponse, IAuthTokens } from '../interfaces/auth.interface';
import userModel from '../models/user.model';
import passwordUtil from '../utils/password.util';
import { generateTokens, verifyRefreshToken, extractTokenFromHeader, decodeToken } from '../utils/jwt.util';
import redisConfig from '../config/redis';

class AuthService {
  /**
   * Đăng ký user mới
   */
  async register(userData: IUserCreate): Promise<IAuthResponse> {
    try {
      // Kiểm tra email đã tồn tại
      const existingUser = await userModel.findByEmail(userData.email);
      if (existingUser) {
        throw new Error('Email already exists');
      }

      // Validate password strength
      const passwordCheck = passwordUtil.validateStrength(userData.password);
      if (!passwordCheck.isValid) {
        throw new Error(passwordCheck.message);
      }

      // Hash password
      const hashedPassword = await passwordUtil.hash(userData.password);

      // Tạo user mới
      const newUser = await userModel.create({
        ...userData,
        hashedPassword
      });

      // Tạo tokens sử dụng function mới
      const tokens = generateTokens(newUser);

      // Lưu refresh token vào Redis
      await this.saveRefreshToken(newUser.id, tokens.refreshToken);

      // Remove password from response
      const userResponse = {
        id: newUser.id,
        email: newUser.email,
        first_name: newUser.first_name,
        last_name: newUser.last_name,
        phone: newUser.phone,
        date_of_birth: newUser.date_of_birth,
        skin_type: newUser.skin_type,
        is_active: newUser.is_active,
        is_verified: newUser.is_verified,
        created_at: newUser.created_at,
        updated_at: newUser.updated_at
      };

      return {
        user: userResponse,
        tokens
      };
    } catch (error) {
      console.error('Register service error:', error);
      throw error;
    }
  }

  /**
   * Đăng nhập user
   */
  async login(loginData: IUserLogin): Promise<IAuthResponse> {
    try {
      // Tìm user theo email
      const user = await userModel.findByEmail(loginData.email);
      if (!user) {
        throw new Error('Invalid email or password');
      }

      // Kiểm tra password
      const isPasswordValid = await passwordUtil.compare(loginData.password, user.password);
      if (!isPasswordValid) {
        throw new Error('Invalid email or password');
      }

      // Kiểm tra account status
      if (!user.is_active) {
        throw new Error('Account is deactivated');
      }

      // Tạo tokens sử dụng function mới
      const tokens = generateTokens(user);

      // Lưu refresh token vào Redis
      await this.saveRefreshToken(user.id, tokens.refreshToken);

      // Remove password from response
      const userResponse = {
        id: user.id,
        email: user.email,
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

      return {
        user: userResponse,
        tokens
      };
    } catch (error) {
      console.error('Login service error:', error);
      throw error;
    }
  }

  /**
   * Refresh access token
   */
  async refreshToken(userId: string, email: string, oldRefreshToken: string): Promise<IAuthTokens> {
    try {
      // Verify refresh token exists in Redis
      const storedToken = await redisConfig.get(`refresh_${userId}`);
      if (!storedToken || storedToken !== oldRefreshToken) {
        throw new Error('Invalid refresh token');
      }

      // Verify user still exists and is active
      const user = await userModel.findById(userId);
      if (!user || !user.is_active) {
        throw new Error('User not found or inactive');
      }

      // Verify refresh token signature
      const tokenResult = verifyRefreshToken(oldRefreshToken);
      if (!tokenResult.valid) {
        throw new Error('Invalid refresh token signature');
      }

      // Blacklist old refresh token
      await this.blacklistToken(oldRefreshToken);

      // Generate new tokens
      const newTokens = generateTokens(user);

      // Save new refresh token
      await this.saveRefreshToken(userId, newTokens.refreshToken);

      return newTokens;
    } catch (error) {
      console.error('Refresh token service error:', error);
      throw error;
    }
  }

  /**
   * Logout user
   */
  async logout(userId: string, accessToken: string, refreshToken: string): Promise<void> {
    try {
      // Blacklist both tokens
      await Promise.all([
        this.blacklistToken(accessToken),
        this.blacklistToken(refreshToken)
      ]);

      // Remove refresh token from Redis
      await redisConfig.del(`refresh_${userId}`);
    } catch (error) {
      console.error('Logout service error:', error);
      throw error;
    }
  }

  /**
   * Save refresh token to Redis
   */
  private async saveRefreshToken(userId: string, refreshToken: string): Promise<void> {
    const refreshTokenExpiry = 7 * 24 * 60 * 60; // 7 days in seconds
    await redisConfig.set(`refresh_${userId}`, refreshToken, refreshTokenExpiry);
  }

  /**
   * Blacklist a token
   */
  private async blacklistToken(token: string): Promise<void> {
    // Calculate appropriate expiry time based on token type
    let tokenExpiry = 15 * 60; // 15 minutes default for access token
    
    try {
      const decoded = decodeToken(token);
      if (decoded?.type === 'refresh') {
        tokenExpiry = 7 * 24 * 60 * 60; // 7 days for refresh token
      }
    } catch (error) {
      // Use default expiry if decode fails
      console.warn('Failed to decode token for blacklist expiry calculation');
    }

    await redisConfig.set(`blacklist_${token}`, 'true', tokenExpiry);
  }
}

export default new AuthService();
