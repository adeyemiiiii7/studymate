const { Op } = require('sequelize');
const User = require('../models/user');
const updateStreak = async (userId) => {
  const user = await User.findByPk(userId);
  if (!user) {
    throw new Error('User not found');
  }

  // Use UTC dates to avoid timezone issues
  const now = new Date();
  const today = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()));
  const yesterday = new Date(today);
  yesterday.setUTCDate(yesterday.getUTCDate() - 1);

  const userLastActiveDate = user.last_active_date
    ? new Date(Date.UTC(
        new Date(user.last_active_date).getUTCFullYear(),
        new Date(user.last_active_date).getUTCMonth(),
        new Date(user.last_active_date).getUTCDate()
      ))
    : null;

  // Convert dates to ISO strings for comparison
  const todayStr = today.toISOString().split('T')[0];
  const yesterdayStr = yesterday.toISOString().split('T')[0];
  const lastActiveDateStr = userLastActiveDate?.toISOString().split('T')[0];

  // Skip if already logged in today
  if (lastActiveDateStr === todayStr) {
    return user;
  }

  // Update streak logic
  if (!lastActiveDateStr) {
    // First activity
    user.current_streak = 1;
    user.highest_streak = 1;
    user.total_active_days = 1;
  } else if (lastActiveDateStr === yesterdayStr) {
    // Active consecutive day
    user.current_streak += 1;
    user.highest_streak = Math.max(user.current_streak, user.highest_streak);
    user.total_active_days += 1;
  } else {
    // Any break in consecutive days immediately resets streak to 1
    user.current_streak = 1;
    user.total_active_days += 1;
  }

  user.last_active_date = todayStr;
  await user.save();
  return user;
};
module.exports = { updateStreak };