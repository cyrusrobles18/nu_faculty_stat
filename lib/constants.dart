// ignore: constant_identifier_names
import 'package:flutter/material.dart';

String HOST = 'http://127.0.0.1:3000';
// String HOST = 'http://192.168.114.147:3000';
// String HOST = 'http://192.168.40.91:3000';

const Color NU_YELLOW = Color(0xFFffd41d);
const Color NU_BLUE = Color(0xFF35408f);
const Color STAT_GREEN_IN = Color(0xFF80a66c);
const Color STAT_YELLOW_OTOFFICE = Color(0xFFf2f2c5);
const Color STAT_ORANGE_MEETING = Color(0xFFf2a950);
const Color STAT_RED_OUT = Color(0xFFdd6761);
const Color STAT_RED_ONLEAVE = Color(0xFF72364d);
const Color STAT_BLUE_INCLASS = Color(0xFF003a78);

// SQL
// CREATE DATABASE faculty_db;
// USE faculty_db;

// SET SQL_SAFE_UPDATES = 0;
// SET SQL_SAFE_UPDATES = 1;

// DROP TABLE users;

// CREATE TABLE users (
//     id INT AUTO_INCREMENT PRIMARY KEY,
//     firstname VARCHAR(50) NOT NULL,
//     lastname VARCHAR(50) NOT NULL,
//     email VARCHAR(100) NOT NULL UNIQUE,
//     password VARCHAR(255) NOT NULL
// );

// SELECT User, Host, plugin FROM mysql.user WHERE User = 'root';

// ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'admin';

// FLUSH PRIVILEGES;

// -- GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'admin' WITH GRANT OPTION;
// -- FLUSH PRIVILEGES;

// CREATE USER 'cy'@'%' IDENTIFIED BY 'admin';
// GRANT ALL PRIVILEGES ON *.* TO 'cy'@'%' WITH GRANT OPTION;
// FLUSH PRIVILEGES;

// ALTER TABLE users
// ADD COLUMN status ENUM('In', 'Out', 'On Meeting', 'Out of Office') DEFAULT 'In';
// ALTER TABLE users CHANGE status status ENUM('In', 'Out', 'On Meeting', 'Out of Office', 'In Class', 'On Leave') DEFAULT 'In';
// ALTER TABLE users 
// CHANGE status status VARCHAR(50) DEFAULT 'In';

// -- ALTER TABLE users
// -- RENAME role TO full_name;
// ALTER TABLE users CHANGE role role ENUM('SuperAdmin','Admin', 'Faculty');
// -- ADD COLUMN role ENUM('Admin', 'Faculty') DEFAULT 'Faculty';

// -- Run after the UI update 
// ALTER TABLE users
// ADD COLUMN timestamp VARCHAR(255) DEFAULT '';

// INSERT INTO users (firstname, lastname, email, password, status, role)
// VALUES ('Admin', 'User', 'admin@example.com', '', 'In', 'Admin');

// UPDATE users
// SET password= '$2a$10$zR3nDZ7vjC6BDHLTB9AWTulPwdpEzXp1xYjJObSTE1/xtTVV4BT9i'
// WHERE id = 2;

// SELECT * from users;

// UPDATE users
// SET role= 'SuperAdmin'
// WHERE id = 2;

// UPDATE users
// SET role= 'SuperAdmin'
// WHERE id = 2;

// UPDATE users
// SET role= 'Admin'
// WHERE id = 20;

// DELETE FROM users WHERE firstname NOT IN ('Admin');

// SELECT * FROM users WHERE email = 'admin@example.com';
// SELECT * FROM users;

// CREATE TABLE status_log (
//     id INT AUTO_INCREMENT PRIMARY KEY,
//     user_id INT NOT NULL,
//     status ENUM('In', 'Out', 'On Meeting', 'Out of Office') NOT NULL,
//     timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
//     FOREIGN KEY (user_id) REFERENCES users(id)
// );
