const express = require('express');
const { generateJoinCode } = require('../utils/utils');
const auth = require('../middleware/auth');
const authorizeRole = require('../middleware/authorizeRole');
const Classroom = require('../models/classroom');
const courseRepRouter = express.Router();

courseRepRouter.post('/classroom/create', auth, authorizeRole(['course_rep']), async (req, res) => {
    const { name, level, department, section_term } = req.body;
    try {
      console.log('Request Body:', req.body);
      
      if (!req.user || !req.user.user_id) {
        return res.status(400).json({ error: 'User information is missing' });
      }
  
      const existingClassroom = await Classroom.findOne({
        where: {
          name,
          level,
          department,
          section_term: section_term,
          course_rep_id: req.user.user_id
        }
      });
      
      if (existingClassroom) {
        return res.status(409).json({ error: 'A classroom with this department and level already exists for this course representative' });
      }
  
      const joinCode = generateJoinCode();
  
      const classroom = await Classroom.create({
        name,
        level,
        department,
        section_term: section_term,
        join_code: joinCode,
        course_rep_id: req.user.user_id
      });
      res.status(201).json({
        message: 'Classroom created successfully',
        classroom
      });
    } catch (error) {
      console.error('Error Creating Classroom:', error);
      res.status(500).json({ error: 'An error occurred while creating the classroom' });
    }
  });
  

// Create course sections in a classroom
courseRepRouter.post('/classroom/:classroomId/section/create', auth, authorizeRole(['course_rep']), async (req, res) => {
  const { classroomId } = req.params;
  const { courseTitle, courseCode, sectionTitle } = req.body;

  try {
    const classroom = await Classroom.findOne({
      where: {
        classroom_id: classroomId,
        course_rep_id: req.user.user_id, 
      },
    });
    if (!classroom) {
      return res.status(404).json({ error: 'Classroom not found or you are not the course rep' });
    }
    const section = await Section.create({
      course_title: courseTitle,
      course_code: courseCode,
      section_title: sectionTitle,
      classroom_id: classroomId, 
    });
    res.status(201).json({
      message: 'Section created successfully',
      section,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while creating the section' });
  }
});

module.exports = courseRepRouter;
