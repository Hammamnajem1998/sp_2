const { app } = require('../../config/app/app-config/app-config');


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
// handle database disconnecting error
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

// get shop information
app.get('/shop/:id', (req, res) =>{

    const sql1 = `select * from shops WHERE user_id = '${req.params.id}'; `;
    con.query(sql1, (err, shop) =>{
        if (err) return res.status(400).json({error: err.sqlMessage});
        if (!shop[0]) return res.status(200).json({error: 'No shop'});
        return res.send(shop[0]);
    });
  
});

// get all shops
app.get('/shops', (req, res) =>{

    const sql1 = `select * from shops ;`;
    con.query(sql1, (err, shops) =>{
        if (err) return res.status(400).json({error: err.sqlMessage});
        if (!shops[0]) return res.status(200).json({error: 'No shops'});
        return res.json( { message:shops , length:shops.length } );
    });
  
});
//delete all shops
app.delete('/shops', (req, res) =>{

    const sql1 = `delete from shops ;`;
    con.query(sql1, (err, shops) =>{
        if (err) return res.status(400).json({error: err.sqlMessage});
        return res.send(shops);
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

