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
  course_of_study: {
    type: DataTypes.STRING,
    allowNull: true,
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
  is_active: { 
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: true,
  }
}, {
  indexes: [
    {
      unique: true,
      name: 'classrooms_course_rep_id_level_department_course_of_study',
      fields: ['course_rep_id', 'level', 'department', 'course_of_study'], 
    },
  ],
  charset: 'utf8',
  collate: 'utf8_general_ci',
});

module.exports = Classroom;
