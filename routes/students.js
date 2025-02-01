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
const SlideQuestionAttempt = require('../models/slideQuestionAttempt');
const Question = require('../models/question');
const { Op } = require('sequelize');
studentRouter.get('/api/student/classrooms/:classroomId/sections/:sectionId/slides/:slideId/test',
  auth, 
  authorizeRole(['student', 'course_rep']), 
  async (req, res) => {
    try {
      const { classroomId, sectionId, slideId } = req.params;
      
      // Get all questions for the slide - including pending_review for testing
      const allQuestions = await Question.findAll({
        where: {
          slide_id: slideId,
          course_section_id: sectionId,
          classroom_id: classroomId,
          status: {
            [Op.in]: ['approved', 'pending_review'] // Accept both statuses
          }
        }
      });

      console.log('Questions found:', {
        total: allQuestions.length,
        byStatus: allQuestions.reduce((acc, q) => {
          acc[q.status] = (acc[q.status] || 0) + 1;
          return acc;
        }, {})
      });

      if (allQuestions.length === 0) {
        return res.status(200).json({
          message: 'No questions available for this slide',
          debug: {
            queryParams: {
              slide_id: slideId,
              course_section_id: sectionId,
              classroom_id: classroomId
            }
          }
        });
      }
     // Backend: Shuffling logic (already correct)
const shuffledQuestions = allQuestions.map(q => {
  const shuffledOptions = q.options
    .map((value, originalIndex) => ({ 
      value, 
      originalIndex,
      sort: Math.random() 
    }))
    .sort((a, b) => a.sort - b.sort);

  const optionMapping = shuffledOptions.map(opt => opt.originalIndex);

  return {
    question_id: q.question_id,
    question_text: q.question_text,
    options: shuffledOptions.map(opt => opt.value),
    correct_answer: q.correct_answer,
    option_mapping: optionMapping // Send this to the frontend
  };
})
      .sort(() => 0.5 - Math.random())
      .slice(0, 25);

      res.status(200).json({
        message: 'Test questions retrieved successfully',
        questions: shuffledQuestions,
        debug: {
          totalQuestions: allQuestions.length,
          returnedQuestions: shuffledQuestions.length
        }
      });
    } catch (error) {
      console.error('Error fetching test questions:', error);
      res.status(500).json({ 
        error: 'Internal server error',
        debug: {
          message: error.message
        }
      });
    }
});
studentRouter.post('/api/student/classrooms/:classroomId/sections/:sectionId/slides/:slideId/submit-test',
  auth, 
  authorizeRole(['student', 'course_rep']), 
  async (req, res) => {
    try {
      const { classroomId, sectionId, slideId } = req.params;
      const { userAnswers } = req.body;

      // Validate userAnswers
      if (!Array.isArray(userAnswers) || userAnswers.length === 0) {
        return res.status(400).json({ error: 'Invalid user answers format' });
      }

      // Verify classroom membership for students
      if (req.user.role === 'student') {
        const classroomStudent = await ClassroomStudent.findOne({
          where: { 
            student_id: req.user.user_id, 
            classroom_id: classroomId 
          }
        });

        if (!classroomStudent) {
          return res.status(403).json({ error: 'Not enrolled in this classroom' });
        }
      }

      // Fetch the full questions to verify answers
      const questions = await Question.findAll({
        where: {
          slide_id: slideId,
          course_section_id: sectionId,
          classroom_id: classroomId,
          question_id: userAnswers.map(a => a.question_id)
        }
      });

      if (questions.length === 0) {
        return res.status(404).json({ error: 'No questions found' });
      }

    // Backend: Scoring logic (no changes needed)
const scoredAnswers = userAnswers.map(userAnswer => {
  const question = questions.find(q => q.question_id === userAnswer.question_id);

  if (!question) {
    console.error(`Question not found for ID: ${userAnswer.question_id}`);
    return null;
  }

  // The selected_option is already the original index
  const originalOptionIndex = userAnswer.selected_option;

  // Validate that both the answer and correct_answer exist
  const isCorrect = question.correct_answer !== undefined && 
                   originalOptionIndex !== undefined && 
                   question.correct_answer === originalOptionIndex;

  return {
    question_id: userAnswer.question_id,
    question_text: question.question_text,
    user_selected_option: originalOptionIndex, // Original index
    correct_answer: question.correct_answer,
    correct_option: question.options[question.correct_answer],
    is_correct: isCorrect,
    options: question.options
  };
}).filter(answer => answer !== null);

      if (scoredAnswers.length === 0) {
        return res.status(400).json({ error: 'No valid answers could be processed' });
      }

      const score = (scoredAnswers.filter(a => a.is_correct).length / scoredAnswers.length) * 100;

      // Record the attempt
      await SlideQuestionAttempt.create({
        user_id: req.user.user_id,
        slide_id: slideId,
        classroom_id: classroomId,
        course_section_id: sectionId,
        questions_attempted: scoredAnswers,
        score
      });

      res.status(200).json({
        message: 'Test submitted successfully',
        score,
        attempts: scoredAnswers
      });
    } catch (error) {
      console.error('Error submitting test:', error);
      res.status(500).json({ 
        error: 'Internal server error',
      });
    }
});
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
studentRouter.get('/api/student/classrooms', 
  auth, 
  authorizeRole(['student']), 
  async (req, res) => {
    try {
      const user = await User.findOne({
        where: { user_id: req.user.user_id },
        include: [{
          model: Classroom,
          as: 'classrooms',
          through: { attributes: [] }, // Exclude junction table attributes
          include: [{
            model: CourseSection,
            as: 'courseSections',
            attributes: ['course_section_id', 'course_title', 'course_code']
          }],
          attributes: [
            'classroom_id',
            'name',
            'level',
            'department',
            'session'
          ]
        }]
      });

      if (!user) {
        return res.status(404).json({
          error: 'User not found'
        });
      }

      res.status(200).json({
        message: 'Classrooms retrieved successfully',
        classrooms: user.classrooms
      });
    } catch (error) {
      console.error('Error fetching classrooms:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
});

// Get all classrooms the student is enrolled in
studentRouter.get('/api/student/classrooms/:classroomId', 
  auth, 
  authorizeRole(['student']), 
  async (req, res) => {
    const { classroomId } = req.params;
    
    try {
      // First verify the student is part of this classroom
      const classroomStudent = await ClassroomStudent.findOne({
        where: {
          student_id: req.user.user_id,
          classroom_id: classroomId
        }
      });

      if (!classroomStudent) {
        return res.status(404).json({
          error: 'Classroom not found or you do not have permission to access it'
        });
      }

      // Then fetch the classroom details
      const classroom = await Classroom.findOne({
        where: { classroom_id: classroomId },
        attributes: [
          'classroom_id',
          'name',
          'level',
          'department',
          'session'
        ],
        include: [{
          model: CourseSection,
          as: 'courseSections',
          attributes: ['course_section_id', 'course_title', 'course_code']
        }]
      });

      if (!classroom) {
        return res.status(404).json({
          error: 'Classroom not found'
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

// Add the sections route
studentRouter.get('/api/student/classrooms/:classroomId/sections',
  auth,
  authorizeRole(['student']),
  async (req, res) => {
    const { classroomId } = req.params;
    
    try {
      // First verify the student is part of this classroom
      const classroomStudent = await ClassroomStudent.findOne({
        where: {
          student_id: req.user.user_id,
          classroom_id: classroomId
        }
      });

      if (!classroomStudent) {
        return res.status(404).json({
          error: 'Classroom not found or you do not have permission to access it'
        });
      }

      const sections = await CourseSection.findAll({
        where: { classroom_id: classroomId },
        attributes: ['course_section_id', 'course_title', 'course_code']
      });

      res.status(200).json({
        message: 'Sections fetched successfully',
        sections
      });
    } catch (error) {
      console.error('Error fetching sections:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
});
studentRouter.get('/api/student/classrooms/:classroomId/sections',
  auth,
  authorizeRole(['student']),
  async (req, res) => {
    const { classroomId } = req.params;
    
    try {
      const sections = await CourseSection.findAll({
        where: { classroom_id: classroomId },
        attributes: ['course_section_id', 'course_title', 'course_code']
      });

      res.status(200).json({
        message: 'Sections fetched successfully',
        sections
      });
    } catch (error) {
      console.error('Error fetching sections:', error);
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
