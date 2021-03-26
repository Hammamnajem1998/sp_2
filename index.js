// for express
const express = require('express');
const app = express();
app.use(express.json());

// for passport 
const passport = require('passport');
app.use(passport.initialize());
const LocalStrategy = require('passport-local').Strategy;

// for joi
const Joi = require('joi');
const signupSchema = Joi.object({
    username: Joi.string().alphanum().min(3).max(30).required(),
    password: Joi.string().pattern(new RegExp('^[a-zA-Z0-9]{3,30}$')).min(6).required(),
    repeat_password: Joi.ref('password'),
    email: Joi.string().email({ minDomainSegments: 2, tlds: { allow: ['com', 'net'] } }).required()
})
const signinSchema = Joi.object({
    password: Joi.string().pattern(new RegExp('^[a-zA-Z0-9]{3,30}$')).min(6).required(),
    repeat_password: Joi.ref('password'),
    email: Joi.string().email({ minDomainSegments: 2, tlds: { allow: ['com', 'net'] } }).required()
})

// for mysql local
const mysql = require('mysql');
var con = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "root",
    database: "temp_schema"
});

// for mysql heroku database (cloud)
// var con = mysql.createConnection({
//     host: "us-cdbr-east-03.cleardb.com",
//     user: "bca894223fa92f",
//     password: "bd33beab",
//     database: "heroku_5dbb5278d6f4a3f"
// });


passport.use(new LocalStrategy(
    {   // by default, local strategy uses username and password, we will override with email
        usernameField : 'email',
        passwordField : 'password',
    },
    (email, password, done)=>{
        const sql1 = `select * from users WHERE email= '${email}'; `;
        con.query(sql1, (err, user) =>{
            if (err) return done(err);
            if(!user[0]) return done(null, false, 'Email not found');
            if(password != user[0].password) return done(null, false, 'Incorrect password.');
            return done(null, user[0]);
    }); 
}));

app.post('/signup', (req, res) =>{
    const {error, value} = signupSchema.validate({username: req.body.username, email: req.body.email, password: req.body.password});
    if (error) return res.status(400).json({error: error.message});

    const sql1 = `INSERT INTO users (name, email, password) VALUES ('${req.body.username}', '${req.body.email}','${req.body.password}')`;
    con.query(sql1, (err, result) =>{
        if (err) return res.status(400).json({error: err.sqlMessage});
        return res.status(200).json({message: "added", id: result.insertId});
    });
});
//
app.post('/login', (req, res, next)=> {
    const {error, value} = signinSchema.validate({email: req.body.email, password: req.body.password});
    if (error) return res.status(400).json({error: error.message});

    passport.authenticate('local', (err, user, info) => {
      if (err) return next(err); 
      if (!user) return res.json({error: 'not authorized'})
      return res.json({message:'authorized'});
    })(req, res, next);
});


app.get('/', (req, res) =>{
    res.json({message: "Hellow world !!"});
});

app.post('/users', (req, res, next) =>{
    
    passport.authenticate('local', (err, user, info) => {
        if (err) return next(err); 
        if (!user) return res.send('not authorized')
    })(req, res, next);

    const sql1 = `select * from users WHERE name= '${req.body.name}';`;
    con.query(sql1, (err, user) =>{
        if (err) return res.status(404).send("error");
        if(!user[0]) return res.status(404).send("error");
        return res.send(user[0]);
    });   

});



const port = process.env.PORT || 3000 ;
app.listen(port, () => console.log(`listing on port ${port}...`));