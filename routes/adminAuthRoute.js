const express = require('express');
const bcryptjs = require('bcryptjs');
const jwt = require('jsonwebtoken');
const Admin = require('../models/admin');
const adminAuthRouter = express.Router();
require('dotenv').config();

// Admin login route
adminAuthRouter.post('/api/admin/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    const trimmedEmail = email.trim().toLowerCase();

    const admin = await Admin.findOne({ where: { email: trimmedEmail } });
    if (!admin) {
      return res.status(404).json({ error: 'Admin not found' });
    }

    const isPasswordValid = await bcryptjs.compare(password, admin.password);
    if (!isPasswordValid) {
      return res.status(401).json({ error: 'Invalid password' });
    }

    const token = jwt.sign(
      { id: admin.admin_id, isAdmin: true },
      process.env.JWT_ADMIN_SECRET || process.env.JWT_SECRET || 'defaultAdminSecret',
      { expiresIn: '1d' }
    );

    res.status(200).json({
      message: 'Admin login successful',
      token,
      admin: {
        id: admin.admin_id,
        username: admin.username,
        email: admin.email,
        is_super_admin: admin.is_super_admin
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});


adminAuthRouter.post('/api/admin/setup', async (req, res) => {
  try {
    const { username, email, password, setupKey } = req.body;
    console.log('Received setup key:', setupKey);
    console.log('Expected setup key:', process.env.ADMIN_SETUP_KEY);
    
    if (setupKey !== process.env.ADMIN_SETUP_KEY) {
      return res.status(403).json({ error: 'Invalid setup key' });
    }
    
    // Check if admin already exists
    const existingAdmin = await Admin.findOne({ where: { email } });
    if (existingAdmin) {
      return res.status(400).json({ error: 'Admin already exists' });
    }
    
    // Create the first admin (super admin)
    const admin = await Admin.create({
      username,
      email,
      password,
      is_super_admin: true
    });
    
    res.status(201).json({
      message: 'Admin account created successfully',
      admin: {
        id: admin.admin_id,
        username: admin.username,
        email: admin.email,
        is_super_admin: admin.is_super_admin
      }
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = adminAuthRouter;