// src/server.ts
import dotenv from 'dotenv';
dotenv.config();

import App from './app';
import database from './config/database';
import redisConfig from './config/redis';

class Server {
  private app: App;
  private port: number;

  constructor() {
    this.app = new App();
    this.port = parseInt(process.env.PORT || '3001');
  }

  public async start(): Promise<void> {
    try {
      console.log('🚀 Starting Auth Service...');
      
      // ✅ Wait for database and Redis with proper error handling
      console.log('🔍 Checking database connection...');
      const dbHealthy = await database.healthCheck(); // ✅ Bây giờ method này đã tồn tại
      if (!dbHealthy) {
        throw new Error('Database health check failed');
      }
      
      console.log('🔍 Checking Redis connection...');
      const redisHealthy = await redisConfig.healthCheck();
      if (!redisHealthy) {
        throw new Error('Redis health check failed');
      }

      console.log('✅ All dependencies are healthy');

      // Start server
      this.app.app.listen(this.port, '0.0.0.0', () => {
        console.log(`🚀 Auth Service running on port ${this.port}`);
        console.log(`🔗 Health check: http://localhost:${this.port}/health`);
        console.log(`🔐 Auth API: http://localhost:${this.port}/api/v1/auth`);
        console.log(`📊 Environment: ${process.env.NODE_ENV}`);
      });

      // Graceful shutdown
      process.on('SIGTERM', this.shutdown.bind(this));
      process.on('SIGINT', this.shutdown.bind(this));

    } catch (error) {
      console.error('❌ Failed to start server:', error);
      process.exit(1);
    }
  }

  private async shutdown(): Promise<void> {
    console.log('\n🛑 Shutting down gracefully...');
    
    try {
      await database.close();
      await redisConfig.close();
      console.log('✅ All connections closed');
      process.exit(0);
    } catch (error) {
      console.error('❌ Error during shutdown:', error);
      process.exit(1);
    }
  }
}

// Start server
const server = new Server();
server.start();
