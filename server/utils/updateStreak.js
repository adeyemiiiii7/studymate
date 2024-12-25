const { Op } = require('sequelize');
const User = require('../models/user');const updateStreak = async (userId) => {
  const user = await User.findByPk(userId);
  if (!user) {
    throw new Error('User not found');
  }

  const today = new Date().toISOString().split('T')[0];
  const yesterday = new Date(today);
  yesterday.setDate(yesterday.getDate() - 1);
  const yesterdayString = yesterday.toISOString().split('T')[0];

  const userLastActiveDate = user.last_active_date
    ? new Date(user.last_active_date).toISOString().split('T')[0]
    : null;

  console.log('Today:', today);
  console.log('Yesterday:', yesterdayString);
  console.log('Last Active Date:', userLastActiveDate);

  if (userLastActiveDate === today) {
    console.log('User already active today. Skipping streak update.');
    return user;
  }

  if (!userLastActiveDate) {
    console.log('First activity detected.');
    user.current_streak = 1;
    user.highest_streak = 1;
    user.total_active_days = 1;
  } else if (userLastActiveDate === yesterdayString) {
    console.log('User was active yesterday. Incrementing streak.');
    user.current_streak += 1;
    user.highest_streak = Math.max(user.current_streak, user.highest_streak);
    user.total_active_days += 1;
  } else {
    console.log('User was not active yesterday. Resetting streak.');
    user.current_streak = 1;
    user.total_active_days += 1;
  }

  user.last_active_date = today;
  await user.save();

  return user;
};

module.exports = { updateStreak };