const { Sequelize } = require('sequelize');

const sequelize = new Sequelize('studymate_4v57', 'adeyemi_user', 'amTLezXcV7CEuQQF9nkFPi3ZIGAstWfy', {
  host: 'dpg-cu0041ij1k6c73dtjdm0-a.oregon-postgres.render.com',
  dialect: 'postgres',
  dialectOptions: {
    ssl: {
      require: true,
      rejectUnauthorized: false, 
    },
  },
});

sequelize.authenticate()
  .then(() => console.log('Database connected...'))
  .catch(err => console.log('Error: ' + err));

module.exports = sequelize;
