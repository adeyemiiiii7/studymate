const setupAssociations = () => {
   const User = require('../models/user');
   const Classroom = require('../models/classroom');
   const ClassroomStudent = require('../models/classroomStudent');
   const CourseSection = require('../models/courseSection');
   const Slide = require('../models/slides');
   const Question = require('../models/question');
   const Announcement = require('../models/announcements');
   const PastQuestion = require('../models/pastQuestions');
   const UserCourse = require('../models/userCourse');
   const SlideQuestionAttempt = require('../models/slideQuestionAttempt');
 
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
     as: 'enrolledStudents'
   });
 
   // ClassroomStudent associations
   ClassroomStudent.belongsTo(User, { foreignKey: 'student_id', as: 'student' });
   ClassroomStudent.belongsTo(Classroom, { foreignKey: 'classroom_id', as: 'classroom' });
 
   // Course Rep managing multiple Classrooms
   User.hasMany(Classroom, { foreignKey: 'course_rep_id', as: 'managedClassrooms' });
   Classroom.belongsTo(User, { foreignKey: 'course_rep_id', as: 'courseRep' });
 
   // Classroom and Course Sections with Cascade
   Classroom.hasMany(CourseSection, { as: 'courseSections', foreignKey: 'classroom_id', onDelete: 'CASCADE' });
   CourseSection.belongsTo(Classroom, { as: 'classroomDetail', foreignKey: 'classroom_id' });
 
   // Classroom and Slides with Cascade
   Classroom.hasMany(Slide, {
     as: 'classroomSlides',
     foreignKey: 'classroom_id',
     onDelete: 'CASCADE'
   });
   Slide.belongsTo(Classroom, {
     as: 'classroomDetail',
     foreignKey: 'classroom_id'
   });
 
   // Classroom and Announcements with Cascade
   Classroom.hasMany(Announcement, {
     as: 'classroomAnnouncements',
     foreignKey: 'classroom_id',
     onDelete: 'CASCADE'
   });
   Announcement.belongsTo(Classroom, {
     as: 'classroomDetail',
     foreignKey: 'classroom_id'
   });
 
   // Classroom and Classroom Students with Cascade
   Classroom.hasMany(ClassroomStudent, {
     as: 'classroomStudents',
     foreignKey: 'classroom_id',
     onDelete: 'CASCADE'
   });
 
   // Course Section and Slides with Cascade
   CourseSection.hasMany(Slide, {
     as: 'courseSectionSlides',
     foreignKey: 'course_section_id',
     onDelete: 'CASCADE'
   });
   Slide.belongsTo(CourseSection, {
     as: 'courseSectionDetail',
     foreignKey: 'course_section_id'
   });
 
   // Course Section and Questions with Cascade
   CourseSection.hasMany(Question, {
     as: 'courseSectionQuestions',
     foreignKey: 'course_section_id',
     onDelete: 'CASCADE'
   });
   Question.belongsTo(CourseSection, {
     as: 'courseSectionDetail',
     foreignKey: 'course_section_id'
   });
 
   // User <-> UserCourse association
   User.hasMany(UserCourse, { foreignKey: 'user_id', as: 'courses' });
   UserCourse.belongsTo(User, { foreignKey: 'user_id', as: 'user' });
 
   // Course Section and Past Questions with Cascade
   CourseSection.hasMany(PastQuestion, {
     as: 'courseSectionPastQuestions',
     foreignKey: 'course_section_id',
     onDelete: 'CASCADE'
   });
   PastQuestion.belongsTo(CourseSection, {
     as: 'courseSectionDetail',
     foreignKey: 'course_section_id'
   });
   
   // SlideQuestionAttempt associations
   SlideQuestionAttempt.belongsTo(User, { foreignKey: 'user_id', as: 'user' });
   SlideQuestionAttempt.belongsTo(Slide, { foreignKey: 'slide_id', as: 'slide' });
   SlideQuestionAttempt.belongsTo(Classroom, { foreignKey: 'classroom_id', as: 'classroom' });
   SlideQuestionAttempt.belongsTo(CourseSection, { foreignKey: 'course_section_id', as: 'courseSection' });
   
   // User has many SlideQuestionAttempts
   User.hasMany(SlideQuestionAttempt, { foreignKey: 'user_id', as: 'questionAttempts' });
   
   // Slide has many SlideQuestionAttempts
   Slide.hasMany(SlideQuestionAttempt, { foreignKey: 'slide_id', as: 'attempts' });
 };
 
 module.exports = { setupAssociations };