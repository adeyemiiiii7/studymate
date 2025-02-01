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
const sequelize = require('../config/database');
const User = require('../models/user');
const { fetchLeaderboard } = require('../utils/fetchLeaderboard');
const ClassroomStudent = require('../models/classroomStudent');
const { Groq } = require('groq-sdk'); 
const Question = require('../models/question');
require('dotenv').config();

const groq = new Groq({
  apiKey: process.env.GROQ_API_KEY
});
async function generateQuestionsWithGroq(slideContent, slideNumber) {
  const prompt = `IMPORTANT: Provide ONLY a valid JSON array. Do not include any explanatory text before or after.

Generate 25 multiple choice questions based on the following structured slide content.
Ensure questions cover different aspects and difficulty levels.

Main Concepts: ${slideContent.split('Main Concepts:')[1]?.split('Key Definitions:')[0] || ''}
Key Definitions: ${slideContent.split('Key Definitions:')[1]?.split('Examples:')[0] || ''}
Examples: ${slideContent.split('Examples:')[1]?.split('Additional Notes:')[0] || ''}
Additional Notes: ${slideContent.split('Additional Notes:')[1] || ''}

Generate questions in this EXACT JSON format:
[
  {
    "question_text": "Precise question about the content",
    "options": ["option A", "option B", "option C", "option D"],
    "correct_answer": 0,
    "question_type": "definition",
    "difficulty_level": "medium"
  }
]

Slide ${slideNumber} content: ${slideContent}

JSON ARRAY:`;

  let response;
  try {
    response = await groq.chat.completions.create({
      messages: [
        {
          role: "user",
          content: prompt
        }
      ],
      model: "llama-3.3-70b-versatile",
      temperature: 0.7,
      max_tokens: 3000
    });

    const responseText = response.choices[0]?.message?.content?.trim();
    
    if (!responseText) {
      throw new Error('Empty response from Groq API');
    }

    const jsonMatch = responseText.match(/\[.*\]/s);
    
    if (!jsonMatch) {
      throw new Error('No valid JSON array found in response');
    }

    const questions = JSON.parse(jsonMatch[0]);
    return questions.map(q => ({
      ...q,
      slide_number: slideNumber
    }));

  } catch (error) {
    console.error('Detailed error generating questions:', {
      message: error.message,
      responseText: response?.choices?.[0]?.message?.content || 'No response available',
      error: error.stack
    });
    
    // Re-throw with more context
    throw new Error(`Failed to generate questions: ${error.message}`);
  }
}
// /// Initialize Anthropic API
// const anthropic = new Anthropic({
//   apiKey: process.env.ANTHROPIC_API_KEY
// });

// // Function to generate questions using Claude
// async function generateQuestionsWithClaude(slideContent, slideNumber) {
//   const prompt = `
// IMPORTANT: Provide ONLY a valid JSON array. Do not include any explanatory text before or after.

// Generate 25 multiple choice questions based on the following structured slide content. 
// Ensure questions cover different aspects and difficulty levels.

// Main Concepts:
// ${slideContent.split('Main Concepts:')[1]?.split('Key Definitions:')[0] || ''}

// Key Definitions:
// ${slideContent.split('Key Definitions:')[1]?.split('Examples:')[0] || ''}

// Examples:
// ${slideContent.split('Examples:')[1]?.split('Additional Notes:')[0] || ''}

// Additional Notes:
// ${slideContent.split('Additional Notes:')[1] || ''}

// Generate questions in this EXACT JSON format:
// [
//   {
//     "question_text": "Precise question about the content",
//     "options": ["option A", "option B", "option C", "option D"],
//     "correct_answer": 0,
//     "question_type": "definition",
//     "difficulty_level": "medium"
//   }
// ]
// Slide ${slideNumber} content:
// ${slideContent}

// JSON ARRAY:`;

//   try {
//     const response = await anthropic.messages.create({
//       model: "claude-3-opus-20240229",
//       max_tokens: 3000,
//       messages: [
//         {
//           role: "user",
//           content: prompt
//         }
//       ],
//       temperature: 0.7
//     });

//     // Extract response text and trim any potential extra text
//     const responseText = response.content[0].text.trim();
    
