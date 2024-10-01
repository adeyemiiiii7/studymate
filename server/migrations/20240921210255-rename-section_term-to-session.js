'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.renameColumn('Classrooms', 'section_term', 'session');
  },
  down: async (queryInterface, Sequelize) => {
    await queryInterface.renameColumn('Classrooms', 'session', 'section_term');
  }
};
