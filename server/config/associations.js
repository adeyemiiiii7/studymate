const User = require('../models/user');
const Classroom = require('../models/classroom');
const ClassroomStudent = require('../models/classroomStudent');
const CourseSection = require('../models/courseSection');
const Slide = require('../models/slides'); 

function setupAssociations() {
  // Many-to-Many: User <-> Classroom (via ClassroomStudent)
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
    as: 'students' // Alias for accessing students in a classroom
  });

  // Defining ClassroomStudent associations for clarity
  ClassroomStudent.belongsTo(User, { foreignKey: 'student_id', as: 'student' });
  ClassroomStudent.belongsTo(Classroom, { foreignKey: 'classroom_id', as: 'classroom' });

  // One-to-Many: Course Rep managing multiple Classrooms
  User.hasMany(Classroom, { foreignKey: 'course_rep_id', as: 'managed_classrooms' });
  Classroom.belongsTo(User, { foreignKey: 'course_rep_id', as: 'course_rep' });

  // One-to-Many: Classroom containing multiple Course Sections
  Classroom.hasMany(CourseSection, { as: 'courseSections', foreignKey: 'classroom_id' });
  CourseSection.belongsTo(Classroom, { foreignKey: 'classroom_id', as: 'classroom' });

  // One-to-Many: Course Section containing multiple Slides
  CourseSection.hasMany(Slide, { foreignKey: 'course_section_id', as: 'slides' });
  Slide.belongsTo(CourseSection, { foreignKey: 'course_section_id', as: 'courseSection' });
}

module.exports = setupAssociations;
