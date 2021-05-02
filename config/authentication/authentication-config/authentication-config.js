const { app } = require('../../app/app-config/app-config');
const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;

app.use(passport.initialize());

// authentication
passport.use(new LocalStrategy(
    {   // by default, local strategy uses username and password, we will override with email
        usernameField : 'email',
        passwordField : 'password',
    },
    (email, password, done)=>{
      console.log('local');
      const sql1 = `select * from users WHERE email= '${email}'; `;
      con.query(sql1, (err, user) =>{
          if (err) return done(err);
          if(!user[0]) return done(null, false, 'Email not found');
          if(password != user[0].password) return done(null, false, 'Incorrect password.');
          return done(null, user[0]);
      });   
}));

module.exports.passport = passport;
