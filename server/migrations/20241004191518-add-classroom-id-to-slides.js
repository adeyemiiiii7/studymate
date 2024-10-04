'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.addColumn('Slides', 'classroom_id', {
      type: Sequelize.INTEGER,
      allowNull: false,
      references: {
        model: 'Classrooms',
        key: 'classroom_id',
      },
      onUpdate: 'CASCADE',
      onDelete: 'CASCADE'
    });

    // Populate the new column with data
    await queryInterface.sequelize.query(`
      UPDATE "Slides"
      SET classroom_id = (
        SELECT cs.classroom_id
        FROM "CourseSections" cs
        WHERE cs.course_section_id = "Slides".course_section_id
      )
    `);
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.removeColumn('Slides', 'classroom_id');
  }
};