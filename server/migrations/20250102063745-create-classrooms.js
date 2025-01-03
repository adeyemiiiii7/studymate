'use strict';
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('classrooms', {
      classroom_id: {
        type: Sequelize.UUID,
        defaultValue: Sequelize.UUIDV4,
        primaryKey: true,
      },
      level: {
        type: Sequelize.INTEGER,
        allowNull: false,
        validate: {
          min: 100,
          max: 800,
        },
      },
      department: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      name: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      join_code: {
        type: Sequelize.STRING,
        allowNull: false,
        unique: true,
      },
      session: { 
        type: Sequelize.STRING,
        allowNull: false,
      },
      course_rep_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
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
    await queryInterface.dropTable('classrooms');
  }
};
