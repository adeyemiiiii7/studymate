'use strict';
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('Users', {
      user_id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
      first_name: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      last_name: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      email: {
        type: Sequelize.STRING,
        allowNull: false,
        unique: true,
      },
      role: {
        type: Sequelize.ENUM('student', 'course_rep'),
        allowNull: false,
      },
      password: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      level: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },
      last_active_date: {
        type: Sequelize.DATEONLY,
        allowNull: true,
      },
      current_streak: {
        type: Sequelize.INTEGER,
        allowNull: false,
        defaultValue: 0,
      },
      highest_streak: {
        type: Sequelize.INTEGER,
        allowNull: false,
        defaultValue: 0,
      },
      total_active_days: {
        type: Sequelize.INTEGER,
        allowNull: false,
        defaultValue: 0,
      },
      xp: {
        type: Sequelize.INTEGER,
        defaultValue: 0,
      },
      daily_quest_status: {
        type: Sequelize.JSONB,
        defaultValue: {
          completeQuiz: false,
          studySession: false,
          readSlides: false,
          followSchedule: false,
          learnSkill: false,
          codingPractice: false,
          personalQuests: {}
        },
      },
      hidden_quests: {
        type: Sequelize.ARRAY(Sequelize.STRING),
        defaultValue: [],
        allowNull: false,
      },
      last_quest_reset: {
        type: Sequelize.DATEONLY,
        allowNull: true
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE,
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE,
      },
    });
  },
  down: async (queryInterface, Sequelize) => {
    await queryInterface.dropTable('Users');
  }
};
