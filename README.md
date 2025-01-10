# faculty_stat_monitoring

A new Flutter project.

SQL

CREATE DATABASE faculty_db;
USE faculty_db;

SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;

DROP TABLE users;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

SELECT User, Host, plugin FROM mysql.user WHERE User = 'root';

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'admin';

FLUSH PRIVILEGES;

-- GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'admin' WITH GRANT OPTION;
-- FLUSH PRIVILEGES;

CREATE USER 'cy'@'%' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON *.* TO 'cy'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

ALTER TABLE users
ADD COLUMN status ENUM('In', 'Out', 'On Meeting', 'Out of Office') DEFAULT 'In',
ADD COLUMN role ENUM('Admin', 'Faculty') DEFAULT 'Faculty';

-- Run after the UI update 
ALTER TABLE users
ADD COLUMN timestamp VARCHAR(255) DEFAULT '';

INSERT INTO users (firstname, lastname, email, password, status, role)
VALUES ('Admin', 'User', 'admin@example.com', '', 'In', 'Admin');

UPDATE users
SET password= '$2a$10$zR3nDZ7vjC6BDHLTB9AWTulPwdpEzXp1xYjJObSTE1/xtTVV4BT9i'
WHERE id = 2;


DELETE FROM users WHERE firstname NOT IN ('Admin');

SELECT * FROM users WHERE email = 'admin@example.com';
SELECT * FROM users;

CREATE TABLE status_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    status ENUM('In', 'Out', 'On Meeting', 'Out of Office') NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
