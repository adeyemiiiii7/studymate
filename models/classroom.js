const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Classroom = sequelize.define('Classroom', {
  classroom_id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  level: {
    type: DataTypes.INTEGER,
    allowNull: false,
    validate: {
      min: 100,
      max: 800,
    },
  },
  department: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  course_name: {  // Added course_name field
    type: DataTypes.STRING,
    allowNull: false,
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  join_code: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
  },
  session: { 
    type: DataTypes.STRING,
    allowNull: false,
  },
  course_rep_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  is_active: {  // Added is_active field
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: true,
  }
}, {
  indexes: [
    {
      unique: true,
      fields: ['course_rep_id', 'level', 'department', 'course_name'], 
    },
  ],
});

module.exports = Classroom;
