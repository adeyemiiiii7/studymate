'use strict';
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('PastQuestions', {
      past_question_id: {
        type: Sequelize.UUID,
        defaultValue: Sequelize.UUIDV4,
        primaryKey: true,
      },
      past_question_name: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      course_section_id: {
        type: Sequelize.UUID,
        references: {
          model: 'CourseSections',
          key: 'course_section_id',
        },
        allowNull: false,
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE',
      },
      file_names: {
        type: Sequelize.ARRAY(Sequelize.STRING),
        allowNull: false,
      },
      file_urls: {
        type: Sequelize.ARRAY(Sequelize.STRING),
        allowNull: false,
      },
      classroom_id: {
        type: Sequelize.UUID,
        references: {
          model: 'Classrooms',
          key: 'classroom_id',
        },
        allowNull: false,
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE',
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
    await queryInterface.dropTable('PastQuestions');
  }
};
