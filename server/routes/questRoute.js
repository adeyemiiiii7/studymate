// quest-router.js
const express = require('express');
const questRouter = express.Router();
const auth = require('../middleware/auth');
const User = require('../models/user');
const authorizeRole = require('../middleware/authorizeRole');
const { updateStreak } = require('../utils/updateStreak');

const QUEST_REWARDS = {
  completeQuiz: { xp: 50, title: 'Complete daily quiz' },
  studySession: { xp: 30, title: 'Study for 30 minutes' },
  readSlides: { xp: 25, title: 'Read course slides' },
  followSchedule: { xp: 20, title: 'Follow study timetable' },
  learnSkill: { xp: 35, title: 'Learn something new' },
  codingPractice: { xp: 40, title: 'Practice coding' }
};

questRouter.get('/api/quests/status', auth, authorizeRole(['student', 'course_rep']), async (req, res) => {
  try {
    const user = await User.findByPk(req.user.user_id);
    
    // Get UTC date
    const now = new Date();
    const today = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()))
      .toISOString()
      .split('T')[0];

    // Always check and update streak when fetching quest status
    await updateStreak(req.user.user_id);

    // Reset quests if it's a new day or no reset date
    if (!user.last_quest_reset || user.last_quest_reset !== today) {
      console.log('Resetting daily quests');
      user.daily_quest_status = Object.fromEntries(
        Object.keys(QUEST_REWARDS).map(quest => [quest, false])
      );
      user.last_quest_reset = today;
      await user.save();
    }

    res.json({
      xp: user.xp,
      questStatus: user.daily_quest_status
    });
  } catch (error) {
    console.error('Error fetching quest status:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

questRouter.post('/api/quests/complete/:questId', auth, authorizeRole(['student']), async (req, res) => {
  try {
    const { questId } = req.params;
    const user = await User.findByPk(req.user.user_id);
    
    // Get UTC date
    const now = new Date();
    const today = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()))
      .toISOString()
      .split('T')[0];

    // Update streak when completing a quest
    await updateStreak(req.user.user_id);

    // Force reset if new day
    if (!user.last_quest_reset || user.last_quest_reset !== today) {
      user.daily_quest_status = Object.fromEntries(
        Object.keys(QUEST_REWARDS).map(quest => [quest, false])
      );
      user.last_quest_reset = today;
    }

    if (user.daily_quest_status[questId]) {
      return res.status(400).json({ error: 'Quest already completed today' });
    }

    const reward = QUEST_REWARDS[questId];
    if (!reward) {
      return res.status(400).json({ error: 'Invalid quest' });
    }

    user.xp += reward.xp;
    user.daily_quest_status = {
      ...user.daily_quest_status,
      [questId]: true
    };
    user.last_quest_reset = today;
    await user.save();

    res.json({
      message: 'Quest completed',
      xp: user.xp,
      questStatus: user.daily_quest_status
    });
  } catch (error) {
    console.error('Error completing quest:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = questRouter;