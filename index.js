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

// for mySQL
const mysql = require('mysql');
// for mysql local
// var con = mysql.createConnection({
//     host: "localhost",
//     user: "root",
//     password: "root",
//     database: "temp_schema"
// });

// for mysql heroku database (cloud)
var con = mysql.createConnection({
    host: "us-cdbr-east-03.cleardb.com",
    user: "bca894223fa92f",
    password: "bd33beab",
    database: "heroku_5dbb5278d6f4a3f"
});
// for cloud storage 

const bodyParser = require('body-parser')
const multer = require('multer')
const uploadImage = require('./helpers/helpers')

const multerMid = multer({
    storage: multer.memoryStorage(),
    limits: {
      fileSize: 5 * 1024 * 1024,
    },
})

app.disable('x-powered-by')
app.use(multerMid.single('file'))
app.use(express.json())
app.use(express.urlencoded({extended: false}))


// function handleDisconnect(con) {
//     con.on('error', err =>{
//         if(err.code === 'PROTOCOL_CONNECTION_LOST'){
//             console.log("errrorryyyyyy");
//             con = mysql.createConnection({
//                 host: "us-cdbr-east-03.cleardb.com",
//                 user: "bca894223fa92f",
//                 password: "bd33beab",
//                 database: "heroku_5dbb5278d6f4a3f"
//             });
            
//         }
//         else {
//             throw err;
//         }
//     });
// }
// handleDisconnect(con);

function handleError() {
    con.on('error', err =>{
        if(err.code === 'PROTOCOL_CONNECTION_LOST'){
            con = mysql.createConnection({
                host: "us-cdbr-east-03.cleardb.com",
                user: "bca894223fa92f",
                password: "bd33beab",
                database: "heroku_5dbb5278d6f4a3f"
            });
            
            handleError();
        }
        else {
            throw err;
        }
    });
};

handleError();


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
    const {error, value} = signupSchema.validate({username: req.body.first_name, email: req.body.email, password: req.body.password});
    if (error) return res.status(400).json({error: error.message});

    const sql1 = `INSERT INTO users (first_name, last_name, email, password, location) 
    VALUES ('${req.body.first_name}', '${req.body.last_name}', '${req.body.email}','${req.body.password}', 
    ST_GeomFromText('POINT(${req.body.location.latitude} ${req.body.location.longitude})') );`;
    
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
      return res.json({message: user});
    })(req, res, next);
});


app.get('/', (req, res) =>{
    res.json({message: "Hellow world !!"});
});

// get user information
app.get('/user/:email', (req, res) =>{

  const sql1 = `select * from users WHERE email = '${req.params.email}'; `;
  con.query(sql1, (err, user) =>{
      return res.send(user[0]);
  });

});


// get shop information
app.get('/shop/:id', (req, res) =>{

    const sql1 = `select * from shops WHERE user_id = '${req.params.id}'; `;
    con.query(sql1, (err, shop) =>{
        return res.send(shop[0]);
    });
  
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

// update user information
app.post('/update', (req, res) =>{

    var sql1 = ``;
    if(req.body.firstName != null){
        sql1 = `UPDATE users SET first_name = '${req.body.firstName}' WHERE email = '${req.body.email}';`;
    }
    else if(req.body.lastName != null){
        sql1 = `UPDATE users SET last_name = '${req.body.lastName}' WHERE email = '${req.body.email}';`;
    }
    else if(req.body.password != null){
        sql1 = `UPDATE users SET password = '${req.body.password}' WHERE email = '${req.body.email}';`;
    }

    con.query(sql1, (err, result) =>{
        if (err) return res.status(400).json({error: err.sqlMessage});
        return res.status(200).json({message: "updated", result: result});
    });
});

// update  user image
app.post('/image', (req, res) =>{
    if(req.body.url == null || req.body.email == null ) return res.status(400).json({error: 'bad request'});

    var sql1 = `UPDATE users SET photo = '${req.body.url}' WHERE email = '${req.body.email}';`;
    con.query(sql1, (err, result) =>{
        if (err) return res.status(400).json({error: err.sqlMessage});
        return res.status(200).json({message: "updated", result: result});
    });
});

// update shop image
app.post('/shopImage', (req, res) =>{
    if(req.body.url == null || req.body.id == null ) return res.status(400).json({error: 'bad request'});

    var sql1 = `UPDATE shops SET photo = '${req.body.url}' WHERE user_id = '${req.body.id}';`;
    con.query(sql1, (err, result) =>{
        if (err) return res.status(400).json({error: err.sqlMessage});
        return res.status(200).json({message: "updated", result: result});
    });
});

// upload image to Google Cloud 
app.post('/uploads', async (req, res, next) => {

    console.log(req);
    try {
      const myFile = req.file;
      const email = JSON.parse(JSON.stringify(req.body)).email; 
      const imageUrl = await uploadImage(myFile);
      const sql1 = `UPDATE users SET photo = '${imageUrl}' WHERE email = '${email}';`;
      con.query(sql1);
    
      res.status(200).json({message: "Upload was successful",data: imageUrl});
    } catch (error) {
      next(error);
    }
});

// add Shop 
app.post('/addShop', (req, res) =>{

    const sql1 = `INSERT INTO shops (name, type, time_unit, open_at, close_at, user_id, location) 
    VALUES ('${req.body.name}', '${req.body.type}', '${req.body.time_unit}', '${req.body.open_at}', '${req.body.close_at}', '${req.body.user_id}', 
    ST_GeomFromText('POINT(${req.body.location.latitude} ${req.body.location.longitude})') );`;
    
    con.query(sql1, (err, shop) =>{
        if (err) return res.status(400).json({error: err.sqlMessage});
        return res.status(200).json({message: shop});
    });
});


app.use((err, req, res, next) => {
  res.status(500).json({
  error: err,
  message: 'Internal server error!',
})
  next()
});
  

const port = process.env.PORT || 3000 ;
app.listen(port,() => console.log(`listing on port ${port}...`));