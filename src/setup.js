import fs from 'node:fs/promises';
import path from 'node:path';
import readline from 'node:readline';
import { fileURLToPath } from 'node:url';
import pg from 'pg';
import bcrypt from 'bcrypt';

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
 * Meminta input password dengan menampilkan karakter masker '*' jika didukung terminal
 * @param {string} query
 * @returns {Promise<string>}
 */
function askPassword(query) {
	return new Promise((resolve) => {
		const stdin = process.stdin;
		if (!stdin.isTTY || typeof stdin.setRawMode !== 'function') {
			// Fallback ke readline biasa jika terminal tidak mendukung raw mode / non-TTY
			const rl = readline.createInterface({
				input: process.stdin,
				output: process.stdout
			});
			rl.question(query, (ans) => {
				rl.close();
				resolve(ans);
			});
			return;
		}

		process.stdout.write(query);
		stdin.setRawMode(true);
		stdin.resume();
		stdin.setEncoding('utf-8');

		let password = '';
		
		const onData = (chunk) => {
			chunk = chunk.toString();
			for (let i = 0; i < chunk.length; i++) {
				const char = chunk[i];
				switch (char) {
					case '\n':
					case '\r':
					case '\u0004': // End of transmission
						stdin.removeListener('data', onData);
						stdin.setRawMode(false);
						stdin.pause();
						process.stdout.write('\n');
						resolve(password);
						return;
					case '\u0003': // Ctrl+C
						stdin.removeListener('data', onData);
						stdin.setRawMode(false);
						stdin.pause();
						process.stdout.write('\n');
						process.exit(130);
						return;
					case '\u0008':
					case '\x7f': // Backspace
						if (password.length > 0) {
							password = password.slice(0, -1);
							process.stdout.write('\b \b');
						}
						break;
					default:
						password += char;
						process.stdout.write('*');
						break;
				}
			}
		};
		
		stdin.on('data', onData);
	});
}

/**
 * Menguji koneksi database menggunakan single client pg
 * @param {object} config 
 * @returns {Promise<boolean>}
 */
async function testConnection(config) {
	const client = new pg.Client({
		host: config.host,
		port: config.port,
		user: config.user,
		password: config.password,
		database: 'postgres' // Hubungkan ke db bawaan untuk tes
	});
	try {
		await client.connect();
		await client.end();
		return true;
	} catch (err) {
		console.error(`\n❌ \x1b[31mKoneksi gagal:\x1b[0m ${err.message}\n`);
		return false;
	}
}

/**
 * Membuat database jika belum ada
 * @param {object} config 
 * @param {string} dbName 
 */
