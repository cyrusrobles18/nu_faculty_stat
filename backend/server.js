const express = require('express');
// const mysql = require('mysql');
const mysql = require('mysql2/promise');
const bcrypt = require('bcrypt');
const bodyParser = require('body-parser');
const cors = require('cors');
require('dotenv').config();
const jwt = require('jsonwebtoken');
// Create Express app
const app = express();
app.use(bodyParser.json());
app.use(cors());
const path = require('path');
// app.use(express.static(path.join(__dirname, 'build/web')));
// Create MySQL connection using environment variables
const db = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  // connectionLimit: 10,
  // queueLimit: 0,
});

// Connect to MySQL
// db.connect((err) => {
//   if (err) {
//     console.error('MySQL connection error:', err);
//     return;
//   }
//   console.log('Connected to MySQL database');
// });


// Serve static files from the Flutter web build directory
// const staticPath = process.env.STATIC_PATH || 'build/web';
// app.use(express.static(path.join(__dirname, '..', staticPath)));
app.use(express.static(path.join(__dirname, '..', 'build/web')));

// For all other routes, serve the index.html file, enabling the Flutter web router to handle navigation
// app.get('*', (req, res) => {
//   res.sendFile(path.join(__dirname, '..', 'build/web', 'index.html'));
// });

// Registration endpoint
app.post('/api/addfaculty', async (req, res) => {
  const { firstname, lastname, email, password, role } = req.body;

  // Input validation
  if (!firstname || !lastname || !email || !password || !role) {
    return res.status(400).json({ message: 'All fields are required' });
  }

  try {
    // Check if user already exists
    const [rows] = await db.query('SELECT * FROM users WHERE email = ?', [email]);
    if (rows.length > 0) {
      return res.status(400).json({ message: 'Email already in use' });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Insert new user
    await db.query(
      'INSERT INTO users (firstname, lastname, email, password, role) VALUES (?, ?, ?, ?, ?)',
      [firstname, lastname, email, hashedPassword, role]
    );

    res.status(200).json({ message: 'User registered successfully' });
  } catch (err) {
    console.error('Error adding faculty:', err);
    res.status(500).json({ message: 'Server error' });
  }
});


// Login endpoint
app.post('/api/login', async (req, res) => {
  const { email, password } = req.body;

  // Input validation
  if (!email || !password) {
    return res.status(400).json({ message: 'Email and password are required' });
  }

  try {
    const [rows] = await db.query('SELECT * FROM users WHERE email = ?', [email]);

    if (rows.length === 0) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    const user = rows[0];

    // Compare passwords
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    // Generate JWT token
    const token = jwt.sign(
      { id: user.id, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );

    res.status(200).json({ message: 'Login successful', token, user });
  } catch (err) {
    console.error('Error during login:', err);
    res.status(500).json({ message: 'Server error' });
  }
});

// Get all users (Admin only)
app.get('/api/users', async (req, res) => {
  // Extract token from Authorization header
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1]; // Expected format: 'Bearer TOKEN'

  if (!token) return res.sendStatus(401); // Unauthorized

  try {
    // Verify token
    const user = jwt.verify(token, process.env.JWT_SECRET);

    // Check user role
    if (user.role == 'Faculty') {
      return res.sendStatus(403); // Forbidden
    }

    // Proceed with fetching users
    const [results] = await db.query('SELECT id, firstname, lastname, email, status, role FROM users');
    res.status(200).json(results);
  } catch (err) {
    console.error('Error verifying token:', err);
    return res.sendStatus(403); // Forbidden
  }
});



// Update user status (Faculty)
app.put('/api/status', async (req, res) => {
  // Extract token from Authorization header
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) return res.sendStatus(401); // Unauthorized

  try {
    // Verify token
    const user = jwt.verify(token, process.env.JWT_SECRET);

    // Proceed with updating status
    const { status } = req.body;
    // const validStatuses = ['In', 'Out', 'On Meeting', 'Out of Office'];

    // if (!validStatuses.includes(status)) {
    //   return res.status(400).json({ message: 'Invalid status' });
    // }

    const userId = user.id;
    var [currentUser] = await db.query('SELECT * FROM users WHERE id = ?', [userId]);
    currentUser = currentUser[0];
    await db.query('UPDATE users SET status = ? WHERE id = ?', [status, userId]);
    res.status(200).json({ message: 'Status updated successfully', currentUser });
  } catch (err) {
    console.error('Error verifying token or updating status:', err);
    return res.sendStatus(403); // Forbidden
  }
});

// Update user role (Admin only)
app.put('/api/users/:id/role', async (req, res) => {
  // Extract token from Authorization header
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) return res.sendStatus(401); // Unauthorized

  try {
    // Verify token
    const user = jwt.verify(token, process.env.JWT_SECRET);

    // Check if user is Admin
    if (user.role !== 'Admin') {
      return res.sendStatus(403); // Forbidden
    }

    // Proceed with updating user role
    const userId = req.params.id;
    const { role } = req.body;
    const validRoles = ['Admin', 'Faculty'];

    if (!validRoles.includes(role)) {
      return res.status(400).json({ message: 'Invalid role' });
    }

    await db.query('UPDATE users SET role = ? WHERE id = ?', [role, userId]);
    res.status(200).json({ message: 'User role updated successfully' });
  } catch (err) {
    console.error('Error verifying token or updating role:', err);
    return res.sendStatus(403); // Forbidden
  }
});

// app.get('/api/users', async (req, res) => {
//   try {
//     // Skipping token validation for now, proceed with fetching users

//     // Fetch users from the database
//     const [results] = await db.query('SELECT id, firstname, lastname, email, status, role FROM users');

//     if (results.length === 0) {
//       return res.status(404).json({ message: 'No users found' });
//     }

//     res.status(200).json(results);  // Send the results as a JSON response
//   } catch (err) {
//     console.error('Error fetching users:', err);
//     return res.status(500).json({ message: 'Internal server error' });  // If there's a database issue
//   }
// });

// Get user by id
// app.post('/api/users/:id', async (req, res) => {
//   // Extract token from Authorization header
//   // const authHeader = req.headers['authorization'];
//   // const token = authHeader && authHeader.split(' ')[1];

//   // if (!token) return res.sendStatus(401); // Unauthorized

//   try {
//     // Verify token
//     // const user = jwt.verify(token, process.env.JWT_SECRET);


//     // Proceed with updating user role
//     const userId = req.params.id;

//    const currentUser = await db.query('SELECT * FROM users WHERE id = ?', [userId]);
//     res.status(200).json({ currentUser });
//   } catch (err) {
//     return res.status(500).json({ message: 'Internal server error' });
//   }
// });
// Revised get user by id
app.post('/api/users/:id', async (req, res) => {
  // Extract token from Authorization header
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) return res.sendStatus(401); // Unauthorized
  try {
    const userId = req.params.id;

    // Correct SQL syntax for the SELECT query
    var [currentUser] = await db.query('SELECT * FROM users WHERE id = ?', [userId]);

    // Check if a user was found
    if (currentUser.length === 0) {
      return res.status(404).json({ message: 'User not found' });
    }
    currentUser = currentUser[0];
    // Send the retrieved user data as the response
    res.status(200).json({ currentUser });
  } catch (err) {
    // Handle errors and return a proper error response
    console.error(err);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

// Handle other routes by serving the Flutter web app
// app.get('*', (req, res) => {
//   res.sendFile(path.join(__dirname, 'build/web', 'index.html'));
// });


// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
