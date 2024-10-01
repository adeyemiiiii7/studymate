const express = require('express');
const bcryptjs = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/user');
const authRouter = express.Router();
const validator = require('validator');
require('dotenv').config();

authRouter.post('/users/signup', async (req, res) => {
  try {
    const { name, email, password, level } = req.body;
    const trimmedEmail = email.trim();
    console.log(`Received email: '${trimmedEmail}'`);
    
    if (!validator.isEmail(trimmedEmail)) {
      return res.status(400).json({ error: 'Invalid email format' });
    }
    // Check if the email ends with @student.babcock.edu.ng
    if (!trimmedEmail.endsWith('@student.babcock.edu.ng')) {
      return res.status(400).json({ error: 'Only @student.babcock.edu.ng emails are allowed' });
    }
    const existingUser = await User.findOne({ where: { email: trimmedEmail } });
    if (existingUser) {
      return res.status(400).json({ message: 'Email already exists' });
    }
    const parsedLevel = parseInt(level, 10);
    if (isNaN(parsedLevel) || parsedLevel < 100 || parsedLevel > 600) {
      return res.status(400).json({ error: 'Invalid level. Must be an integer between 100 and 600.' });
    }
    const hashedPassword = await bcryptjs.hash(password, 10);
    const user = await User.create({ 
      name,
      email: trimmedEmail,
      password: hashedPassword,
      role: 'student',  
      level: parsedLevel
    });
    
    res.status(201).json({
      message: 'User created successfully',
      user: {
        name: user.name,
        email: user.email,
        role: user.role,
        level: user.level
      }
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

authRouter.post('/users/signin', async (req, res) => {
  try {
    const { email, password } = req.body;
    const trimmedEmail = email.trim().toLowerCase();

    const user = await User.findOne({ where: { email: trimmedEmail } });
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    const isPasswordValid = await bcryptjs.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(401).json({ error: 'Invalid password' });
    }
    // Include the user's ID in the token
    const token = jwt.sign(
      { id: user.user_id },
      process.env.JWT_SECRET || 'defaultSecret',
      { expiresIn: '1d'
        
       }
    );
    res.status(200).json({
      message: 'Sign-in successful',
      token,
      user: {
        id: user.user_id,
        name: user.name,
        email: user.email,
        role: user.role,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});
module.exports = authRouter;
