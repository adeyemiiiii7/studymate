const { User } = require('../models/user');
const { Op } = require('sequelize');

async function populateStreakFields() {
  try {
    const users = await User.findAll({
      where: {
        [Op.or]: [
          { last_active_date: null },
          { current_streak: 0 },
          { highest_streak: 0 },
          { total_active_days: 0 }
        ]
      }
    });

    const today = new Date().toISOString().split('T')[0];

    for (const user of users) {
      user.last_active_date = today;
      user.current_streak = 1;
      user.highest_streak = 1;
      user.total_active_days = 1;
      await user.save();
    }

    console.log(`Updated ${users.length} users with initial streak data.`);
  } catch (error) {
    console.error('Error populating streak fields:', error);
  }
}

populateStreakFields();