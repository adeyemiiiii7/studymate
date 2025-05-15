'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    try {
      // First, remove the course_name from the composite index
      await queryInterface.removeIndex(
        'Classrooms',
        'classrooms_course_rep_id_level_department_course_of_study_course_name'
      );
    } catch (error) {
      console.log('Index removal failed, may not exist:', error.message);
    }

    try {
      // Create a new index without course_name, only if it doesn't exist
      await queryInterface.addIndex(
        'Classrooms',
        ['course_rep_id', 'level', 'department', 'course_of_study'],
        {
          name: 'classrooms_course_rep_id_level_department_course_of_study',
          unique: true
        }
      );
    } catch (error) {
      console.log('Index creation skipped, may already exist:', error.message);
    }

    // Check if the column exists before trying to remove it
    const tableInfo = await queryInterface.describeTable('Classrooms');
    if (tableInfo.course_name) {
      await queryInterface.removeColumn('Classrooms', 'course_name');
    }
  },

  down: async (queryInterface, Sequelize) => {
    // Check if the column exists before trying to add it
    const tableInfo = await queryInterface.describeTable('Classrooms');
    if (!tableInfo.course_name) {
      // Add the course_name column back
      await queryInterface.addColumn('Classrooms', 'course_name', {
        type: Sequelize.STRING,
        allowNull: true // Make it nullable for restoration
      });
    }

    try {
      // Remove the index without course_name
      await queryInterface.removeIndex(
        'Classrooms',
        'classrooms_course_rep_id_level_department_course_of_study'
      );
    } catch (error) {
      console.log('Index removal in down migration failed:', error.message);
    }

    try {
      // Recreate the original index with course_name
      await queryInterface.addIndex(
        'Classrooms',
        ['course_rep_id', 'level', 'department', 'course_of_study', 'course_name'],
        {
          name: 'classrooms_course_rep_id_level_department_course_of_study_course_name',
          unique: true
        }
      );
    } catch (error) {
      console.log('Index creation in down migration failed:', error.message);
    }
  }
}; 