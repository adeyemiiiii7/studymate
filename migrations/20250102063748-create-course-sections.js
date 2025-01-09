'use strict';
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('CourseSections', {
      course_section_id: {
        type: Sequelize.UUID,
        defaultValue: Sequelize.UUIDV4,
        primaryKey: true,
      },
      course_title: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      course_code: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      classroom_id: {
        type: Sequelize.UUID,
        references: {
          model: 'Classrooms',
          key: 'classroom_id',
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
    await queryInterface.dropTable('CourseSections');
  }
};
