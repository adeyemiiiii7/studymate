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
      defaultValue: 0, // Store the XP points here
    },
    daily_quests: {
      type: DataTypes.JSONB,
      allowNull: true,
      defaultValue: {
        quest1: false,
        quest2: false,
        quest3: false,
        quest4: false,
        quest5: false,
        quest6: false,
      }, // To track daily quest completion status
    }
  }, {
    tableName: 'Users',
    timestamps: true,
  });
  module.exports = User;