//     // Find the first valid JSON array in the response
//     const jsonMatch = responseText.match(/\[.*\]/s);
//     if (!jsonMatch) {
//       throw new Error('No valid JSON array found in response');
//     }

//     const questions = JSON.parse(jsonMatch[0]);
    
//     return questions.map(q => ({
//       ...q,
//       slide_number: slideNumber
//     }));
//   } catch (error) {
//     console.error('Detailed error generating questions:', {
//       message: error.message,
//       responseText: response?.content?.[0]?.text
//     });
//     throw error;
//   }
// }
// Get questions endpoint with slide-specific filtering and improved error handling
courseRepRouter.get('/api/course-rep/classrooms/:classroomId/course-sections/:courseSectionId/slides/:slideId/questions',
  auth,
  authorizeRole(['course_rep']),
  async (req, res) => {
    try {
      const { classroomId, courseSectionId, slideId } = req.params;

      // Validate slide existence first
      const slide = await Slide.findOne({
        where: {
          slide_id: slideId,
          course_section_id: courseSectionId,
          classroom_id: classroomId
        }
      });

      if (!slide) {
        return res.status(404).json({ 
          error: 'Slide not found or unauthorized access',
          questions: [] 
        });
      }

      // Fetch questions for the specific slide
      const questions = await Question.findAll({
        where: {
          slide_id: slideId,
          course_section_id: courseSectionId,
          classroom_id: classroomId
        },
        order: [['slide_number', 'ASC']],
        attributes: [
          'question_id', 
          'question_text', 
          'options', 
          'correct_answer', 
          'question_type', 
          'difficulty_level',
          'slide_number'
        ]
      });

      res.status(200).json({
        message: 'Questions retrieved successfully',
        questions: questions.length > 0 ? questions : [],
        slide: {
          slide_id: slide.slide_id,
          slide_name: slide.slide_name,
          slide_number: slide.slide_number
        }
      });
    } catch (error) {
      console.error('Error fetching questions:', error);
      res.status(500).json({ 
        error: 'Failed to fetch questions',
        questions: []
      });
    }
});

// Updated generate questions endpoint with more robust error handling
courseRepRouter.post('/api/course-rep/classrooms/:classroomId/course-sections/:courseSectionId/slides/:slideId/generate-questions',
  auth,
  authorizeRole(['course_rep']),
  async (req, res) => {
    const transaction = await sequelize.transaction();
    try {
      const { classroomId, courseSectionId, slideId } = req.params;
      const { slideContent, slideNumber } = req.body;
      
      // Validate inputs
      if (!slideContent) {
        return res.status(400).json({ 
          error: 'Slide content is required for generating questions',
          questions: []
        });
      }

      // Validate slide existence and ownership
      const slide = await Slide.findOne({
        where: {
          slide_id: slideId,
          course_section_id: courseSectionId,
          classroom_id: classroomId
        },
        transaction
      });

      if (!slide) {
        await transaction.rollback();
        return res.status(404).json({ 
          error: 'Slide not found or unauthorized access',
          questions: []
        });
      }

      // First, delete any existing questions for this slide
      await Question.destroy({
        where: {
          slide_id: slideId,
          course_section_id: courseSectionId,
          classroom_id: classroomId
        },
        transaction
      });

      // Generate new questions
      const generatedQuestions = await generateQuestionsWithGroq(slideContent, slideNumber);
      
      // Save generated questions
      const savedQuestions = await Promise.all(
        generatedQuestions.map(q => Question.create({
          ...q,
          slide_id: slide.slide_id,
          course_section_id: courseSectionId,
          classroom_id: classroomId
        }, { transaction }))
      );

      // Commit transaction
      await transaction.commit();

      res.status(200).json({
        message: 'Questions generated successfully',
        questions: savedQuestions,
        slide: {
          slide_id: slide.slide_id,
          slide_name: slide.slide_name,
          slide_number: slide.slide_number
        }
      });

    } catch (error) {
      // Rollback transaction in case of error
      if (transaction) await transaction.rollback();
      
      console.error('Error generating questions:', error);
      res.status(500).json({ 
        error: 'Failed to generate questions',
        details: error.message,
        questions: []
      });
    }
});

