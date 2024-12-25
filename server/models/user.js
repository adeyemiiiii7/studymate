const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const User = sequelize.define('User', {
  user_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  first_name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  last_name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
  },
  role: {
    type: DataTypes.ENUM('student', 'course_rep'),
    allowNull: false,
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  level: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  last_active_date: {
    type: DataTypes.DATEONLY,
    allowNull: true,
  },
  current_streak: {
    type: DataTypes.INTEGER,
    allowNull: false,
    defaultValue: 0,
  },
  highest_streak: {
    type: DataTypes.INTEGER,
    allowNull: false,
    defaultValue: 0,
  },
  total_active_days: {
    type: DataTypes.INTEGER,
    allowNull: false,
    defaultValue: 0,
  },
  xp: {
    type: DataTypes.INTEGER,
    defaultValue: 0,
  },
  daily_quest_status: {
    type: DataTypes.JSONB,
    defaultValue: {
      completeQuiz: false,
      studySession: false,
      readSlides: false,
      followSchedule: false, 
      learnSkill: false,
      codingPractice: false
    },
  },
  last_quest_reset: {
    type: DataTypes.DATEONLY,
    allowNull: true
  }
},{
  tableName: 'Users',
  timestamps: true,
});

module.exports = User;