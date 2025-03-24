const jwt = require('jsonwebtoken');
const Admin = require('../models/admin');
require('dotenv').config();

const adminAuth = async (req, res, next) => {
  try {
    const token = req.header('Authorization')?.replace('Bearer ', '');
    
    if (!token) {
      return res.status(401).json({ error: 'Authentication required' });
    }
    
    const decoded = jwt.verify(
      token, 
      process.env.JWT_ADMIN_SECRET || process.env.JWT_SECRET || 'defaultAdminSecret'
    );
    
    if (!decoded.isAdmin) {
      return res.status(403).json({ error: 'Admin privileges required' });
    }
    
    const admin = await Admin.findOne({ where: { admin_id: decoded.id } });
    
    if (!admin) {
      return res.status(401).json({ error: 'Invalid authentication token' });
    }
    
    req.admin = admin;
    req.token = token;
    next();
  } catch (error) {
    console.error('Authentication error:', error);
    res.status(401).json({ error: 'Authentication failed' });
  }
};

module.exports = adminAuth;