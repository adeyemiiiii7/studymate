const express = require('express');
const { generateJoinCode } = require('../utils/utils');
const auth = require('../middleware/auth');
const authorizeRole = require('../middleware/authorizeRole');
const Classroom = require('../models/classroom');
const CourseSection = require('../models/courseSection'); 
const courseRepRouter = express.Router();
const nodemailer = require('nodemailer');
const Slide = require('../models/slides');
const upload = require('../middleware/upload');

// Route for creating a classroom
courseRepRouter.post('/classroom/create', auth, authorizeRole(['course_rep']), async (req, res) => {
  const { name, level, department, session, email } = req.body;
  try {
    console.log('Request Body:', req.body);

    if (!req.user || !req.user.user_id) {
      return res.status(400).json({ error: 'User information is missing' });
    }
      // Fetch the course rep's email from the logged-in user's data
    const courseRepEmail = req.user.email;
    const existingClassroom = await Classroom.findOne({
      where: {
        name,
        level,
        department,
        session,
        course_rep_id: req.user.user_id,
      },
    });

    if (existingClassroom) {
      return res.status(409).json({ error: 'A classroom with this department and level already exists for this course representative' });
    }
    const joinCode = generateJoinCode();
    const classroom = await Classroom.create({
      name,
      level,
      department,
      session,
      join_code: joinCode,
      course_rep_id: req.user.user_id,
    });
    // Send the join code to the course rep's email using Nodemailer
    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: 'aladesuyiadeyemi05@gmail.com',
        pass: 'qtpc ezqc uoyu jvst'
      }
    });
    const mailOptions = {
      from: 'Classroom Management <aladesuyiadeyemi05@gmail.com>',
      to: courseRepEmail,
      subject: 'Classroom Join Code',
      html: `<p>Your classroom "${name}" has been created successfully. The join code is: <strong>${joinCode}</strong></p>`
    };
    transporter.sendMail(mailOptions, function (error, info) {
      if (error) {
        console.error('Error sending email:', error);
      } else {
        console.log('Email sent: ' + info.response);
      }
    });
    res.status(201).json({
      message: 'Classroom created successfully',
      classroom,
    });
  } catch (error) {
    console.error('Error Creating Classroom:', error);
    res.status(500).json({ error: 'An error occurred while creating the classroom' });
  }
});

// Route for creating a course section inside a classroom
courseRepRouter.post('/classroom/:classroomId/course-section/create', auth, authorizeRole(['course_rep']), async (req, res) => {
  const { classroomId } = req.params;
  const { courseTitle, courseCode,  } = req.body;

  try {
    // Check if the classroom exists and belongs to the course rep
    const classroom = await Classroom.findOne({
      where: {
        classroom_id: classroomId,
        course_rep_id: req.user.user_id,
      },
    });

    if (!classroom) {
      return res.status(404).json({ error: 'Classroom not found or you are not the course rep' });
    }
    const section = await CourseSection.create({
      course_title: courseTitle,
      course_code: courseCode,
      classroom_id: classroomId,
    });
    res.status(201).json({
      message: 'Section created successfully',
      section,
    });
  } catch (error) {
    console.error('Error Creating Section:', error);
    res.status(500).json({ error: 'An error occurred while creating the section' });
  }
});

courseRepRouter.get('/classrooms', auth, authorizeRole(['course_rep']), async (req, res) => {
  try {
    // Fetch all classrooms managed by the logged-in course rep
    const classrooms = await Classroom.findAll({
      where: { course_rep_id: req.user.user_id },
      include: {
        model: CourseSection,
        as: 'courseSections', 
        attributes: ['course_section_id', 'course_title', 'course_code'],
      }         
    });
    res.status(200).json({
      message: 'Classrooms fetched successfully',
      classrooms,
    });
  } catch (error) {
    console.error('Error Fetching Classrooms:', error);
    res.status(500).json({ error: 'An error occurred while fetching classrooms' });
  }
});

// Fetch sections under a specific classroom
courseRepRouter.get('/classroom/:classroomId/sections', auth, authorizeRole(['course_rep']), async (req, res) => {
  const { classroomId } = req.params;

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

    const sections = await CourseSection.findAll({
      where: { classroom_id: classroomId },
      attributes: ['course_section_id', 'course_title', 'course_code'],
    });

    res.status(200).json({
      message: 'Sections fetched successfully',
      sections,
    });
  } catch (error) {
    console.error('Error Fetching Sections:', error);
    res.status(500).json({ error: 'An error occurred while fetching sections' });
  }
});

courseRepRouter.post('/classroom/:classroomId/course-section/:courseSectionId/uploadSlide', auth, authorizeRole(['course_rep']), upload.single('file'), async (req, res) => {
  try {
    const { classroomId, courseSectionId } = req.params;
    const { slide_name, slide_number } = req.body; // Accept slide_number from the request body
    const file_url = req.file.path;

    const courseSection = await CourseSection.findOne({
      where: {
        course_section_id: courseSectionId,
        classroom_id: classroomId, 
      },
    });

    // Check if courseSection exists
    if (!courseSection) {
      return res.status(400).json({ error: 'Course section not found' });
    }

    // Validate slide_number
    if (!slide_number || isNaN(slide_number)) {
      return res.status(400).json({ error: 'Invalid slide number. Please provide a valid number.' });
    }
    // Check if the slide_number is already used in the same course section
    const existingSlide = await Slide.findOne({
      where: {
        course_section_id: courseSection.course_section_id,
        slide_number: slide_number
      },
    });
    if (existingSlide) {
      return res.status(400).json({ error: 'Slide number already exists in this course section. Please use a different number.' });
    }
    const newSlide = await Slide.create({
      slide_name,
      file_name: req.file.originalname,
      file_url,
      slide_number: parseInt(slide_number),
      course_section_id: courseSection.course_section_id
    });

    res.json({ message: 'Slide uploaded successfully', slide: newSlide });
  } catch (error) {
    console.error('Error uploading slide:', error);
    res.status(500).json({ error: 'Failed to upload slide' });
  }
});



module.exports = courseRepRouter;
