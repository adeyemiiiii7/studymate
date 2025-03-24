const express = require('express');
const adminAuth = require('../middleware/adminAuth');
const User = require('../models/user');
const adminRouter = express.Router();
const { Op } = require('sequelize');

// Get all users with simple filtering
adminRouter.get('/api/admin/users', adminAuth, async (req, res) => {
  try {
    // Add pagination
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;
    
    // Add filtering
    const filter = {};
    if (req.query.role) {
      filter.role = req.query.role;
    }
    if (req.query.level) {
      filter.level = req.query.level;
    }
    if (req.query.department) {
      filter.department = { [Op.iLike]: `%${req.query.department}%` };
    }
    if (req.query.search) {
      filter[Op.or] = [
        { first_name: { [Op.iLike]: `%${req.query.search}%` } },
        { last_name: { [Op.iLike]: `%${req.query.search}%` } },
        { email: { [Op.iLike]: `%${req.query.search}%` } }
      ];
    }
    
    const { count, rows } = await User.findAndCountAll({
      where: filter,
      attributes: [
        'user_id', 'first_name', 'last_name', 'email', 
        'department', 'course_of_study', 'role', 'level', 
        'createdAt'
      ],
      order: [['createdAt', 'DESC']],
      limit,
      offset
    });
    
    res.status(200).json({
      users: rows,
      totalUsers: count,
      currentPage: page,
      totalPages: Math.ceil(count / limit)
    });
  } catch (error) {
    console.error('Error fetching users:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Update user role - simple endpoint to change between student and course_rep
adminRouter.patch('/api/admin/users/:userId/role', adminAuth, async (req, res) => {
  try {
    const { role } = req.body;
    
    // Validate role
    if (role !== 'student' && role !== 'course_rep') {
      return res.status(400).json({ error: 'Invalid role. Role must be either "student" or "course_rep".' });
    }
    
    const user = await User.findByPk(req.params.userId);
    
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    // Update user role
    await user.update({ role });
    
    res.status(200).json({
      message: 'User role updated successfully',
      user: {
        user_id: user.user_id,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        department: user.department,
        course_of_study: user.course_of_study,
        level: user.level,
        role: user.role
      }
    });
  } catch (error) {
    console.error('Error updating user role:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = adminRouter;