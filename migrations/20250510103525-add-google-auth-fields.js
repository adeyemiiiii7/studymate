'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('Users', 'google_id', {
      type: Sequelize.STRING,
      allowNull: true,
      unique: true
    });
    
    await queryInterface.addColumn('Users', 'google_email', {
      type: Sequelize.STRING,
      allowNull: true,
      unique: true
    });
    
    await queryInterface.addColumn('Users', 'google_picture', {
      type: Sequelize.STRING,
      allowNull: true
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn('Users', 'google_id');
    await queryInterface.removeColumn('Users', 'google_email');
    await queryInterface.removeColumn('Users', 'google_picture');
  }
};
