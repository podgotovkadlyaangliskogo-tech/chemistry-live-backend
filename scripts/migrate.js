const fs = require('fs');
const path = require('path');
const { Client } = require('pg');

const password = encodeURIComponent('Damiyr_2010_2016_');
const connectionString = `postgresql://postgres.pnrlulybmpiutugxrkkj:${password}@aws-1-ap-south-1.pooler.supabase.com:5432/postgres`;

async function main() {
  console.log('Connecting to Supabase PostgreSQL at aws-1-ap-south-1...');
  const client = new Client({
    connectionString,
    ssl: { rejectUnauthorized: false }
  });

  await client.connect();
  console.log('CONNECTED to database successfully!\n');

  const migrationsDir = path.join(__dirname, '..', 'supabase', 'migrations');
  const files = [
    '001_initial_schema.sql',
    '002_rls_policies.sql',
    '003_realtime_config.sql',
    '004_seed_questions.sql'
  ];

  for (const file of files) {
    const filePath = path.join(migrationsDir, file);
    console.log(`Executing ${file}...`);
    const sql = fs.readFileSync(filePath, 'utf8');
    try {
      await client.query(sql);
      console.log(`  -> SUCCESS: ${file} executed!`);
    } catch (err) {
      console.error(`  -> ERROR in ${file}:`, err.message);
    }
  }

  // Check tables
  console.log('\n--- VERIFYING CREATED TABLES ---');
  const tables = await client.query(`
    SELECT table_name 
    FROM information_schema.tables 
    WHERE table_schema = 'public' 
    ORDER BY table_name;
  `);
  console.log('Tables in public schema:');
  tables.rows.forEach(r => console.log(' - ' + r.table_name));

  // Check questions
  console.log('\n--- VERIFYING SEEDED QUESTIONS ---');
  const qCount = await client.query('SELECT count(*) as count FROM public.questions;');
  console.log('Total questions in DB:', qCount.rows[0].count);

  const optsCount = await client.query('SELECT count(*) as count FROM public.answer_options;');
  console.log('Total answer options in DB:', optsCount.rows[0].count);

  const quiz = await client.query('SELECT id, title, is_active FROM public.quizzes LIMIT 1;');
  console.log('Quiz found:', quiz.rows[0]);

  await client.end();
  console.log('\nALL TABLES AND DATA CREATED SUCCESSFULLY IN SUPABASE!');
}

main().catch(err => {
  console.error('Fatal error:', err);
  process.exit(1);
});
