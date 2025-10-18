// src/config/database.ts
import { Pool } from 'pg';

class Database {
  private pool: Pool;

  constructor() {
    this.pool = new Pool({
      user: process.env.DB_USER || 'postgres',
      host: process.env.DB_HOST || 'localhost',
      database: process.env.DB_NAME || 'ai_skincare',
      password: process.env.DB_PASSWORD || 'postgres123',
      port: parseInt(process.env.DB_PORT || '5432'),
      max: 20,
      min: 2,
      idleTimeoutMillis: 30000,
      connectionTimeoutMillis: 10000,
      // SSL configuration for Docker
      ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
    });

    // Test connection với retry logic
    this.testConnectionWithRetry();
  }

  private async testConnectionWithRetry(maxRetries: number = 5): Promise<void> {
    let retries = 0;
    
    while (retries < maxRetries) {
      try {
        const client = await this.pool.connect();
        console.log('✅ Database connected successfully');
        client.release();
        return;
      } catch (error) {
        retries++;
        console.log(`❌ Database connection attempt ${retries}/${maxRetries} failed:`, error);
        
        if (retries === maxRetries) {
          console.error('💥 All database connection attempts failed');
          throw error;
        }
        
        // Wait before retry (exponential backoff)
        const waitTime = Math.pow(2, retries) * 1000;
        console.log(`⏳ Retrying database connection in ${waitTime}ms...`);
        await this.sleep(waitTime);
      }
    }
  }

  private sleep(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  getPool(): Pool {
    return this.pool;
  }

  async query(text: string, params?: any[]): Promise<any> {
    const start = Date.now();
    try {
      const result = await this.pool.query(text, params);
      const duration = Date.now() - start;
      console.log('Executed query', { text: text.substring(0, 100), duration, rows: result.rowCount });
      return result;
    } catch (error) {
      console.error('Query error:', error);
      throw error;
    }
  }

  // ✅ Thêm healthCheck method bị thiếu
  async healthCheck(): Promise<boolean> {
    try {
      const result = await this.query('SELECT 1 as health');
      return result.rows[0].health === 1;
    } catch (error) {
      console.error('Database health check failed:', error);
      return false;
    }
  }

  async close(): Promise<void> {
    await this.pool.end();
    console.log('Database connection closed');
  }
}

export default new Database();
