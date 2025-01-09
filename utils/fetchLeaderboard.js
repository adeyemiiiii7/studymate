const { Op } = require('sequelize');
const User = require('../models/user');
const ClassroomStudent = require('../models/classroomStudent');

const fetchLeaderboard = async (classroomId) => {
  try {
    const students = await ClassroomStudent.findAll({
      where: { classroom_id: classroomId },
      include: [{
        model: User,
        as: 'student',
        attributes: [
          'user_id',  // Changed from 'id' to 'user_id' to match User model
          'first_name',
          'last_name',
          'current_streak',
          'highest_streak',
          'total_active_days'
        ],
        where: { role: 'student' }
      }],
    });

    // Map the data with correct property references
    const leaderboardData = students
      .map(student => ({
        user_id: student.student.user_id,  // Changed from id to user_id
        name: `${student.student.first_name} ${student.student.last_name}`,
        current_streak: student.student.current_streak,
        highest_streak: student.student.highest_streak,
        total_active_days: student.student.total_active_days
      }))
      .sort((a, b) => {
        if (b.highest_streak !== a.highest_streak) return b.highest_streak - a.highest_streak;
        if (b.current_streak !== a.current_streak) return b.current_streak - a.current_streak;
        return b.total_active_days - a.total_active_days;
      });

    return leaderboardData;
  } catch (error) {
    console.error('Error in fetchLeaderboard:', error.message);
    throw error;
  }
};

module.exports = { fetchLeaderboard };
