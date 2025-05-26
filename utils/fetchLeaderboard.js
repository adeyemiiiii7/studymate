const { Op } = require('sequelize');
const User = require('../models/user');
const ClassroomStudent = require('../models/classroomStudent');

const shouldResetStreak = (lastActiveDate) => {
  if (!lastActiveDate) return true;
  
  const now = new Date();
  const todayStr = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()))
    .toISOString().split('T')[0];
  
  const lastActiveStr = new Date(lastActiveDate).toISOString().split('T')[0];
  
  // If last active date is not today or yesterday, streak should be reset
  const yesterday = new Date();
  yesterday.setUTCDate(yesterday.getUTCDate() - 1);
  const yesterdayStr = new Date(Date.UTC(yesterday.getUTCFullYear(), yesterday.getUTCMonth(), yesterday.getUTCDate()))
    .toISOString().split('T')[0];
  
  return lastActiveStr !== todayStr && lastActiveStr !== yesterdayStr;
};


 // Updates streaks for inactive users by setting current_streak to 0

const resetInactiveStreaks = async (studentIds) => {
  try {
    const users = await User.findAll({
      where: {
        user_id: { [Op.in]: studentIds },
        role: 'student'
      }
    });

    const updatePromises = users.map(async (user) => {
      if (shouldResetStreak(user.last_active_date) && user.current_streak > 0) {
        console.log(`Resetting streak for inactive user ${user.user_id}`);
        await user.update({ current_streak: 0 });
      }
    });

    await Promise.all(updatePromises);
  } catch (error) {
    console.error('Error resetting inactive streaks:', error);
  }
};

const fetchLeaderboard = async (classroomId) => {
  try {
    // First, get all student IDs in the classroom
    const classroomStudents = await ClassroomStudent.findAll({
      where: { classroom_id: classroomId },
      attributes: ['student_id']
    });

    const studentIds = classroomStudents.map(cs => cs.student_id);
    
    if (studentIds.length === 0) {
      return [];
    }

    // Reset streaks for inactive users before fetching leaderboard
    await resetInactiveStreaks(studentIds);

    // Now fetch the updated leaderboard data
    const students = await ClassroomStudent.findAll({
      where: { classroom_id: classroomId },
      include: [{
        model: User,
        as: 'student',
        attributes: [
          'user_id',
          'first_name',
          'last_name',
          'current_streak',
          'highest_streak',
          'total_active_days',
          'last_active_date'
        ],
        where: { role: 'student' }
      }],
    });

    const leaderboardData = students
      .map(student => {
        const isActive = !shouldResetStreak(student.student.last_active_date);
        
        return {
          user_id: student.student.user_id,
          name: `${student.student.first_name} ${student.student.last_name}`,
          current_streak: student.student.current_streak,
          highest_streak: student.student.highest_streak,
          total_active_days: student.student.total_active_days,
          last_active: student.student.last_active_date,
          is_active: isActive,
          days_since_active: isActive ? 0 : Math.ceil(
            (new Date() - new Date(student.student.last_active_date || 0)) / (1000 * 60 * 60 * 24)
          )
        };
      })
      .filter(student => student.total_active_days > 0) // Only show students with some activity
      .sort((a, b) => {
        // First, prioritize active users
        if (a.is_active !== b.is_active) {
          return b.is_active - a.is_active; // Active users first
        }
        
        // Among active users or inactive users, sort by performance
        if (b.highest_streak !== a.highest_streak) {
          return b.highest_streak - a.highest_streak;
        }
        if (b.current_streak !== a.current_streak) {
          return b.current_streak - a.current_streak;
        }
        if (b.total_active_days !== a.total_active_days) {
          return b.total_active_days - a.total_active_days;
        }
        
        // For inactive users, sort by how recently they were active
        if (!a.is_active && !b.is_active) {
          return a.days_since_active - b.days_since_active;
        }
        
        return new Date(b.last_active || 0) - new Date(a.last_active || 0);
      });

    return leaderboardData;
  } catch (error) {
    console.error('Error in fetchLeaderboard:', error.message);
    throw error;
  }
};

module.exports = { fetchLeaderboard };