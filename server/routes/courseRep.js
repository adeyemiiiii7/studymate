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
const PastQuestion = require('../models/pastQuestions');
const Announcement = require('../models/announcements');
// const Leaderboard = require('../models/leaderboard');
const User = require('../models/user');
const {fetchLeaderboard} = require('../utils/fetchLeaderboard');
const ClassroomStudent = require('../models/classroomStudent');


courseRepRouter.get('/api/course-rep/profile', auth, authorizeRole(['course_rep']), async (req, res) => {
  try {
    const user = await User.findOne({
      where: { 
        user_id: req.user.user_id,
        role: 'course_rep'
      },
      attributes: [
        'user_id',
        'first_name', 
        'last_name',
        'email',
        'level',
        'role',
        'current_streak',
        'highest_streak',
        'total_active_days',
        'xp'
      ]
    });

    if (!user) {
      return res.status(404).json({ error: 'Course representative not found' });
    }

    res.status(200).json({
      message: 'Profile fetched successfully',
      user
    });
  } catch (error) {
    console.error('Error fetching profile:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

courseRepRouter.put('/api/course-rep/profile/update', auth, authorizeRole(['course_rep']), async (req, res) => {
  try {
    const { first_name, last_name } = req.body;

    await User.update(
      { first_name, last_name },
      { where: { user_id: req.user.user_id, role: 'course_rep' } }
    );

    res.status(200).json({
      message: 'Profile updated successfully'
    });
  } catch (error) {
    console.error('Error updating profile:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});
// Route for creating a classroom
courseRepRouter.post('/api/course-rep/classrooms/create', auth, authorizeRole(['course_rep']), async (req, res) => {
  const { name, level, department, session } = req.body;
  try {
    console.log('Request Body:', req.body);

    if (!req.user || !req.user.user_id) {
      return res.status(400).json({ error: 'User information is missing' });
    }

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
courseRepRouter.post('/api/course-rep/classrooms/:classroomId/course-sections/create',
   auth, authorizeRole(['course_rep']), async (req, res) => {
  const { classroomId } = req.params;
  const { courseTitle, courseCode } = req.body;

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

// Route to get all classrooms managed by the course rep
courseRepRouter.get('/api/course-rep/classrooms', 
  auth, authorizeRole(['course_rep']), async (req, res) => {
  try {
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
// Route to get a specific classroom details
courseRepRouter.get('/api/course-rep/classrooms/:classroomId', 
  auth, 
  authorizeRole(['course_rep']), 
  async (req, res) => {
    const { classroomId } = req.params;

    try {
      const classroom = await Classroom.findOne({
        where: {
          classroom_id: classroomId,
          course_rep_id: req.user.user_id
        },
        attributes: ['classroom_id', 'name', 'level', 'department', 'session']
      });

      if (!classroom) {
        return res.status(404).json({ 
          error: 'Classroom not found or you do not have permission to access it' 
        });
      }

      res.status(200).json({
        message: 'Classroom fetched successfully',
        classroom
      });
    } catch (error) {
      console.error('Error fetching classroom:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
});
// Route to fetch sections under a specific classroom
courseRepRouter.get('/api/course-rep/classrooms/:classroomId/sections', 
  auth, authorizeRole(['course_rep']), async (req, res) => {
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

// Route to upload a slide to a course section
courseRepRouter.post('/api/course-rep/classrooms/:classroomId/course-sections/:courseSectionId/slides/upload', 
  auth, authorizeRole(['course_rep']), upload.single('file'), async (req, res) => {
  try {
    const { classroomId, courseSectionId } = req.params;
    const { slide_name, slide_number } = req.body;
    const file_url = req.file.path;

    const courseSection = await CourseSection.findOne({
      where: {
        course_section_id: courseSectionId,
        classroom_id: classroomId,
      },
    });

    if (!courseSection) {
      return res.status(400).json({ error: 'Course section not found' });
    }

    if (!slide_number || isNaN(slide_number)) {
      return res.status(400).json({ error: 'Invalid slide number. Please provide a valid number.' });
    }

    const existingSlide = await Slide.findOne({
      where: {
        course_section_id: courseSection.course_section_id,
        slide_number: slide_number,
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
      course_section_id: courseSection.course_section_id,
      classroom_id: classroomId,
    });

    res.json({ message: 'Slide uploaded successfully', slide: newSlide });
  } catch (error) {
    console.error('Error uploading slide:', error);
    res.status(500).json({ error: 'Failed to upload slide' });
  }
});

//Fetch Slides by Sections
courseRepRouter.get('/api/course-rep/classrooms/:classroomId/course-sections/:courseSectionId/slides', 
  auth, authorizeRole(['course_rep']), async (req, res) => {
  const { classroomId, courseSectionId } = req.params;
  try {
    const slides = await Slide.findAll({
      where: { course_section_id: courseSectionId, classroom_id: classroomId },
      attributes: ['slide_id', 'slide_name', 'file_name', 'file_url', 'slide_number'],
    });

    res.status(200).json({
      message: 'Slides fetched successfully',
      slides,
    });
  } catch (error) {
    console.error('Error Fetching Slides:', error);
    res.status(500).json({ error: 'An error occurred while fetching slides' });
  }
});

// this might be bad practice due to large about of data being fetched
//if implemented i should use pagination
//  Route to fetch all classrooms, sections, and slides
// courseRepRouter.get('/api/course-rep/classrooms-sections-slides', auth, authorizeRole(['course_rep']), async (req, res) => {
//   try {
//     const classrooms = await Classroom.findAll({
//       where: { course_rep_id: req.user.user_id },
//       attributes: ['classroom_id', 'name', 'level', 'department', 'session'],
//       include: [{
//         model: CourseSection,
//         as: 'courseSections',
//         attributes: ['course_section_id', 'course_title', 'course_code'],
//         include: [{
//           model: Slide,
//           as: 'slides',
//           attributes: ['slide_id', 'slide_name', 'file_name', 'file_url', 'slide_number']
//         }]
//       }]
//     });

//     res.status(200).json({
//       message: 'Classrooms, sections, and slides fetched successfully',
//       classrooms,
//     });
//   } catch (error) {
//     console.error('Error fetching classrooms, sections, and slides:', error);
//     res.status(500).json({ error: 'An error occurred while fetching data' });
//   }
// });


//Route to post past questions
courseRepRouter.post('/api/course-rep/classrooms/:classroomId/course-sections/:courseSectionId/past-questions/upload',
  auth,
  authorizeRole(['course_rep']),
  upload.array('files', 5),
  async (req, res) => {
    try {
      const { classroomId, courseSectionId } = req.params;
      const { past_question_name } = req.body;

      if (!req.files || req.files.length === 0) {
        return res.status(400).json({ error: 'No files uploaded' });
      }

      const courseSection = await CourseSection.findOne({
        where: {
          course_section_id: courseSectionId,
          classroom_id: classroomId,
        },
      });

      if (!courseSection) {
        return res.status(400).json({ error: 'Course section not found' });
      }
      const file_names = req.files.map(file => file.originalname);
      // Cloudinary returns the URL in the path property
      const file_urls = req.files.map(file => file.path); 
      const newPastQuestion = await PastQuestion.create({
        past_question_name,
        file_names,
        file_urls,
        course_section_id: courseSection.course_section_id,
        classroom_id: classroomId,
      });

      res.status(201).json(
        { message: 'Past Question uploaded successfully', past_question: newPastQuestion });
    } catch (error) {
      console.error('Error uploading past question:', error);
      res.status(500).json({ error: 'Failed to upload past question' });
    }
  }
);
// Route for creating an announcement
courseRepRouter.post('/api/course-rep/classrooms/:classroomId/announcements', 
  auth, 
  authorizeRole(['course_rep']), 
  async (req, res) => {
    const { classroomId } = req.params;
    const { content } = req.body;

    try {
      const classroom = await Classroom.findOne({
        where: {
          classroom_id: classroomId,
          course_rep_id: req.user.user_id,
        },
      });

      if (!classroom) {
        return res.status(404).json({ error: 'Classroom not found or you are not authorized' });
      }

      const now = new Date();
      const announcement = await Announcement.create({
        content,
        classroom_id: classroomId,
        date: now,
        time: now.toTimeString().split(' ')[0], 
      });

      res.status(201).json({
        message: 'Announcement created successfully',
        announcement,
      });
    } catch (error) {
      console.error('Error creating announcement:', error);
      res.status(500).json({ error: 'An error occurred while creating the announcement' });
    }
  }
);
// // Helper function to fetch leaderboard
// async function fetchLeaderboard(classroomId) {
//   return await Leaderboard.findAll({
//     where: { classroom_id: classroomId },
//     include: [{
//       model: User,
//       as: 'user',
//       attributes: ['user_id', 'name', 'email'],
//       where: { role: 'student' }, // Only include students
//     }],
//     order: [
//       ['highest_streak', 'DESC'],
//       ['current_streak', 'DESC'],
//       ['total_active_days', 'DESC']
//     ],
//     limit: 10 // Top 10 students
//   });
// }
// courseRepRouter.get('/api/classrooms/:classroomId/leaderboard', 
//   auth, async (req, res) => {
//     const { classroomId } = req.params;

//     try {
//       // Check if the user is a member of the classroom or the course rep
//       const classroom = await Classroom.findOne({
//         where: {
//           classroom_id: classroomId,
//         },
//         include: [{
//           model: User,
//           as: 'students',
//           where: { user_id: req.user.user_id }
//         }]
//       });

//       const isCourseRep = await Classroom.findOne({
//         where: {
//           classroom_id: classroomId,
//           course_rep_id: req.user.user_id,
//         },
//       });

//       if (!classroom && !isCourseRep) {
//         return res.status(403).json({ error: 'You are not authorized to view this leaderboard' });
//       }

//       let leaderboard = await fetchLeaderboard(classroomId);

//       // Format the leaderboard data
//       leaderboard = leaderboard.map((entry, index) => ({
//         rank: index + 1,
//         name: entry.user.name,
//         currentStreak: entry.current_streak,
//         highestStreak: entry.highest_streak
//       }));

//       res.status(200).json({
//         message: 'Leaderboard fetched successfully',
//         leaderboard,
//       });
//     } catch (error) {
//       console.error('Error Fetching Leaderboard:', error);
//       res.status(500).json({ error: 'An error occurred while fetching the leaderboard' });
//     }
// });
// Update the leaderboard endpoint
courseRepRouter.get('/api/course-rep/classrooms/:classroomId/leaderboard', 
  auth, 
  authorizeRole(['course_rep']), 
  async (req, res) => {
    const { classroomId } = req.params;

    try {
      // console.log('User ID:', req.user.user_id);
      // console.log('Classroom ID:', classroomId);

      // Check if the user is a course rep for this classroom
      const isCourseRep = await Classroom.findOne({
        where: {
          classroom_id: classroomId,
          course_rep_id: req.user.user_id,
        },
      });

      if (!isCourseRep) {
        console.log('User is not a course rep for this classroom. Classroom ID:', classroomId, 'User ID:', req.user.user_id);
      } else {
        console.log('User is a course rep for this classroom.');
      }

      // Check if the user is a student in this classroom
      const isStudent = await ClassroomStudent.findOne({
        where: {
          classroom_id: classroomId,
          student_id: req.user.user_id
        }
      });

      if (!isStudent) {
        console.log('User is not a student in this classroom. Classroom ID:', classroomId, 'User ID:', req.user.user_id);
      } else {
        console.log('User is a student in this classroom.');
      }

      if (!isCourseRep && !isStudent) {
        return res.status(403).json({ 
          error: 'You are not authorized to view this leaderboard' 
        });
      }

      // Fetch leaderboard data
      const leaderboard = await fetchLeaderboard(classroomId);
      // console.log('Raw leaderboard data:', leaderboard);
      

      // Add ranking to the leaderboard data
      const rankedLeaderboard = leaderboard.map((entry, index) => ({
        rank: index + 1,
        ...entry
      }));

      res.status(200).json({
        message: 'Leaderboard fetched successfully',
        leaderboard: rankedLeaderboard,
      });

    } catch (error) {
      console.error('Error Fetching Leaderboard:', error);
      res.status(500).json({ 
        error: 'An error occurred while fetching the leaderboard',
        details: error.message 
      });
    }
});

// Get all students in a classroom
courseRepRouter.get('/api/course-rep/classrooms/:classroomId/students', 
  auth, authorizeRole(['course_rep']), async (req, res) => {
  try {
    const classroom = await Classroom.findOne({
      where: {
        classroom_id: req.params.classroomId,
        course_rep_id: req.user.user_id
      }
    });

    if (!classroom) {
      return res.status(404).json({ error: 'Classroom not found or unauthorized' });
    }

    const students = await ClassroomStudent.findAll({
      where: { classroom_id: req.params.classroomId },
      include: [{
        model: User,
        attributes: ['user_id', 'name', 'email', 'level']
      }]
    });

    res.status(200).json({
      message: 'Students retrieved successfully',
      students: students.map(s => s.User)
    });
  } catch (error) {
    console.error('Error fetching students:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get all past questions in a classroom
courseRepRouter.get('/api/course-rep/classrooms/:classroomId/past-questions', 
  auth, authorizeRole(['course_rep']), async (req, res) => {
  try {
    const classroom = await Classroom.findOne({
      where: {
        classroom_id: req.params.classroomId,
        course_rep_id: req.user.user_id
      }
    });

    if (!classroom) {
      return res.status(404).json({ error: 'Classroom not found or unauthorized' });
    }

    const pastQuestions = await PastQuestion.findAll({
      where: { classroom_id: req.params.classroomId },
      include: [{
        model: CourseSection,
        attributes: ['course_title', 'course_code']
      }]
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

// Get all announcements in a classroom
courseRepRouter.get('/api/course-rep/classrooms/:classroomId/announcements', 
  auth, authorizeRole(['course_rep']), async (req, res) => {
  try {
    const classroom = await Classroom.findOne({
      where: {
        classroom_id: req.params.classroomId,
        course_rep_id: req.user.user_id
      }
    });

    if (!classroom) {
      return res.status(404).json({ error: 'Classroom not found or unauthorized' });
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

module.exports = courseRepRouter;