// Edit question endpoint with additional validation
courseRepRouter.put('/api/course-rep/classrooms/:classroomId/questions/:questionId',
  auth,
  authorizeRole(['course_rep']),
  async (req, res) => {
    try {
      const { classroomId } = req.params;
      const {
        question_text,
        options,
        correct_answer,
        question_type,
        difficulty_level,
        status,
        feedback
      } = req.body;

      const question = await Question.findOne({
        where: {
          question_id: req.params.questionId,
          classroom_id: classroomId
        },
        include: [{
          model: Slide,
          where: { classroom_id: classroomId }
        }]
      });

      if (!question) {
        return res.status(404).json({ error: 'Question not found or unauthorized access' });
      }

      await question.update({
        question_text: question_text || question.question_text,
        options: options || question.options,
        correct_answer: (correct_answer !== undefined) ? correct_answer : question.correct_answer,
        question_type: question_type || question.question_type,
        difficulty_level: difficulty_level || question.difficulty_level,
        status: status || question.status,
        feedback: feedback || question.feedback
      });

      res.status(200).json({
        message: 'Question updated successfully',
        question
      });

    } catch (error) {
      console.error('Error updating question:', error);
      res.status(500).json({ error: 'Failed to update question' });
    }
});

// Delete question endpoint with classroom validation
courseRepRouter.delete('/api/course-rep/classrooms/:classroomId/questions/:questionId',
  auth,
  authorizeRole(['course_rep']),
  async (req, res) => {
    try {
      const { classroomId } = req.params;

      const question = await Question.findOne({
        where: {
          question_id: req.params.questionId,
          classroom_id: classroomId
        }
      });

      if (!question) {
        return res.status(404).json({ error: 'Question not found or unauthorized access' });
      }

      await question.destroy();
      res.status(200).json({
        message: 'Question deleted successfully'
      });

    } catch (error) {
      res.status(500).json({ error: 'Failed to delete question' });
    }
});

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
    res.status(200).json({
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

// Route to get a specific course section's details
courseRepRouter.get('/api/course-rep/classrooms/:classroomId/course-sections/:courseSectionId', 
  auth, 
  authorizeRole(['course_rep']), 
  async (req, res) => {
    const { classroomId, courseSectionId } = req.params;

    try {
      const section = await CourseSection.findOne({
        where: {
          course_section_id: courseSectionId,
          classroom_id: classroomId
        },
        attributes: ['course_section_id', 'course_title', 'course_code']
      });

      if (!section) {
        return res.status(404).json({ 
          error: 'Course section not found' 
        });
      }

      res.status(200).json({
        message: 'Course section fetched successfully',
        section
      });
    } catch (error) {
      console.error('Error fetching course section:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
});


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
  upload.array('files', 5),
  async (req, res) => {
    const { classroomId } = req.params;
    const { content, tag, links } = req.body;

    try {
      const classroom = await Classroom.findOne({
        where: {
          classroom_id: classroomId,
          course_rep_id: req.user.user_id,
        },
      });

      if (!classroom) {
        return res.status(404).json({ error: 'Classroom not found or unauthorized' });
      }

      const files = req.files?.map(file => ({
        fileName: file.originalname,
        fileUrl: file.path
      })) || [];

      const parsedLinks = links ? JSON.parse(links) : [];

      const now = new Date();
      const announcement = await Announcement.create({
        content,
        classroom_id: classroomId,
        date: now,
        time: now.toTimeString().split(' ')[0],
        tag: tag || 'general',
        files,
        links: parsedLinks
      });

      res.status(200).json({
        message: 'Announcement created successfully',
        announcement,
      });
    } catch (error) {
      console.error('Error creating announcement:', error);
      res.status(500).json({ error: 'Failed to create announcement' });
    }
  }
);

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
courseRepRouter.get('/api/course-rep/classrooms/:classroomId/course-sections/:courseSectionId/past-questions',
  auth,
  authorizeRole(['course_rep']),
  async (req, res) => {
    const { classroomId, courseSectionId } = req.params;
    
    try {
      // Verify classroom exists and user has access
      const classroom = await Classroom.findOne({
        where: {
          classroom_id: classroomId,
          course_rep_id: req.user.user_id
        }
      });

      if (!classroom) {
        return res.status(403).json({ 
          error: 'You do not have access to this classroom' 
        });
      }

      // Verify course section exists
      const courseSection = await CourseSection.findOne({
        where: {
          course_section_id: courseSectionId,
          classroom_id: classroomId
        }
      });

      if (!courseSection) {
        return res.status(404).json({ 
          error: 'Course section not found' 
        });
      }

      const pastQuestions = await PastQuestion.findAll({
        where: { 
          course_section_id: courseSectionId,
          classroom_id: classroomId 
        },
        attributes: [
          'past_question_id',
          'past_question_name',
          'file_names',
          'file_urls'
        ]
      });

      res.status(200).json({
        message: 'Past questions fetched successfully',
        pastQuestions
      });
      
    } catch (error) {
      console.error('Error fetching past questions:', error);
      res.status(500).json({ 
        error: 'An error occurred while fetching past questions' 
      });
    }
  }
);


// Get all announcements in a classroom
courseRepRouter.get('/api/course-rep/classrooms/:classroomId/announcements', 
  auth, 
  authorizeRole(['course_rep']), 
  async (req, res) => {
    const { tag, startDate, endDate } = req.query;
    
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

      let whereClause = { classroom_id: req.params.classroomId };
      
      if (tag) {
        whereClause.tag = tag;
      }
      
      if (startDate && endDate) {
        whereClause.date = {
          [Op.between]: [startDate, endDate]
        };
      }

      const announcements = await Announcement.findAll({
        where: whereClause,
        order: [['date', 'DESC'], ['time', 'DESC']],
        attributes: [
          'announcement_id',
          'content',
          'date',
          'time',
          'tag',
          'files',
          'links'
        ]
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


courseRepRouter.delete('/api/course-rep/classrooms/:classroomId', 
  auth, 
  authorizeRole(['course_rep']), 
  async (req, res) => {
    const t = await sequelize.transaction();
    
    try {
      const classroom = await Classroom.findOne({
        where: {
          classroom_id: req.params.classroomId,
          course_rep_id: req.user.user_id
        },
        transaction: t
      });

      if (!classroom) {
        await t.rollback();
        return res.status(404).json({ error: 'Classroom not found or unauthorized' });
      }

      // Delete all associated records within transaction
      await Promise.all([
        CourseSection.destroy({
          where: { classroom_id: req.params.classroomId },
          transaction: t
        }),
        ClassroomStudent.destroy({
          where: { classroom_id: req.params.classroomId },
          transaction: t
        }),
        Announcement.destroy({
          where: { classroom_id: req.params.classroomId },
          transaction: t
        })
      ]);

      await classroom.destroy({ transaction: t });
      await t.commit();

      res.status(200).json({ message: 'Classroom deleted successfully' });
    } catch (error) {
      await t.rollback();
      console.error('Error deleting classroom:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
});

courseRepRouter.delete('/api/course-rep/classrooms/:classroomId/course-sections/:sectionId', 
  auth, 
  authorizeRole(['course_rep']), 
  async (req, res) => {
    const t = await sequelize.transaction();
    try {
      const section = await CourseSection.findOne({
        where: {
          course_section_id: req.params.sectionId,
          classroom_id: req.params.classroomId
        }
      });

      if (!section) {
        await t.rollback();
        return res.status(404).json({ error: 'Course section not found or unauthorized' });
      }

      // First, delete Questions referencing Slides in this section
      await Question.destroy({
        where: { 
          course_section_id: section.course_section_id 
        },
        transaction: t
      });

      // Then delete associated records
      await Promise.all([
        Slide.destroy({
          where: { course_section_id: section.course_section_id },
          transaction: t
        }),
        PastQuestion.destroy({
          where: { course_section_id: section.course_section_id },
          transaction: t
        })
      ]);

      // Finally delete the section
      await section.destroy({ transaction: t });
      await t.commit();

      res.status(200).json({ message: 'Course section deleted successfully' });
    } catch (error) {
      await t.rollback();
      console.error('Error deleting course section:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
});

// Delete slide
courseRepRouter.delete('/api/course-rep/classrooms/:classroomId/slides/:slideId',
  auth,
  authorizeRole(['course_rep']),
  async (req, res) => {
   const t = await sequelize.transaction();
   try {
     const slide = await Slide.findOne({
       where: {
         slide_id: req.params.slideId,
         classroom_id: req.params.classroomId
       }
     });

     if (!slide) {
       await t.rollback();
       return res.status(404).json({ error: 'Slide not found' });
     }

     // First, delete associated questions
     await Question.destroy({
       where: { slide_id: slide.slide_id },
       transaction: t
     });

     // Then delete the slide
     await slide.destroy({ transaction: t });
     
     await t.commit();
     res.status(200).json({ message: 'Slide deleted successfully' });
   } catch (error) {
     await t.rollback();
     console.error('Error deleting slide:', error);
     res.status(500).json({ 
       error: 'Internal server error', 
       details: error.message 
     });
   }
  }
);

// Delete past question
courseRepRouter.delete('/api/course-rep/classrooms/:classroomId/past-questions/:questionId', 
  auth, 
  authorizeRole(['course_rep']), 
  async (req, res) => {
    try {
      const question = await PastQuestion.findOne({
        where: {
          past_question_id: req.params.questionId,
          classroom_id: req.params.classroomId
        }
      });

      if (!question) {
        return res.status(404).json({ error: 'Past question not found' });
      }

      await question.destroy();

      res.status(200).json({ message: 'Past question deleted successfully' });
    } catch (error) {
      console.error('Error deleting past question:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
});
// Route for creating a classroom
courseRepRouter.post('/api/course-rep/classrooms/create', auth, authorizeRole(['course_rep']), async (req, res) => {
  const { name, level, department, session, course_name } = req.body;
  try {
    console.log('Request Body:', req.body);

    if (!req.user || !req.user.user_id) {
      return res.status(400).json({ error: 'User information is missing' });
    }

    if (!course_name) {
      return res.status(400).json({ error: 'Course name is required' });
    }

    // Check if course rep already has an active classroom
    const existingActiveClassroom = await Classroom.findOne({
      where: {
        course_rep_id: req.user.user_id,
        is_active: true
      }
    });

    if (existingActiveClassroom) {
      return res.status(409).json({ 
        error: 'You already have an active classroom. Please deactivate your current classroom before creating a new one.'
      });
    }

    // Sanitize email
    const courseRepEmail = req.user.email
      .trim()
      .replace(/[\x00-\x1F\x7F-\x9F]/g, '')
      .normalize('NFKC');

    if (!courseRepEmail || typeof courseRepEmail !== 'string' || !courseRepEmail.includes('@')) {
      return res.status(400).json({ error: 'Invalid course representative email' });
    }

    const existingClassroom = await Classroom.findOne({
      where: {
        course_name,
        level,
        department,
        session,
        course_rep_id: req.user.user_id,
      },
    });

    if (existingClassroom) {
      return res.status(409).json({ 
        error: 'A classroom with this course, department and level already exists for this course representative' 
      });
    }

    const joinCode = generateJoinCode();

    // Create email transporter with proper configuration
    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: 'aladesuyides@gmail.com', 
        pass: 'kugi fihw cugc trye'
      },
      tls: {
        rejectUnauthorized: false // Allow self-signed certificates
      }
    });

    // Debug email before sending
    console.log('Email Debug Info:', {
      emailType: typeof courseRepEmail,
      emailValue: courseRepEmail,
      bufferHex: Buffer.from(courseRepEmail).toString('hex')
    });

    // Email options
    const mailOptions = {
      from: 'Classroom Management <aladesuyides@gmail.com>',
      to: courseRepEmail.trim(), 
      subject: 'Classroom Join Code',
      headers: {
        'Priority': 'high',
        'X-MS-Exchange-Organization-AuthAs': 'Internal'
      },
      html: `<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;">
    <div style="max-width: 600px; margin: 0 auto; background-color: #ffffff; padding: 20px; border-radius: 10px; margin-top: 20px; box-shadow: 0 0 10px rgba(0,0,0,0.1);">
        <!-- Header -->
        <div style="text-align: center; padding: 20px 0; border-bottom: 2px solid #f0f0f0;">
            <h1 style="color: #2c3e50; margin: 0; font-size: 24px;">Welcome to StudyMate!</h1>
        </div>

        <!-- Main Content -->
        <div style="padding: 20px 0;">
            <p style="color: #34495e; font-size: 16px; line-height: 1.6;">Dear <strong>${req.user.first_name}</strong>,</p>
            
            <p style="color: #34495e; font-size: 16px; line-height: 1.6;">We are excited to inform you that your new classroom has been successfully created on <strong>StudyMate</strong>. As a course rep, you're now ready to manage resources, quizzes, and announcements for your classroom.</p>

            <!-- Classroom Details Box -->
            <div style="background-color: #f8f9fa; padding: 20px; border-radius: 5px; margin: 20px 0;">
                <h2 style="color: #2c3e50; font-size: 18px; margin-top: 0;">Classroom Details</h2>
                <ul style="list-style: none; padding: 0; margin: 0;">
                    <li style="color: #34495e; padding: 5px 0;">
                        <strong>Classroom Name:</strong> ${name}
                    </li>
                    <li style="color: #34495e; padding: 5px 0;">
                        <strong>Department:</strong> ${department}
                    </li>
                    <li style="color: #34495e; padding: 5px 0;">
                        <strong>Level:</strong> ${level}
                    </li>
                    <li style="color: #34495e; padding: 5px 0;">
                        <strong>Join Code:</strong> <span style="background-color: #e3f2fd; padding: 2px 8px; border-radius: 3px;">${joinCode}</span>
                    </li>
                </ul>
            </div>

            <!-- Next Steps Section -->
            <div style="margin: 20px 0;">
                <h2 style="color: #2c3e50; font-size: 18px;">Your Next Steps</h2>
                <ol style="color: #34495e; padding-left: 20px; line-height: 1.6;">
                    <li><strong>Upload Resources:</strong> Post any relevant course materials for your students to access.</li>
                    <li><strong>Create Quizzes:</strong> Prepare quizzes for your students to assess their learning.</li>
                    <li><strong>Post Announcements:</strong> Keep your students updated with the latest news and course information.</li>
                </ol>
            </div>

            <p style="color: #34495e; font-size: 16px; line-height: 1.6;">If you have any questions or need assistance, don't hesitate to reach out.</p>
        </div>

        <!-- Footer -->
        <div style="text-align: center; padding-top: 20px; border-top: 2px solid #f0f0f0;">
            <p style="color: #7f8c8d; font-size: 14px;">Thank you for being a part of <strong>StudyMate</strong></p>
            <p style="color: #7f8c8d; margin-bottom: 20px;">Best Regards,<br>The <strong>StudyMate</strong> Team</p>
            
            <!-- Logo -->
            <div style="display: flex; align-items: center; justify-content: center; margin-top: 20px;">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="#0e161b" style="margin-right: 8px;">
                    <path d="M12 14l9-5-9-5-9 5 9 5z"/>
                    <path d="M12 14l6.16-3.422a12.083 12.083 0 01.665 6.479A11.952 11.952 0 0012 20.055a11.952 11.952 0 00-6.824-2.998 12.078 12.078 0 01.665-6.479L12 14z"/>
                    <path d="M12 14l-6.16-3.422a12.083 12.083 0 00-.665 6.479A11.952 11.952 0 0112 20.055a11.952 11.952 0 016.824-2.998 12.078 12.078 0 00-.665-6.479L12 14z"/>
                </svg>
                <span style="color: #0e161b; font-size: 20px; font-weight: bold;">StudyMate</span>
            </div>
        </div>
    </div>
</body>
</html>`
    };
      try {
      const emailResult = await new Promise((resolve, reject) => {
        transporter.sendMail(mailOptions, (error, info) => {
          if (error) {
            console.error('Detailed Email Error:', {
              error: error.message,
              code: error.code,
              command: error.command,
              responseCode: error.responseCode,
              response: error.response
            });
            reject(error);
          } else {
            console.log('Email sent successfully:', info.response);
            resolve(info);
          }
        });
      });

      const classroom = await Classroom.create({
        name,
        level,
        department,
        course_name, // Added course_name
        session,
        join_code: joinCode,
        course_rep_id: req.user.user_id,
        is_active: true
      });

      res.status(200).json({
        message: 'Classroom created successfully and notification email sent',
        classroom,
      });

    } catch (emailError) {
      console.error('Failed to send email:', emailError);
      return res.status(500).json({ 
        error: 'Failed to send notification email. Classroom was not created.',
        details: emailError.message 
      });
    }

  } catch (error) {
    console.error('Error Creating Classroom:', error);
    res.status(500).json({ 
      error: 'An error occurred while creating the classroom',
      details: error.message 
    });
  }
});
module.exports = courseRepRouter;
