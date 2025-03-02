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
// Enhanced submit-test route for slides with progress analysis
studentRouter.post('/api/student/classrooms/:classroomId/sections/:sectionId/slides/:slideId/submit-test',
  auth, 
  authorizeRole(['student', 'course_rep']), 
  async (req, res) => {
    try {
      const { classroomId, sectionId, slideId } = req.params;
      const { userAnswers } = req.body;
      const userId = req.user.user_id;

      // Validate userAnswers
      if (!Array.isArray(userAnswers) || userAnswers.length === 0) {
        return res.status(400).json({ error: 'Invalid user answers format' });
      }

      // Verify classroom membership for students
      if (req.user.role === 'student') {
        const classroomStudent = await ClassroomStudent.findOne({
          where: { 
            student_id: userId, 
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

      // Scoring logic
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
        user_id: userId,
        slide_id: slideId,
        classroom_id: classroomId,
        course_section_id: sectionId,
        questions_attempted: scoredAnswers,
        score
      });

      // Get performance analysis including past attempts
      const performanceAnalysis = await SlideQuestionAttempt.getPerformanceAnalysis(userId, slideId);

      // Prepare personalized feedback based on performance
      let feedbackMessage = performanceAnalysis.message;
      
      // Add more detailed feedback for improvement if needed
      if (performanceAnalysis.improvementNeeded) {
        // Identify weak areas
        const weakTopics = scoredAnswers
          .filter(a => !a.is_correct)
          .map(a => a.question_text)
          .slice(0, 3); // Get up to 3 topics to focus on
          
        feedbackMessage += " Focus on these areas: " + 
          (weakTopics.length > 0 ? weakTopics.join(", ") : "Review all topics in this slide");
      }

      res.status(200).json({
        message: 'Test submitted successfully',
        currentScore: score,
        performanceHistory: {
          attempts: performanceAnalysis.attempts.length,
          averageScore: performanceAnalysis.averageScore.toFixed(1),
          highestScore: performanceAnalysis.highestScore,
          recentScores: performanceAnalysis.attempts.map(a => ({
            score: a.score,
            date: a.completed_at
          })).slice(0, 5)
        },
        feedback: feedbackMessage,
        scoredAnswers
      });
    } catch (error) {
      console.error('Error submitting test:', error);
      res.status(500).json({ 
        error: 'Internal server error',
      });
    }
});

// New route for slide progress tracking
studentRouter.get('/api/student/classrooms/:classroomId/slides/:slideId/progress',
  auth, 
  authorizeRole(['student', 'course_rep']), 
  async (req, res) => {
    try {
      const { classroomId, slideId } = req.params;
      const userId = req.user.user_id;

      // Verify classroom enrollment
      if (req.user.role === 'student') {
        const enrollment = await ClassroomStudent.findOne({
          where: { 
            student_id: userId, 
            classroom_id: classroomId 
          }
        });

        if (!enrollment) {
          return res.status(403).json({ error: 'Not enrolled in this classroom' });
        }
      }

      // Get slide details to provide better context
      const slide = await Slide.findOne({
        where: {
          slide_id: slideId,
          classroom_id: classroomId
        }
      });

      if (!slide) {
        return res.status(404).json({ error: 'Slide not found' });
      }

      // Get progress analysis
      const progressData = await SlideQuestionAttempt.getPerformanceAnalysis(userId, slideId);
      
      // Get last 5 attempts with details
      const lastAttempts = await SlideQuestionAttempt.getLastAttempts(userId, slideId);
      
      // Calculate improvement trend
      let trend = "Not enough data";
      if (lastAttempts.length >= 2) {
        const recentScores = lastAttempts.map(attempt => attempt.score).reverse();
        const firstScore = recentScores[0];
        const lastScore = recentScores[recentScores.length - 1];
        
        if (lastScore > firstScore) {
          trend = "Improving";
        } else if (lastScore < firstScore) {
          trend = "Declining";
        } else {
          trend = "Stable";
        }
      }
      
      // Generate study recommendations
      let studyRecommendation = "";
      if (progressData.improvementNeeded) {
        studyRecommendation = "Based on your performance, we recommend reviewing the following topics:";
        
        // Analyze question patterns from the most recent attempt
        if (lastAttempts.length > 0) {
          const latestAttempt = lastAttempts[0];
          const missedQuestions = latestAttempt.questions_attempted
            .filter(q => !q.is_correct)
            .slice(0, 3);
            
          if (missedQuestions.length > 0) {
            missedQuestions.forEach((q, idx) => {
              studyRecommendation += `\n${idx + 1}. ${q.question_text}`;
            });
          } else {
            studyRecommendation += " Review all slide content thoroughly.";
          }
        }
      } else if (progressData.averageScore >= 80) {
        studyRecommendation = "Great work! You're showing strong understanding of this slide's content. Consider exploring advanced topics.";
      } else {
        studyRecommendation = "You're making good progress. Continue practice to reinforce your understanding.";
      }

      res.status(200).json({
        slideName: slide.title || `Slide ${slide.slide_number}`,
        progressSummary: {
          attemptCount: lastAttempts.length,
          lastFiveScores: lastAttempts.map(a => ({
            score: a.score.toFixed(1),
            date: a.completed_at,
            passingStatus: a.score >= 60 ? "Pass" : "Needs Improvement"
          })),
          averageScore: progressData.averageScore.toFixed(1),
          highestScore: progressData.highestScore.toFixed(1),
          lowestScore: progressData.lowestScore.toFixed(1),
          performanceTrend: trend
        },
        needsImprovement: progressData.improvementNeeded,
        studyRecommendation,
        performanceMessage: progressData.message
      });
    } catch (error) {
      console.error('Error fetching progress data:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
});

// New route for section-wide slide progress
// studentRouter.get('/api/student/classrooms/:classroomId/sections/:sectionId/slides-progress',
//   auth,
//   authorizeRole(['student', 'course_rep']),
//   async (req, res) => {
//     try {
//       const { classroomId, sectionId } = req.params;
//       const userId = req.user.user_id;

//       // Verify classroom enrollment
//       if (req.user.role === 'student') {
//         const enrollment = await ClassroomStudent.findOne({
//           where: { 
//             student_id: userId, 
//             classroom_id: classroomId 
//           }
//         });

//         if (!enrollment) {
//           return res.status(403).json({ error: 'Not enrolled in this classroom' });
//         }
//       }

//       // Get all slides for the section
//       const slides = await Slide.findAll({
//         where: {
//           classroom_id: classroomId,
//           course_section_id: sectionId
//         },
//         order: [['slide_number', 'ASC']]
//       });

//       if (!slides || slides.length === 0) {
//         return res.status(404).json({ error: 'No slides found for this section' });
//       }

//       const slideIds = slides.map(slide => slide.slide_id);
      
//       // Get multi-slide progress data
//       const progressData = await SlideQuestionAttempt.getProgressAcrossSlides(userId, slideIds);
      
//       // Calculate overall section progress
//       const completedSlides = Object.values(progressData).filter(p => p.completed).length;
//       const passingSlides = Object.values(progressData).filter(p => p.passed).length;
//       const overallProgress = (completedSlides / slideIds.length) * 100;
      
//       // Calculate average score across all completed slides
//       const completedScores = Object.values(progressData)
//         .filter(p => p.completed)
//         .map(p => p.score);
      
//       const averageScore = completedScores.length > 0 
//         ? completedScores.reduce((sum, score) => sum + score, 0) / completedScores.length 
//         : 0;
        
//       // Prepare slide-specific data
//       const slideProgress = slides.map(slide => {
//         const progress = progressData[slide.slide_id] || { completed: false, score: null, passed: false };
//         return {
//           slide_id: slide.slide_id,
//           slide_number: slide.slide_number,
//           title: slide.title || `Slide ${slide.slide_number}`,
//           completed: progress.completed,
//           score: progress.score ? progress.score.toFixed(1) : null,
//           passed: progress.passed,
//           completedAt: progress.completedAt
//         };
//       });

//       res.status(200).json({
//         sectionProgress: {
//           totalSlides: slideIds.length,
//           completedSlides,
//           passingSlides,
//           overallProgressPercent: overallProgress.toFixed(1),
//           averageScore: averageScore.toFixed(1)
//         },
//         slideDetails: slideProgress,
//         recommendationMessage: overallProgress < 50 
//           ? "You still have many slides to complete in this section." 
//           : overallProgress < 80 
//             ? "You're making good progress through this section. Continue working on the remaining slides." 
//             : "You've made excellent progress in this section. Focus on any remaining slides to complete your learning."
//       });
//     } catch (error) {
//       console.error('Error fetching section slides progress:', error);
//       res.status(500).json({ error: 'Internal server error' });
//     }
//   }
// );
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

// // the sections route
// studentRouter.get('/api/student/classrooms/:classroomId/sections',
//   auth,
//   authorizeRole(['student']),
//   async (req, res) => {
//     const { classroomId } = req.params;
    
//     try {
//       // First verify the student is part of this classroom
//       const classroomStudent = await ClassroomStudent.findOne({
//         where: {
//           student_id: req.user.user_id,
//           classroom_id: classroomId
//         }
//       });

//       if (!classroomStudent) {
//         return res.status(404).json({
//           error: 'Classroom not found or you do not have permission to access it'
//         });
//       }

//       const sections = await CourseSection.findAll({
//         where: { classroom_id: classroomId },
//         attributes: ['course_section_id', 'course_title', 'course_code']
//       });

//       res.status(200).json({
//         message: 'Sections fetched successfully',
//         sections
//       });
//     } catch (error) {
//       console.error('Error fetching sections:', error);
//       res.status(500).json({ error: 'Internal server error' });
//     }
// });
// studentRouter.get('/api/student/classrooms/:classroomId/sections',
//   auth,
//   authorizeRole(['student']),
//   async (req, res) => {
//     const { classroomId } = req.params;
    
//     try {
//       const sections = await CourseSection.findAll({
//         where: { classroom_id: classroomId },
//         attributes: ['course_section_id', 'course_title', 'course_code']
//       });

//       res.status(200).json({
//         message: 'Sections fetched successfully',
//         sections
//       });
//     } catch (error) {
//       console.error('Error fetching sections:', error);
//       res.status(500).json({ error: 'Internal server error' });
//     }
// });

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
