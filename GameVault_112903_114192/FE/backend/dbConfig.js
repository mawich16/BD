const sql = require('mssql');
const dotenv = require('dotenv');

dotenv.config();

const dbConfig = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    server: process.env.DB_SERVER,
    database: process.env.DB_DATABASE,
    port: parseInt(process.env.DB_PORT, 10),
    options: {
        encrypt: true,
        trustServerCertificate: true
    }
};

const connectDB = async () => {
    console.log('Connecting to database with the following config:', dbConfig);
    try {
        const pool = await sql.connect(dbConfig);
        console.log('Database connected successfully');
        return pool;
    } catch (err) {
        console.error('Database connection failed:', err);
    }
};

module.exports = connectDB;