const { Op } = require('sequelize');
const User = require('../models/user');

/**
 * Updates a user's streak information when they log in or perform actions
 * Uses consistent UTC-based date comparisons to avoid timezone issues
 * 
 * @param {string|number} userId - The ID of the user to update
 * @param {boolean} [forceUpdate=false] - Whether to force streak update even if already updated today
 * @returns {Promise<Object>} Updated user object
 */
const updateStreak = async (userId, forceUpdate = false) => {
  try {
    // Find the user
    const user = await User.findByPk(userId);
    if (!user) {
      throw new Error(`User not found with ID: ${userId}`);
    }

    // Get current UTC date components and create a consistent date string YYYY-MM-DD
    const now = new Date();
    const todayDate = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()));
    const todayStr = todayDate.toISOString().split('T')[0];

    // Calculate yesterday's date
    const yesterdayDate = new Date(todayDate);
    yesterdayDate.setUTCDate(yesterdayDate.getUTCDate() - 1);
    const yesterdayStr = yesterdayDate.toISOString().split('T')[0];

    // Convert user's last active date to the same format for comparison
    let lastActiveDateStr = null;
    if (user.last_active_date) {
      const lastActiveDate = new Date(user.last_active_date);
      lastActiveDateStr = new Date(
        Date.UTC(lastActiveDate.getUTCFullYear(), lastActiveDate.getUTCMonth(), lastActiveDate.getUTCDate())
      ).toISOString().split('T')[0];
    }

    // If the user has already been active today and we're not forcing an update, return early
    if (lastActiveDateStr === todayStr && !forceUpdate) {
      console.log(`User ${userId} already logged active today. No streak update needed.`);
      return user;
    }

    // Initialize streak values if this is the first activity
    if (!lastActiveDateStr) {
      console.log(`First activity for user ${userId}. Initializing streak.`);
      user.current_streak = 1;
      user.highest_streak = 1;
      user.total_active_days = 1;
    } 
    // If the user was active yesterday, increment their streak
    else if (lastActiveDateStr === yesterdayStr) {
      console.log(`User ${userId} was active yesterday. Continuing streak.`);
      user.current_streak += 1;
      // Update highest streak if current streak is higher
      if (user.current_streak > user.highest_streak) {
        user.highest_streak = user.current_streak;
      }
      user.total_active_days += 1;
    } 
    // If the user was already active today (but we're forcing an update), don't change streak
    else if (lastActiveDateStr === todayStr) {
      console.log(`User ${userId} already active today. No streak change.`);
      // No streak changes needed, but we'll still save the current date below
    } 
    // Otherwise, reset the streak (user missed at least one day)
    else {
      console.log(`User ${userId} streak broken. Last active: ${lastActiveDateStr}, Today: ${todayStr}`);
      user.current_streak = 1;
      user.total_active_days += 1;
    }

    // Always update the last active date to today
    user.last_active_date = todayStr;
    
    // Save changes to the database
    await user.save();
    
    console.log(`Updated streak for user ${userId}: Current=${user.current_streak}, Highest=${user.highest_streak}, Total Days=${user.total_active_days}`);
    return user;
  } catch (error) {
    console.error(`Error updating streak for user ${userId}:`, error);
    throw error; // Re-throw to allow the caller to handle it
  }
};

module.exports = { updateStreak };