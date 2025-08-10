// src/config/redis.ts
import { createClient } from 'redis';

class RedisConfig {
  private client: any;
  private isConnected: boolean = false;

  constructor() {
    // Parse Redis URL with proper error handling
    const redisUrl = process.env.REDIS_URL || 'redis://localhost:6379';
    console.log(`🔗 Connecting to Redis: ${redisUrl}`);

    this.client = createClient({
      url: redisUrl,
      socket: {
        connectTimeout: 10000, // Timeout cho Docker
        reconnectStrategy: (retries) => {
          if (retries > 10) {
            console.error('❌ Redis: Too many reconnection attempts');
            return new Error('Too many reconnection attempts');
          }
          return Math.min(retries * 50, 1000);
        }
      }
      // ✅ Loại bỏ lazyConnect - không tồn tại trong RedisSocketOptions
    });

    this.setupEventHandlers();
    this.connectWithRetry();
  }

  private setupEventHandlers(): void {
    this.client.on('error', (err: any) => {
      console.error('Redis Client Error:', err);
      this.isConnected = false;
    });

    this.client.on('connect', () => {
      console.log('🔄 Redis connecting...');
    });

    this.client.on('ready', () => {
      console.log('✅ Redis connected successfully');
      this.isConnected = true;
    });

    this.client.on('end', () => {
      console.log('🔌 Redis connection closed');
      this.isConnected = false;
    });

    this.client.on('reconnecting', () => {
      console.log('🔄 Redis reconnecting...');
    });
  }

  private async connectWithRetry(maxRetries: number = 5): Promise<void> {
    let retries = 0;
    
    while (retries < maxRetries) {
      try {
        if (!this.client.isOpen) {
          await this.client.connect();
        }
        return;
      } catch (error) {
        retries++;
        console.log(`❌ Redis connection attempt ${retries}/${maxRetries} failed:`, error);
        
        if (retries === maxRetries) {
          console.error('💥 All Redis connection attempts failed');
          throw error;
        }
        
        // Wait before retry
        const waitTime = Math.pow(2, retries) * 1000;
        console.log(`⏳ Retrying Redis connection in ${waitTime}ms...`);
        await this.sleep(waitTime);
      }
    }
  }

  private sleep(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  getClient() {
    return this.client;
  }

  isReady(): boolean {
    return this.isConnected && this.client.isReady;
  }

  async set(key: string, value: string, expireInSeconds?: number): Promise<void> {
    try {
      if (!this.isReady()) {
        throw new Error('Redis client is not ready');
      }
      
      if (expireInSeconds) {
        await this.client.setEx(key, expireInSeconds, value);
      } else {
        await this.client.set(key, value);
      }
    } catch (error) {
      console.error('Redis set error:', error);
      throw error;
    }
  }

  async get(key: string): Promise<string | null> {
    try {
      if (!this.isReady()) {
        throw new Error('Redis client is not ready');
      }
      
      return await this.client.get(key);
    } catch (error) {
      console.error('Redis get error:', error);
      throw error;
    }
  }

  async del(key: string): Promise<void> {
    try {
      if (!this.isReady()) {
        throw new Error('Redis client is not ready');
      }
      
      await this.client.del(key);
    } catch (error) {
      console.error('Redis delete error:', error);
      throw error;
    }
  }

  async healthCheck(): Promise<boolean> {
    try {
      if (!this.isReady()) {
        return false;
      }
      
      const result = await this.client.ping();
      return result === 'PONG';
    } catch (error) {
      console.error('Redis health check failed:', error);
      return false;
    }
  }

  async close(): Promise<void> {
    try {
      if (this.client.isOpen) {
        await this.client.quit();
      }
      console.log('Redis connection closed');
    } catch (error) {
      console.error('Error closing Redis connection:', error);
    }
  }
}

export default new RedisConfig();
