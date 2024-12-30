const express = require('express');
const Classroom = require('../models/classroom');
const ClassroomStudent = require('../models/classroomStudent');
const authorizeRole = require('../middleware/authorizeRole');
const studentRouter = express.Router();
const auth = require('../middleware/auth');
const CourseSection = require('../models/courseSection');
const Slide = require('../models/slides');
const PastQuestion = require('../models/pastQuestions');
const Announcement = require('../models/announcements');
const User = require('../models/user');
const { where } = require('sequelize');
const courseRepRouter = require('./courseRep');


studentRouter.get('/api/student/profile', auth, authorizeRole(['student']), async (req, res) => {
  try {
    const user = await User.findOne({
    where: { 
      user_id: req.user.user_id,
      role: 'student'
    },
    attributes: 
    ['first_name', 'last_name', 'email', 'level', 'xp', 'current_streak', 'highest_streak', 'total_active_days', 'role','daily_quest_status'

    ]
  });
  if (!user) {
    return res.status(404).json({ error: 'Student profile not found' });
  }
  res.status(200).json({
    message: 'Student profile retrieved successfully',
    user
  });
} catch (error) {
  console.error('Error fetching student profile:', error);
  res.status(500).json({ error: 'Internal server error' });
}
});

studentRouter.put('/api/student/profile/update', auth, authorizeRole(['student']), async (req, res) => {
  try {
    const { first_name, last_name, level } = req.body;

    await User.update(
     { first_name, last_name, level },
     { where: { user_id: req.user.user_id, role: 'student' } }
    );

    res.status(200).json({
       message: 'Profile updated successfully' 
      });

  } catch (error) {
    console.error('Error updating student profile:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});



// Join a classroom
studentRouter.post('/api/student/classrooms/join', auth, authorizeRole(['student']), async (req, res) => {
  try {
    const { joinCode } = req.body;
    const studentLevel = req.user.level;
    
    const classroom = await Classroom.findOne({ 
      where: { join_code: joinCode } 
    });

    if (!classroom) {
      return res.status(404).json({ error: 'Invalid join code' });
    }

    if (studentLevel !== classroom.level) {
      return res.status(403).json({ error: 'You cannot join a classroom for a different level' });
    }

    const isStudentInClassroom = await ClassroomStudent.findOne({
      where: { 
        student_id: req.user.user_id, 
        classroom_id: classroom.classroom_id 
      },
    });

    if (isStudentInClassroom) {
      return res.status(400).json({ error: 'You are already in this classroom' });
    }

    await ClassroomStudent.create({
      student_id: req.user.user_id,
      classroom_id: classroom.classroom_id,
    });

    res.status(200).json({ message: 'Joined classroom successfully' });
  } catch (error) {
    console.error('Error joining classroom:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get all classrooms the student is enrolled in
studentRouter.get('/api/student/classrooms', auth, authorizeRole(['student']), async (req, res) => {
  try {
    const studentClassrooms = await ClassroomStudent.findAll({
      where: { student_id: req.user.user_id },
      include: [{
        model: Classroom,
        include: [{
          model: CourseSection,
          as: 'courseSections',
          attributes: ['course_section_id', 'course_title', 'course_code']
        }]
      }]
    });

    res.status(200).json({
      message: 'Classrooms retrieved successfully',
      classrooms: studentClassrooms.map(sc => sc.Classroom)
    });
  } catch (error) {
    console.error('Error fetching classrooms:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get course sections in a classroom
studentRouter.get('/api/student/classrooms/:classroomId/sections', auth, authorizeRole(['student']), async (req, res) => {
  try {
    const studentClassroom = await ClassroomStudent.findOne({
      where: { 
        student_id: req.user.user_id, 
        classroom_id: req.params.classroomId 
      }
    });

    if (!studentClassroom) {
      return res.status(404).json({ error: 'You are not enrolled in this classroom' });
    }

    const sections = await CourseSection.findAll({
      where: { classroom_id: req.params.classroomId }
    });

    res.status(200).json({
      message: 'Sections retrieved successfully',
      sections
    });
  } catch (error) {
    console.error('Error fetching sections:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get slides in a course section
studentRouter.get('/api/student/classrooms/:classroomId/sections/:sectionId/slides', 
  auth, authorizeRole(['student']), async (req, res) => {
  try {
    const studentClassroom = await ClassroomStudent.findOne({
      where: { 
        student_id: req.user.user_id, 
        classroom_id: req.params.classroomId 
      }
    });

    if (!studentClassroom) {
      return res.status(404).json({ error: 'You are not enrolled in this classroom' });
    }

    const slides = await Slide.findAll({
      where: { 
        classroom_id: req.params.classroomId,
        course_section_id: req.params.sectionId
      }
    });

    res.status(200).json({
      message: 'Slides retrieved successfully',
      slides
    });
  } catch (error) {
    console.error('Error fetching slides:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get past questions in a course section
studentRouter.get('/api/student/classrooms/:classroomId/sections/:sectionId/past-questions', 
  auth, authorizeRole(['student']), async (req, res) => {
  try {
    const studentClassroom = await ClassroomStudent.findOne({
      where: { 
        student_id: req.user.user_id, 
        classroom_id: req.params.classroomId 
      }
    });

    if (!studentClassroom) {
      return res.status(404).json({ error: 'You are not enrolled in this classroom' });
    }

    const pastQuestions = await PastQuestion.findAll({
      where: { 
        classroom_id: req.params.classroomId,
        course_section_id: req.params.sectionId
      }
    });

    res.status(200).json({
      message: 'Past questions retrieved successfully',
      pastQuestions
    });
  } catch (error) {
    console.error('Error fetching past questions:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get announcements for a classroom
studentRouter.get('/api/student/classrooms/:classroomId/announcements', 
  auth, authorizeRole(['student']), async (req, res) => {
  try {
    const studentClassroom = await ClassroomStudent.findOne({
      where: { 
        student_id: req.user.user_id, 
        classroom_id: req.params.classroomId 
      }
    });

    if (!studentClassroom) {
      return res.status(404).json({ error: 'You are not enrolled in this classroom' });
    }

    const announcements = await Announcement.findAll({
      where: { classroom_id: req.params.classroomId },
      order: [['date', 'DESC']]
    });

    res.status(200).json({
      message: 'Announcements retrieved successfully',
      announcements
    });
  } catch (error) {
    console.error('Error fetching announcements:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});
 
module.exports = studentRouter;
