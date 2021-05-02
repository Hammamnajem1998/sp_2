const { app } = require('../../config/app/app-config/app-config');

const bodyParser = require('body-parser');
const multer = require('multer');
const uploadImage = require('../../helpers/helpers');

const multerMid = multer({
    storage: multer.memoryStorage(),
    limits: {
      fileSize: 5 * 1024 * 1024,
    },
})

app.disable('x-powered-by');
app.use(multerMid.single('file'));

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

// handle errors
app.use((err, req, res, next) => {
    res.status(500).json({
    error: err,
    message: 'Internal server error!',
  })
    next()
});