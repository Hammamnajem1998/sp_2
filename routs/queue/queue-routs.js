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
 
// for firebase
const { admin } = require('../../config/firebase/firebase-config/admin');

// implement array of queues
var queues_array =[];

// add customer to the shop's queue
app.post('/addToQueue', (req, res) =>{

    if (req.body.isFromOwner === 'true'){
        if (queues_array[req.body.shop_id] == null) queues_array[req.body.shop_id] = new Array();  
        queues_array[req.body.shop_id].push({
            customerID: 'none',
            first_name: req.body.user_name, 
            email : 'Waiting', 
            photo : ''
        });
        res.json( {message : queues_array[req.body.shop_id], length : queues_array[req.body.shop_id].length } );
        sendNotification(req.body.shop_id);
    } else{
        if (queues_array[req.body.shop_id] == null) queues_array[req.body.shop_id] = new Array();

        const sql1 = `select * from users WHERE id = '${req.body.customer_id}'; `;
        con.query(sql1, (err, user) =>{
            if(err) return res.status(404).json({error : err});
            
            queues_array[req.body.shop_id].push({   
                customerID: req.body.customer_id, 
                first_name: user[0].first_name, 
                last_name : user[0].last_name, 
                email : user[0].email, 
                photo : user[0].photo 
            });
            res.json( {message : queues_array[req.body.shop_id], length : queues_array[req.body.shop_id].length } );
            sendNotification(req.body.shop_id);
        });
    }    
}); 

// delete customer from queue
app.delete('/queue/:shop_id/:customer_id', (req, res) =>{

    if (queues_array[req.params.shop_id] == null || queues_array[req.params.shop_id].length == 0) return res.json({error: 'Empty Queue'})
    
    if(queues_array[req.params.shop_id].find(customer => customer.customerID === req.params.customer_id)){
        var customerIndex = queues_array[req.params.shop_id].findIndex(customer => customer.customerID === req.params.customer_id);
        queues_array[req.params.shop_id].splice(customerIndex,1);
        sendNotification(req.params.shop_id);
        return res.json({message: 'deleted'});
    }
    
    return res.json({error: 'somthing wrong happened'});
});
  
// delete queue
app.delete('/queue/:shop_id', (req, res) =>{
    if (queues_array[req.body.shop_id] == null) return res.json({error:'no such a queue'});
    if (queues_array[req.body.shop_id].length ==  0 ) return res.json({error:'already empty'});

    queues_array[req.body.shop_id] = [];
    return res.json({message: 'Queue Deleted'});
});

// get shop's queue information
app.get('/queue/:id', (req, res) =>{

    if(queues_array[req.params.id] == null) return res.status(404).json({error : 'Empty queue', length : '0'});

    return res.json({message : queues_array[req.params.id], length : queues_array[req.params.id].length });
});

function sendNotification(shopID){
    
    console.log('sendNotification');
    var message = {
        data : { shop_id :shopID , queue: JSON.stringify(queues_array[shopID])},
        notification : { title: 'title', body : 'body'},
        topic : 'temp',
    };

    admin.messaging().send(message)
    .then( response => {
        console.log({message :'Notification sent successfully'});
    })
    .catch( error => {
        console.log(error);
        console.log({error: "Notification wasn't sended"});
    });
}