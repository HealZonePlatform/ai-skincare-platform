// src/services/auth.service.ts
import { IUser, IUserCreate, IUserLogin } from '../interfaces/user.interface';
import { IAuthResponse, IAuthTokens } from '../interfaces/auth.interface';
import userModel from '../models/user.model';
import passwordUtil from '../utils/password.util';
import jwtUtil from '../utils/jwt.util';
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

      // Tạo tokens
      const tokens = this.generateTokens(newUser.id, newUser.email);

      // Lưu refresh token vào Redis
      await this.saveRefreshToken(newUser.id, tokens.refreshToken);

      // Remove password from response
      const { password, ...userWithoutPassword } = newUser;

      return {
        user: userWithoutPassword,
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

      // Tạo tokens
      const tokens = this.generateTokens(user.id, user.email);

      // Lưu refresh token vào Redis
      await this.saveRefreshToken(user.id, tokens.refreshToken);

      // Remove password from response
      const { password, ...userWithoutPassword } = user;

      return {
        user: userWithoutPassword,
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

      // Blacklist old refresh token
      await this.blacklistToken(oldRefreshToken);

      // Generate new tokens
      const newTokens = this.generateTokens(userId, email);

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
   * Generate access and refresh tokens
   */
  private generateTokens(userId: string, email: string): IAuthTokens {
    const accessToken = jwtUtil.generateAccessToken(userId, email);
    const refreshToken = jwtUtil.generateRefreshToken(userId, email);

    return {
      accessToken,
      refreshToken
    };
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
    const tokenExpiry = 15 * 60; // 15 minutes for access token, can be longer for refresh
    await redisConfig.set(`blacklist_${token}`, 'true', tokenExpiry);
  }
}

export default new AuthService();
