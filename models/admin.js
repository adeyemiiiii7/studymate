const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');
const bcryptjs = require('bcryptjs');

const Admin = sequelize.define('Admin', {
  admin_id: {
    type: DataTypes.UUID,
    primaryKey: true,
    defaultValue: DataTypes.UUIDV4,
  },
  username: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  is_super_admin: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  }
}, {
  tableName: 'Admins',
  timestamps: true,
  hooks: {
    beforeCreate: async (admin) => {
      if (admin.password) {
        admin.password = await bcryptjs.hash(admin.password, 10);
      }
    }
  }
});

module.exports = Admin;