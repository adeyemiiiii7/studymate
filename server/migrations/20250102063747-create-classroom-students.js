'use strict';
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('ClassroomStudents', {
      student_id: {
        type: Sequelize.INTEGER,
        references: {
          model: 'Users', 
          key: 'user_id'
        },
        allowNull: false,
      },
      classroom_id: {
        type: Sequelize.UUID,
        references: {
          model: 'Classrooms', 
          key: 'classroom_id'
        },
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
    await queryInterface.dropTable('ClassroomStudents');
  }
};
