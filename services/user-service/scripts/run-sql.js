const { readFileSync } = require('fs');
const { Client } = require('pg');

async function main() {
  const file = process.argv[2];
  if (!file) {
    console.error('Usage: node scripts/run-sql.js <sql-file>');
    process.exit(1);
  }
  const sql = readFileSync(file, 'utf8');
  const client = new Client({
    host: process.env.DB_HOST,
    port: Number(process.env.DB_PORT || 5432),
    database: process.env.DB_NAME,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
  });
  await client.connect();
  try {
    await client.query('BEGIN');
    await client.query(sql);
    await client.query('COMMIT');
    console.log('Migration executed successfully.');
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('Migration failed:', err.message);
    process.exit(1);
  } finally {
    await client.end();
  }
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
