// In config/associations.js

const User = require('../models/user');
const Classroom = require('../models/classroom');
const ClassroomStudent = require('../models/classroomStudent');

function setupAssociations() {
  // User and Classroom associations through ClassroomStudent
  User.belongsToMany(Classroom, { 
    through: ClassroomStudent, 
    foreignKey: 'student_id', 
    otherKey: 'classroom_id',
    as: 'classrooms' 
  });
  Classroom.belongsToMany(User, { 
    through: ClassroomStudent, 
    foreignKey: 'classroom_id', 
    otherKey: 'student_id',
    as: 'students' 
  });


  ClassroomStudent.belongsTo(User, { foreignKey: 'student_id', as: 'student' });
  ClassroomStudent.belongsTo(Classroom, { foreignKey: 'classroom_id', as: 'classroom' });
  
  User.hasMany(Classroom, { foreignKey: 'course_rep_id', as: 'managed_classrooms' });
  Classroom.belongsTo(User, { foreignKey: 'course_rep_id', as: 'course_rep' });
}

module.exports = setupAssociations;
