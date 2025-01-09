const jwt = require('jsonwebtoken');
const User = require('../models/user');
const auth = async (req, res, next) => {
    try {
        const authHeader = req.headers.authorization;
        if (!authHeader) {
            return res.status(401).json({ message: 'Authorization header missing' });
        }

        // Validate Bearer token format
        if (!authHeader.startsWith('Bearer ')) {
            return res.status(401).json({ message: 'Invalid token format' });
        }

        const token = authHeader.split(' ')[1];
        if (!token) {
            return res.status(401).json({ message: 'Token missing' });
        }

        try {
            const decodedToken = jwt.verify(token, process.env.JWT_SECRET);
            if (!decodedToken.id) {
                return res.status(401).json({ message: 'Invalid token: missing user ID' });
            }

            const user = await User.findOne({ where: { user_id: decodedToken.id } });
            if (!user) {
                return res.status(404).json({ message: 'User not found' });
            }

            req.user = user;
            next();
        } catch (jwtError) {
            console.error('JWT Verification Error:', jwtError);
            return res.status(401).json({ 
                message: 'Invalid or expired token',
                error: jwtError.message 
            });
        }
    } catch (err) {
        console.error('Auth Middleware Error:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
};
module.exports = auth;