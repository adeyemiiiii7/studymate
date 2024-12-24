const express = require('express');
const questRouter = express.Router();
const auth = require('../middleware/auth');
const User = require('../models/user');
const authorizeRole = require('../middleware/authorizeRole');

const QUEST_REWARDS = {
  completeQuiz: { xp: 50, title: 'Complete daily quiz' },
  studySession: { xp: 30, title: 'Study for 30 minutes' },
  readSlides: { xp: 25, title: 'Read course slides' },
  followSchedule: { xp: 20, title: 'Follow study timetable' },
  learnSkill: { xp: 35, title: 'Learn something new' },
  codingPractice: { xp: 40, title: 'Practice coding' }
};

questRouter.post('/api/quests/complete/:questId', auth,  authorizeRole(['student']),async (req, res) => {
  try {
    const { questId } = req.params;
    const user = await User.findByPk(req.user.user_id);
    const today = new Date().toISOString().split('T')[0];

    if (user.last_quest_reset !== today) {
      user.daily_quest_status = {};
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
    user.daily_quest_status[questId] = true;
    await user.save();

    res.json({ 
      message: 'Quest completed',
      xp: user.xp,
      questStatus: user.daily_quest_status
    });
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = questRouter;