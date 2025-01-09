const express = require('express');
const { updateStreak } = require('../utils/updateStreak');
const auth = require('../middleware/auth');

const activityTimers = new Map(); 

function activityMiddleware(req, res, next) {
    const userId = req.user.user_id;

    // Clear any existing timer for this user
    if (activityTimers.has(userId)) {
        clearTimeout(activityTimers.get(userId));
    }

    // Set a new timer to update the streak after 5 minutes of inactivity
    const timer = setTimeout(async () => {
        try {
            await updateStreak(userId);
            console.log(`Streak updated for user ${userId} due to inactivity`);
        } catch (error) {
            console.error('Error updating streak:', error);
        }
    }, 5 * 60 * 1000); // 5 minutes

    // Store the new timer
    activityTimers.set(userId, timer);

    next();
}