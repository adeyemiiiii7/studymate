const { Op } = require('sequelize');
const User = require('../models/user');

const updateStreak = async (userId) => {
  const user = await User.findByPk(userId);
  if (!user) {
    throw new Error('User not found');
  }

  const today = new Date().toISOString().split('T')[0];
  const yesterday = new Date(today);
  yesterday.setDate(yesterday.getDate() - 1);
  const yesterdayString = yesterday.toISOString().split('T')[0];

  if (!user.last_active_date) {
    // First activity
    user.current_streak = 1;
    user.highest_streak = 1;
    user.total_active_days = 1;
  } else if (user.last_active_date === yesterdayString) {
    // User was active yesterday, increment streak
    user.current_streak += 1;
    user.highest_streak = Math.max(user.current_streak, user.highest_streak);
    user.total_active_days += 1;
  } else if (user.last_active_date !== today) {
    // User wasn't active yesterday, reset streak
    user.current_streak = 1;
    user.total_active_days += 1;
  }

  user.last_active_date = today;
  await user.save();

  return user;
};

module.exports = { updateStreak };