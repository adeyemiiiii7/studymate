const express = require('express');
const morgan = require('morgan');
const cors = require('cors');
const authRouter = require('./routes/auth');
const courseRepRouter = require('./routes/courseRep');
const studentRouter = require('./routes/students');
const sequelize = require('./config/database'); 
const setupAssociations = require('./config/associations'); 

const app = express();
app.use(express.json());
// Setup associations
setupAssociations();

// Middleware
app.use(cors());
app.use(morgan('combined'));
app.use(authRouter);
app.use(courseRepRouter);
app.use(studentRouter);

sequelize
  .sync({ alter: true }) 
  .then(() => {
    console.log('Database & tables created/updated!');
  })
  .catch(err => console.log('Error syncing database:', err));

app.listen(3000, () => {
  console.log('Server is running on port 3000');
});
