const express = require('express');
const morgan = require('morgan');
const cors = require('cors');
const authRouter = require('./routes/auth');
const courseRepRouter = require('./routes/courseRep');
const studentRouter = require('./routes/students');
const sequelize = require('./config/database'); 
const setupAssociations = require('./config/associations'); 
const questRouter = require('./routes/questRoute.js');
const wellnessRouter = require('./routes/wellness.js');
const app = express();
app.use(express.json());
// Setup associations
setupAssociations();

// Middleware
app.use(cors());
app.use(morgan('dev'));
app.use(authRouter);
app.use(courseRepRouter);
app.use(studentRouter);
app.use(questRouter);
app.use(wellnessRouter);

sequelize
  .sync({ alter: true }) 
  .then(() => {
    console.log('Database & tables created/updated!');
  })
  .catch(err => console.log('Error syncing database:', err));

 const PORT = process.env.PORT || 3000;
  app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
  });
  
