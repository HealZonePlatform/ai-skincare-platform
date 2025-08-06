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
      // Test database connection
      await database.query('SELECT 1');
      console.log('✅ Database connection verified');

      // Test Redis connection
      await redisConfig.set('test', 'connection');
      await redisConfig.del('test');
      console.log('✅ Redis connection verified');

      // Start server
      this.app.app.listen(this.port, () => {
        console.log(`🚀 Auth Service running on port ${this.port}`);
        console.log(`🔗 Health check: http://localhost:${this.port}/health`);
        console.log(`🔐 Auth API: http://localhost:${this.port}/api/v1/auth`);
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