async function createDatabaseIfNotExists(config, dbName) {
	const client = new pg.Client({
		host: config.host,
		port: config.port,
		user: config.user,
		password: config.password,
		database: 'postgres'
	});
	try {
		await client.connect();
		const res = await client.query('SELECT 1 FROM pg_database WHERE datname = $1', [dbName]);
		if (res.rowCount === 0) {
			console.log(`🔨 Database \x1b[36m${dbName}\x1b[0m tidak ditemukan. Membuat database baru...`);
			const escapedDbName = dbName.replace(/"/g, '""');
			await client.query(`CREATE DATABASE "${escapedDbName}"`);
			console.log(`✅ Database \x1b[32m${dbName}\x1b[0m berhasil dibuat.`);
		} else {
			console.log(`✅ Database \x1b[32m${dbName}\x1b[0m sudah ada.`);
		}
	} finally {
		await client.end();
	}
}

/**
 * Fungsi utama untuk menjalankan setup dengan konfirmasi project & database
 * @returns {Promise<void>}
 */
async function runSetup() {
	try {
		console.log('📝 \x1b[1m\x1b[36mKonfigurasi Project Baru\x1b[0m\n');

		// 1. Tanya nama project (default nama direktori saat ini)
		const defaultProjectName = path.basename(rootDir);
		const projectNameInput = await askQuestion(`Masukkan nama project [${defaultProjectName}]: `);
		const projectName = projectNameInput.trim() || defaultProjectName;

		// Tanya title project (default nama project)
		const defaultProjectTitle = projectName;
		const projectTitleInput = await askQuestion(`Masukkan title project [${defaultProjectTitle}]: `);
		const projectTitle = projectTitleInput.trim() || defaultProjectTitle;

		// 2. Tanya nama repo (default @myuser/namaproject)
		const defaultRepoName = `@myuser/${projectName}`;
		const repoNameInput = await askQuestion(`Masukkan nama repo [${defaultRepoName}]: `);
		const repoName = repoNameInput.trim() || defaultRepoName;

		// Ambil default service port dari .env-example jika ada
		let defaultServicePort = '3003';
		try {
			const envExample = await fs.readFile(path.join(rootDir, '.env-example'), 'utf-8');
			const match = envExample.match(/^PORT\s*=\s*(\d+)/m);
			if (match) {
				defaultServicePort = match[1];
			}
		} catch (e) {
			// ignore
		}

		// Tanya Service Port
		const servicePortInput = await askQuestion(`Masukkan port service [${defaultServicePort}]: `);
		const servicePort = servicePortInput.trim() || defaultServicePort;

		// Tanya default username & password
		const defaultUserInput = await askQuestion(`Masukkan default username [admin]: `);
		const defaultUser = defaultUserInput.trim() || 'admin';

		const defaultPassInput = await askPassword(`Masukkan default password [admin]: `);
		const defaultPass = defaultPassInput || 'admin';

		// Loop input database sampai koneksi berhasil
		let dbConfig = { host: 'localhost', port: 5432, user: 'postgres', password: '' };
		let isConnected = false;

		while (!isConnected) {
			console.log('\n🔑 \x1b[36mKonfigurasi Database PostgreSQL\x1b[0m');
			const hostInput = await askQuestion(`   Host [${dbConfig.host}]: `);
			const portInput = await askQuestion(`   Port [${dbConfig.port}]: `);
			const userInput = await askQuestion(`   User [${dbConfig.user}]: `);
			const passwordInput = await askPassword(`   Password: `);

			dbConfig.host = hostInput.trim() || dbConfig.host;
			dbConfig.port = portInput.trim() ? parseInt(portInput.trim(), 10) : dbConfig.port;
			dbConfig.user = userInput.trim() || dbConfig.user;
			dbConfig.password = passwordInput; // password boleh kosong

			console.log('🔄 Menguji koneksi ke database...');
			isConnected = await testConnection(dbConfig);
		}

		console.log('✅ Koneksi database berhasil verifikasi.');

		// Tanya nama database (default project name)
		const defaultDbName = `${projectName}-db`;
		const dbNameInput = await askQuestion(`\nMasukkan nama database [${defaultDbName}]: `);
		const dbname = dbNameInput.trim() || defaultDbName;

		// 3. Konfirmasi bersama-sama sebelum eksekusi
		console.log('\n⚠️  \x1b[31mPERHATIAN:\x1b[0m Anda akan melakukan setup dengan konfigurasi berikut:');
		console.log(`   Nama Project : \x1b[33m${projectName}\x1b[0m`);
		console.log(`   Title Project: \x1b[33m${projectTitle}\x1b[0m`);
		console.log(`   Nama Repo    : \x1b[33m${repoName}\x1b[0m`);
		console.log(`   Service Port : \x1b[33m${servicePort}\x1b[0m`);
		console.log(`   Default User : \x1b[33m${defaultUser}\x1b[0m`);
		console.log(`   DB Host      : \x1b[33m${dbConfig.host}\x1b[0m`);
		console.log(`   DB Port      : \x1b[33m${dbConfig.port}\x1b[0m`);
		console.log(`   DB User      : \x1b[33m${dbConfig.user}\x1b[0m`);
		console.log(`   DB Name      : \x1b[33m${dbname}\x1b[0m`);

		const answer = await askQuestion('\nApakah Anda yakin? (y/N): ');
		const confirmed = answer.trim().toLowerCase() === 'y';

		if (!confirmed) {
			console.log('❌ Setup dibatalkan oleh pengguna.');
			process.exit(0);
		}

		// Update package.json
		console.log('\n✍️  Mengupdate package.json...');
		const packageJsonPath = path.join(rootDir, 'package.json');
		const packageJsonContent = await fs.readFile(packageJsonPath, 'utf-8');
		const packageJson = JSON.parse(packageJsonContent);
		packageJson.name = repoName;
		await fs.writeFile(packageJsonPath, JSON.stringify(packageJson, null, 2), 'utf-8');
		console.log('✅ package.json berhasil diupdate.');

		// Copy dan update .code-workspace
		console.log('✍️  Membuat dan mengupdate file workspace...');
		const workspaceSrcPath = path.join(rootDir, '.code-workspace');
		const workspaceContent = await fs.readFile(workspaceSrcPath, 'utf-8');
		const workspaceJson = JSON.parse(workspaceContent);
		
		if (workspaceJson.folders && workspaceJson.folders.length > 0) {
			workspaceJson.folders[0].name = projectName;
		}
		
		if (workspaceJson.launch && Array.isArray(workspaceJson.launch.configurations)) {
			for (const config of workspaceJson.launch.configurations) {
				if (config.url) {
					config.url = `http://localhost:${servicePort}`;
				}
			}
		}
		
		const workspaceDestPath = path.join(rootDir, `${projectName}.code-workspace`);
		await fs.writeFile(workspaceDestPath, JSON.stringify(workspaceJson, null, 2), 'utf-8');
		console.log(`✅ File ${projectName}.code-workspace berhasil dibuat.`);

		// Copy .env-example ke .env dan update nilainya
		console.log('✍️  Membuat dan mengupdate file .env dari .env-example...');
		const envKeys = {
			PORT: servicePort,
			APPNAME: projectName,
			APPTITLE: projectTitle,
			APPTILE: projectTitle,
			DB_HOST: dbConfig.host,
			DB_PORT: dbConfig.port,
			DB_USER: dbConfig.user,
			DB_PASS: dbConfig.password,
			DB_NAME: dbname,
			LOGGER_DB_HOST: dbConfig.host,
			LOGGER_DB_PORT: dbConfig.port,
			LOGGER_DB_USER: dbConfig.user,
			LOGGER_DB_PASS: dbConfig.password,
			LOGGER_DB_NAME: dbname
		};

		let envContent = await fs.readFile(path.join(rootDir, '.env-example'), 'utf-8');
		for (const [key, val] of Object.entries(envKeys)) {
			const regex = new RegExp(`^(\\s*${key}\\s*=\\s*).*$`, 'm');
			let formattedVal = val;
			if (key !== 'PORT' && key !== 'DB_PORT' && key !== 'LOGGER_DB_PORT') {
				const escapedVal = String(val).replace(/"/g, '\\"');
				formattedVal = `"${escapedVal}"`;
			}
			if (regex.test(envContent)) {
				envContent = envContent.replace(regex, `$1${formattedVal}`);
			} else {
				envContent += `\n${key}=${formattedVal}`;
			}
		}
		await fs.writeFile(path.join(rootDir, '.env'), envContent, 'utf-8');
		console.log('✅ File .env berhasil dibuat dan diupdate.');

		// Mengganti {nama project} di login.html dengan nama project yang sebenarnya
		try {
			console.log('✍️  Mengupdate nama project di login.html...');
			const loginHtmlPath = path.join(rootDir, 'public', 'modules', 'login', 'login.html');
			let loginHtmlContent = await fs.readFile(loginHtmlPath, 'utf-8');
			loginHtmlContent = loginHtmlContent.replace(/{nama project}/g, projectName);
			await fs.writeFile(loginHtmlPath, loginHtmlContent, 'utf-8');
			console.log('✅ File login.html berhasil diupdate.');
		} catch (e) {
			console.warn('⚠️ Gagal mengupdate login.html:', e.message);
		}

		// Pastikan Database target ada
		await createDatabaseIfNotExists(dbConfig, dbname);

		// Set variables di process.env sebelum load module db.js
		process.env.DB_HOST = dbConfig.host;
		process.env.DB_PORT = String(dbConfig.port);
		process.env.DB_USER = dbConfig.user;
		process.env.DB_PASS = dbConfig.password;
		process.env.DB_NAME = dbname;

		console.log('\n🏁 Memulai proses setup database...\n');

		// Hubungkan ke database target
		const { default: db } = await import('@agung_dhewe/webapps/src/db.js');

		for (const filePath of sqlFiles) {
			const fileName = path.basename(filePath);
			console.log(`📄 Membaca file: \x1b[36m${fileName}\x1b[0m`);
			let sqlContent = await fs.readFile(filePath, 'utf-8');

			if (fileName === 'core_sample_data.sql') {
				console.log(`🔧 Menyesuaikan data konfigurasi pada ${fileName}...`);
				// Ganti apps_id dan apps_name dengan projectName
				sqlContent = sqlContent.replace(/'accounting'/g, `'${projectName}'`);
				sqlContent = sqlContent.replace(/'Accounting Apps'/g, `'${projectName}'`);

				// Ganti apps_url dengan localhost dan port service yang diinput
				sqlContent = sqlContent.replace(/'https:\/\/act-dev\.transfashion\.id'/g, `'http://localhost:${servicePort}'`);

				// Ganti user_name, user_nickname, user_fullname, dan user_password dengan default user & hashed password
				const saltRounds = 10;
				const hashedPass = await bcrypt.hash(defaultPass, saltRounds);
				sqlContent = sqlContent.replace(
					/VALUES\s*\(\s*240100000\s*,\s*'[^']+'\s*,\s*'[^']+'\s*,\s*'[^']+'\s*,\s*'[^']+'\s*,\s*'[^']+'/g,
					`VALUES (240100000, '${defaultUser}', '${defaultUser}', '${defaultUser}', 'your@email.com', '${hashedPass}'`
				);
			}

			console.log(`⚡ Mengeksekusi ${fileName} pada database...`);
			await db.none(sqlContent);
			console.log(`✅ Berhasil mengeksekusi \x1b[32m${fileName}\x1b[0m\n`);
		}

		console.log('🎉 Setup database dan konfigurasi project selesai dengan sukses!');

		if (process.platform === 'linux' || process.platform === 'darwin') {
			try {
				await fs.chmod(path.join(rootDir, 'run'), 0o755);
				console.log('✅ File run berhasil diubah menjadi executable.');
			} catch (e) {
				console.warn('⚠️ Gagal mengubah permission file run:', e.message);
			}
		}

		process.exit(0);
	} catch (error) {
		console.error('\n❌ \x1b[31mError saat setup:\x1b[0m', error.message || error);
		process.exit(1);
	}
}

// Jalankan fungsi setup
runSetup();
