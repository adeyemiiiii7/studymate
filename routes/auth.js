const express = require('express');
const bcryptjs = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/user');
const authRouter = express.Router();
const validator = require('validator');
require('dotenv').config();
const auth = require('../middleware/auth');
const { updateStreak } = require('../utils/updateStreak');
const { Novu } = require('@novu/node');
const { sendVerificationEmail } = require('../utils/emailService');
const { client } = require('../config/googleAuth');
const { Op } = require('sequelize');
const cors = require('cors');

const corsOptions = {
  origin: function (origin, callback) {
    if (!origin) return callback(null, true);
    
    const allowedOrigins = [
      process.env.FRONTEND_URL || 'http://localhost:10000',
      'http://localhost:10000',
      // Add any other origins you need
    ];
    
    if (allowedOrigins.indexOf(origin) !== -1 || !origin) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
};


authRouter.use(cors(corsOptions));

// Google OAuth login URL
authRouter.get('/api/auth/google/url', (req, res) => {
  try {
    const redirectUri = process.env.GOOGLE_REDIRECT_URI || 'http://localhost:10000/auth/callback';
    
    // Add state parameter with random value to prevent CSRF and ensure uniqueness
    const state = Math.random().toString(36).substring(2, 15) + 
                  Math.random().toString(36).substring(2, 15);
    
    // Store state in cookie for verification
    res.cookie('oauth_state', state, { 
      httpOnly: true, 
      secure: process.env.NODE_ENV === 'production',
      maxAge: 10 * 60 * 1000 // 10 minutes
    });
    
    const authUrl = client.generateAuthUrl({
      access_type: 'offline',
      scope: [
        'https://www.googleapis.com/auth/userinfo.profile',
        'https://www.googleapis.com/auth/userinfo.email'
      ],
      redirect_uri: redirectUri,
      state: state,
      prompt: 'consent',  // Always show consent screen to ensure refresh token
      include_granted_scopes: true
    });
    
    res.json({ url: authUrl });
  } catch (error) {
    console.error('Error generating Google auth URL:', error);
    res.status(500).json({ 
      error: 'auth_generation_failed',
      message: 'Failed to generate authentication URL'
    });
  }
});



// UPDATED: Google OAuth token handler with improved error handling and session management
authRouter.get('/api/auth/google/token', async (req, res) => {
  try {
    const { code, state } = req.query;
    
    // Verify the required parameters
    if (!code) {
      return res.status(400).json({
        error: 'missing_code',
        message: 'Authorization code is missing'
      });
    }

    // Verify state parameter if it was used
    if (state && req.cookies.oauth_state) {
      if (state !== req.cookies.oauth_state) {
        return res.status(400).json({
          error: 'invalid_state',
          message: 'Invalid state parameter'
        });
      }
      // Clear the state cookie
      res.clearCookie('oauth_state');
    }

    const redirectUri = process.env.GOOGLE_REDIRECT_URI || 'http://localhost:10000/auth/callback';
    
    // Get tokens from Google
    let tokens;
    try {
      const tokenResponse = await client.getToken({
        code,
        redirect_uri: redirectUri
      });
      tokens = tokenResponse.tokens;
      
      // Set cache control headers to prevent caching
      res.setHeader('Cache-Control', 'no-store, no-cache, must-revalidate, proxy-revalidate');
      res.setHeader('Pragma', 'no-cache');
      res.setHeader('Expires', '0');
    } catch (error) {
      console.error('Token exchange error:', error.message);
      
      // Handle specific OAuth errors
      if (error.message && error.message.includes('invalid_grant')) {
        return res.status(400).json({
          error: 'invalid_grant',
          message: 'Your authentication code has expired or already been used. Please try signing in again.'
        });
      }
      
      return res.status(400).json({
        error: 'token_exchange_failed',
        message: 'Failed to exchange authorization code for tokens. Please try again.'
      });
    }
    
    // Set credentials and get user info
    client.setCredentials(tokens);

    // Get user info from Google
    const userInfoResponse = await client.request({
      url: 'https://www.googleapis.com/oauth2/v3/userinfo'
    });

    const { sub: googleId, email, name, picture } = userInfoResponse.data;

    // Check if user exists
    let user = await User.findOne({
      where: {
        [Op.or]: [
          { google_id: googleId },
          { email: email }
        ]
      }
    });

    if (!user) {
      return res.status(404).json({
        error: 'account_not_found',
        message: 'Please sign up first before using Google sign-in'
      });
    }

    // Link Google account if needed
    if (!user.google_id) {
      await user.update({
        google_id: googleId,
        google_email: email,
        google_picture: picture
      });
    }

    // Generate JWT token with longer expiry for better user experience
    const token = jwt.sign(
      { id: user.user_id },
      process.env.JWT_SECRET || 'defaultSecret',
      { expiresIn: '7d' }  // Extended from 1d to 7d
    );

    // Update streak
    const updatedUser = await updateStreak(user.user_id);
    
    // Return the auth data as JSON
    return res.json({
      message: 'Google sign-in successful',
      token,
      user: {
        id: updatedUser.user_id,
        first_name: updatedUser.first_name,
        last_name: updatedUser.last_name,
        email: updatedUser.email,
        role: updatedUser.role,
        level: updatedUser.level,
        department: updatedUser.department,
        course_of_study: updatedUser.course_of_study,
        current_streak: updatedUser.current_streak,
        highest_streak: updatedUser.highest_streak,
        total_active_days: updatedUser.total_active_days,
        xp: updatedUser.xp,
        google_picture: updatedUser.google_picture
      }
    });
  } catch (error) {
    console.error('Google OAuth error:', error);
    
    return res.status(500).json({
      error: 'authentication_failed',
      message: 'Authentication failed. Please try again.'
    });
  }
});
// UPDATED: Better error handling for Google OAuth callback
authRouter.get('/api/auth/google/callback', async (req, res) => {
  try {
    const { code } = req.query;
    if (!code) {
      return res.status(400).json({
        error: 'missing_code',
        message: 'Authorization code is missing'
      });
    }
    
    const redirectUri = process.env.GOOGLE_REDIRECT_URI || 'http://localhost:10000/auth/callback';

    // Get tokens from Google
    let tokens;
    try {
      const tokenResponse = await client.getToken({
        code,
        redirect_uri: redirectUri
      });
      tokens = tokenResponse.tokens;
    } catch (error) {
      console.error('Token exchange error:', error.message);
      
      // Handle specific OAuth errors
      if (error.message && error.message.includes('invalid_grant')) {
        return res.status(400).json({
          error: 'invalid_grant',
          message: 'Your authentication session has expired. Please try signing in again.'
        });
      }
      
      return res.status(400).json({
        error: 'token_exchange_failed',
        message: 'Failed to exchange authorization code for tokens. Please try again.'
      });
    }

    client.setCredentials(tokens);

    // Get user info from Google
    const userInfoResponse = await client.request({
      url: 'https://www.googleapis.com/oauth2/v3/userinfo'
    });

    const { sub: googleId, email, name, picture } = userInfoResponse.data;

    // Check if user exists
    let user = await User.findOne({
      where: {
        [Op.or]: [
          { google_id: googleId },
          { email: email }
        ]
      }
    });

    if (!user) {
      return res.status(404).json({
        error: 'account_not_found',
        message: 'Please sign up first before using Google sign-in'
      });
    }

    // If user exists but doesn't have Google ID, link their account
    if (!user.google_id) {
      await user.update({
        google_id: googleId,
        google_email: email,
        google_picture: picture
      });
    }

    // Generate JWT token with longer expiry
    const token = jwt.sign(
      { id: user.user_id },
      process.env.JWT_SECRET || 'defaultSecret',
      { expiresIn: '7d' }  // Extended from 1d to 7d
    );

    // Update streak
    const updatedUser = await updateStreak(user.user_id);
    
    // Prepare the auth data to send
    const authData = {
      message: 'Google sign-in successful',
      token,
      user: {
        id: updatedUser.user_id,
        first_name: updatedUser.first_name,
        last_name: updatedUser.last_name,
        email: updatedUser.email,
        role: updatedUser.role,
        level: updatedUser.level,
        department: updatedUser.department,
        course_of_study: updatedUser.course_of_study,
        current_streak: updatedUser.current_streak,
        highest_streak: updatedUser.highest_streak,
        total_active_days: updatedUser.total_active_days,
        xp: updatedUser.xp,
        google_picture: updatedUser.google_picture
      }
    };

    // Return JSON response
    return res.json(authData);
    
  } catch (error) {
    console.error('Google OAuth error:', error);
    
    return res.status(500).json({
      error: 'authentication_failed',
      message: 'Authentication failed. Please try again.'
    });
  }
});
authRouter.post('/users/signup', async (req, res) => {
  try {
    const { first_name, last_name, email, password, level, role = 'student', department, course_of_study } = req.body;
    const trimmedEmail = email.trim();
    console.log(`Received email: '${trimmedEmail}'`);

    // Validate email
    if (!validator.isEmail(trimmedEmail)) {
      return res.status(400).json({ error: 'Invalid email format' });
    }

    // Ensure role is either "student" or "course_rep" (should always be valid with default)
    if (role !== 'student' && role !== 'course_rep') {
      return res.status(400).json({ error: 'Invalid role. Role must be either "student" or "course_rep".' });
    }

    // Removed Babcock email restriction
    
    // Check if the user already exists
    const existingUser = await User.findOne({ where: { email: trimmedEmail } });
    if (existingUser) {
      return res.status(400).json({ error: 'Email already exists' });
    }

    // Validate level
    const parsedLevel = parseInt(level, 10);
    if (isNaN(parsedLevel) || parsedLevel < 100 || parsedLevel > 600) {
      return res.status(400).json({ error: 'Invalid level. Must be an integer between 100 and 600.' });
    }

    // Generate verification code
    const verificationCode = Math.floor(10000 + Math.random() * 90000).toString();
    const verificationExpiry = new Date(Date.now() + 30 * 60 * 1000); // 30 minutes
    console.log(`Verification code: ${verificationCode}`);

    // Hash the password
    const hashedPassword = await bcryptjs.hash(password, 10);

    // Create the user
    const user = await User.create({
      first_name,
      last_name,
      email: trimmedEmail,
      password: hashedPassword,
      role,
      level: parsedLevel,
      department,
      course_of_study,
      verification_code: verificationCode,
      verification_code_expires_at: verificationExpiry,
      is_verified: false
    });

    // Send verification email
    await sendVerificationEmail(trimmedEmail, verificationCode);

    res.status(200).json({
      message: 'User created successfully. Please check your email for verification code.',
      user: {
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        role: user.role,
        level: user.level,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

authRouter.post('/users/verify', async (req, res) => {
  try {
    const { email, code } = req.body;
    const trimmedEmail = email.trim().toLowerCase();

    const user = await User.findOne({ where: { email: trimmedEmail } });
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    if (user.is_verified) {
      return res.status(400).json({ error: 'User is already verified' });
    }

    if (user.verification_code !== code) {
      return res.status(400).json({ error: 'Invalid verification code' });
    }

    if (new Date() > new Date(user.verification_code_expires_at)) {
      return res.status(400).json({ error: 'Verification code has expired' });
    }

    // Update user verification status
    await user.update({
      is_verified: true,
      verification_code: null,
      verification_code_expires_at: null
    });

    res.status(200).json({
      message: 'Email verified successfully',
      user: {
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        role: user.role,
        level: user.level,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

authRouter.post('/users/resend-verification', async (req, res) => {
  try {
    const { email } = req.body;
    const trimmedEmail = email.trim().toLowerCase();
    
    // Find the user
    const user = await User.findOne({ where: { email: trimmedEmail } });
    
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    if (user.is_verified) {
      return res.status(400).json({ error: 'User is already verified' });
    }

    // Generate new verification code
    const verificationCode = Math.floor(10000 + Math.random() * 90000).toString();
    const verificationExpiry = new Date(Date.now() + 30 * 60 * 1000);

    // Update user with new verification code
    await user.update({
      verification_code: verificationCode,
      verification_code_expires_at: verificationExpiry
    });

    // Send new verification email
    await sendVerificationEmail(trimmedEmail, verificationCode);

    res.status(200).json({
      message: 'New verification code sent successfully'
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

authRouter.post('/users/signin', async (req, res) => {
  try {
    const { email, password } = req.body;
    const trimmedEmail = email.trim().toLowerCase();

    const user = await User.findOne({ where: { email: trimmedEmail } });
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Check if user is verified
    if (!user.is_verified) {
      return res.status(403).json({ 
        error: 'Email not verified',
        message: 'Please verify your email before signing in'
      });
    }

    const isPasswordValid = await bcryptjs.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(401).json({ error: 'Invalid password' });
    }

    // Include the user's ID in the token
    const token = jwt.sign(
      { id: user.user_id },
      process.env.JWT_SECRET || 'defaultSecret',
      { expiresIn: '1d' }
    );

    // Update the streak when the user logs in
    const updatedUser = await updateStreak(user.user_id);

    res.status(200).json({
      message: 'Sign-in successful',
      token,
      user: {
        id: updatedUser.user_id,
        first_name:updatedUser.first_name,
        last_name: updatedUser.last_name,
        email: updatedUser.email,
        role: updatedUser.role,
        level: updatedUser.level,
        department: updatedUser.department,
        course_of_study: updatedUser.course_of_study,
        current_streak: updatedUser.current_streak,
        highest_streak: updatedUser.highest_streak,
        total_active_days: updatedUser.total_active_days,
        xp: updatedUser.xp,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Add new endpoint to complete profile
authRouter.post('/auth/complete-profile', auth, async (req, res) => {
  try {
    const { department, course_of_study, level } = req.body;
    const userId = req.user.id;

    // Validate level
    const parsedLevel = parseInt(level, 10);
    if (isNaN(parsedLevel) || parsedLevel < 100 || parsedLevel > 600) {
      return res.status(400).json({ error: 'Invalid level. Must be an integer between 100 and 600.' });
    }

    // Update user profile
    const user = await User.findByPk(userId);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    await user.update({
      department,
      course_of_study,
      level: parsedLevel,
      profile_completed: true
    });

    // Generate new token with full access
    const token = jwt.sign(
      { id: user.user_id },
      process.env.JWT_SECRET || 'defaultSecret',
      { expiresIn: '1d' }
    );

    const updatedUser = await updateStreak(user.user_id);

    res.status(200).json({
      message: 'Profile completed successfully',
      token,
      user: {
        id: updatedUser.user_id,
        first_name: updatedUser.first_name,
        last_name: updatedUser.last_name,
        email: updatedUser.email,
        role: updatedUser.role,
        level: updatedUser.level,
        department: updatedUser.department,
        course_of_study: updatedUser.course_of_study,
        current_streak: updatedUser.current_streak,
        highest_streak: updatedUser.highest_streak,
        total_active_days: updatedUser.total_active_days,
        xp: updatedUser.xp,
        google_picture: updatedUser.google_picture
      }
    });
  } catch (error) {
    console.error('Error completing profile:', error);
    res.status(500).json({ error: 'Failed to complete profile' });
  }
});

// authRouter.post('/update-streak', auth, async (req, res) => {
//   try {
//     const updatedUser = await updateStreak(req.user.user_id);
//     res.json({
//       message: 'Streak updated successfully',
//       streak: {
//         current_streak: updatedUser.current_streak,
//         highest_streak: updatedUser.highest_streak,
//         total_active_days: updatedUser.total_active_days,
//       },
//     });
//   } catch (error) {
//     console.error('Error updating streak:', error);
//     res.status(500).json({ error: 'An error occurred while updating the streak' });
//   }
// });
module.exports = authRouter;
