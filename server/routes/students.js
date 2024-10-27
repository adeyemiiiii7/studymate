const express = require('express');
const Classroom = require('../models/classroom');
const ClassroomStudent = require('../models/classroomStudent');
const authorizeRole = require('../middleware/authorizeRole');
const studentRouter = express.Router();
const auth = require('../middleware/auth');

studentRouter.post('/classrooms/join', auth , authorizeRole(['student']), async (req, res) => {
  try {
    const { joinCode } = req.body;
    const studentLevel = req.user.level;
    const classroom = await Classroom.findOne({ where: { join_code: joinCode } });
    if (!classroom) {
      return res.status(404).json({ error: 'Invalid join code' });
    }
    if (studentLevel !== classroom.level) {
      return res.status(403).json({ error: 'You cannot join a classroom for a different level' });
    }
    const isStudentInClassroom = await ClassroomStudent.findOne({
      where: { student_id: req.user.user_id, classroom_id: classroom.classroom_id },
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
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Endpoint to get all classrooms the student is part of
studentRouter.get('/student/classrooms', auth, authorizeRole(['student']), async (req, res) => {
  try {
    const studentClassrooms = await ClassroomStudent.findAll({
      where: { student_id: req.user.user_id },
      include: {
        model: Classroom,
        as: 'classroom',  
        attributes: ['classroom_id', 'name','level', 'department','section_term', 'join_code', 'course_rep_id'],
      },
    });

    if (!studentClassrooms || studentClassrooms.length === 0) {
      return res.status(404).json({ message: 'You are not in any classrooms' });
    }

    res.status(200).json({
      message: 'Classrooms retrieved successfully',
      classrooms: studentClassrooms.map(sc => sc.classroom),
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

//endpoint to ger all sections in a classroom
studentRouter.get('/classroom/:classroomId/sections', auth, authorizeRole(['student']), async (req, res) => {
  try{
    const studentClassroom = await ClassroomStudent.findOne({
      where: { student_id: req.user.user_id, classroom_id: req.params.classroomId },
    });
    if (!studentClassroom) {
      return res.status(404).json({ error: 'You are not in this classroom' });
    }
    const classroomSections = await Section.findAll({
      where: { classroom_id: req.params.classroomId },
    });
    if (!classroomSections || classroomSections.length === 0) {
      return res.status(404).json({ message: 'No sections found for this classroom' });
    }
    res.status(200).json({
      message: 'Sections retrieved successfully',
      sections: classroomSections,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = studentRouter;
