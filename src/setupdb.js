import fs from 'node:fs/promises';
import path from 'node:path';
import readline from 'node:readline';
import { fileURLToPath } from 'node:url';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

/**
 * Mendapatkan direktori root project
 */
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const rootDir = path.join(__dirname, '..');

/**
 * Daftar file setup database secara berurutan
 * @type {string[]}
 */
const sqlFiles = [
	path.join(rootDir, 'setupdb', 'core_schema.sql'),
	path.join(rootDir, 'setupdb', 'log_schema.sql'),
	path.join(rootDir, 'setupdb', 'core_sample_data.sql')
];

/**
 * Menampilkan prompt pertanyaan untuk konfirmasi
 * @param {string} query
 * @returns {Promise<string>}
 */
function askQuestion(query) {
	const rl = readline.createInterface({
		input: process.stdin,
		output: process.stdout
	});
	return new Promise((resolve) => rl.question(query, (ans) => {
		rl.close();
		resolve(ans);
	}));
}

/**
 * Fungsi utama untuk menjalankan setup database dengan konfirmasi
 * @returns {Promise<void>}
 */
async function runSetup() {
	try {
		const host = process.env.DB_HOST;
		const dbName = process.env.DB_NAME;
		const dbUser = process.env.DB_USER;

		console.log('⚠️  \x1b[31mPERHATIAN:\x1b[0m Anda akan melakukan setup database dengan konfigurasi berikut:');
		console.log(`   Host     : \x1b[33m${host}\x1b[0m`);
		console.log(`   Database : \x1b[33m${dbName}\x1b[0m`);
		console.log(`   User     : \x1b[33m${dbUser}\x1b[0m`);

		const answer = await askQuestion('\nApakah Anda yakin? (y/N): ');
		const confirmed = answer.trim().toLowerCase() === 'y';

		if (!confirmed) {
			console.log('❌ Setup dibatalkan oleh pengguna.');
			process.exit(0);
		}

		console.log('\n🏁 Memulai proses setup database...\n');

		// Hubungkan ke database setelah konfirmasi
		const { default: db } = await import('@agung_dhewe/webapps/src/db.js');

		for (const filePath of sqlFiles) {
			const fileName = path.basename(filePath);
			console.log(`📄 Membaca file: \x1b[36m${fileName}\x1b[0m`);
			
			// Membaca isi file SQL
			const sqlContent = await fs.readFile(filePath, 'utf-8');
			
			console.log(`⚡ Mengeksekusi ${fileName} pada database...`);
			
			// Menjalankan SQL di database
			await db.none(sqlContent);
			
			console.log(`✅ Berhasil mengeksekusi \x1b[32m${fileName}\x1b[0m\n`);
		}

		console.log('🎉 Setup database selesai dengan sukses!');
		process.exit(0);
	} catch (error) {
		console.error('\n❌ \x1b[31mError saat setup database:\x1b[0m', error.message || error);
		process.exit(1);
	}
}

// Jalankan fungsi setup
runSetup();
