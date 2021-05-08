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

// implement array of engagements
var engagement_array =[];

// add customer to the shop's queue
app.post('/addToEngagement', (req, res) =>{

    if (req.body.isFromOwner === 'true'){
        if (engagement_array[req.body.shop_id] == null) engagement_array[req.body.shop_id] = new Array();  
        engagement_array[req.body.shop_id].push({
            customerID: 'none',
            first_name: req.body.user_name, 
            last_name : ' ',
            email : `Requested a date at ${req.body.hour}:${req.body.minute}`, 
            photo : ''
        });
        notifyToUpdateQueue(req.body.shop_id);
        res.json( {message : engagement_array[req.body.shop_id], length : engagement_array[req.body.shop_id].length } );
    } else{
        if (engagement_array[req.body.shop_id] == null) engagement_array[req.body.shop_id] = new Array();

        const sql1 = `select * from users WHERE id = '${req.body.customer_id}'; `;
        con.query(sql1, (err, user) =>{
            if(err) return res.status(404).json({error : err});
            
            engagement_array[req.body.shop_id].push({   
                customerID: req.body.customer_id, 
                first_name: user[0].first_name, 
                last_name : user[0].last_name, 
                email : `Requested a date at ${req.body.hour}:${req.body.minute}`, 
                photo : user[0].photo 
            });
            notifyToUpdateQueue(req.body.shop_id);
            res.json( {message : engagement_array[req.body.shop_id], length : engagement_array[req.body.shop_id].length } );
        });
    }    
}); 

// delete customer from queue
app.delete('/engagement/:shop_id/:customer_id', (req, res) =>{

    if (engagement_array[req.params.shop_id] == null || engagement_array[req.params.shop_id].length == 0) return res.json({error: 'Empty Queue'});
    
    if(engagement_array[req.params.shop_id].find(customer => customer.customerID === req.params.customer_id)){
        var customerIndex = engagement_array[req.params.shop_id].findIndex(customer => customer.customerID === req.params.customer_id);
        engagement_array[req.params.shop_id].splice(customerIndex,1);
        notifyToUpdateQueue(req.params.shop_id);
        return res.json({message: 'deleted'});
    }
    
    return res.json({error: 'somthing wrong happened'});
});
  
// delete queue
app.delete('/engagement/:shop_id', (req, res) =>{
    if (engagement_array[req.params.shop_id] == null) return res.json({error:'no such a queue'});
    if (engagement_array[req.params.shop_id].length ==  0 ) return res.json({error:'already empty'});

    engagement_array[req.params.shop_id] = null;
    return res.json({message: 'Engagement Queue Deleted'});
});

// get shop's queue information
app.get('/engagement/:id', (req, res) =>{

    if(engagement_array[req.params.id] == null) return res.status(404).json({error : 'Empty queue', length : '0'});

    return res.json({message : engagement_array[req.params.id], length : engagement_array[req.params.id].length });
});


function notifyToUpdateQueue(shopID){
    
    var message = {
        data : { shop_id :shopID },
        notification : { title: 'Prepare your self', body : 'your turn are very close'},
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