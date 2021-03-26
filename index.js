// for express
const express = require('express');
const app = express();
app.use(express.json());

app.get('/', (req, res) =>{
  res.json({message: "Hellow world !!"});
});


const port = process.env.PORT || 5000 ;
app.listen(port, () => console.log(`listing on port ${port}...`));