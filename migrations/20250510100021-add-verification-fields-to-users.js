'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('Users', 'verification_code', {
      type: Sequelize.STRING(5),
      allowNull: true,
    });
    
    await queryInterface.addColumn('Users', 'is_verified', {
      type: Sequelize.BOOLEAN,
      defaultValue: false,
      allowNull: false,
    });
    
    await queryInterface.addColumn('Users', 'verification_code_expires_at', {
      type: Sequelize.DATE,
      allowNull: true,
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn('Users', 'verification_code');
    await queryInterface.removeColumn('Users', 'is_verified');
    await queryInterface.removeColumn('Users', 'verification_code_expires_at');
  }
};
