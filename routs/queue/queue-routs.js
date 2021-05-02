const { app } = require('../../config/app/app-config/app-config');
const { con } = require('../../config/database/database-config/database-config');


// handle database disconnecting error
function handleError() {
    console.log('database lostconnect');
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
        queues_array[req.body.shop_id].push({customerID: 'none'});
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

    if(queues_array[req.params.shop_id].find(customer => customer.customerID === req.params.customer_id)){
        var customerIndex = queues_array[req.params.shop_id].findIndex(customer => customer.customerID === req.params.customer_id);
        queues_array[req.params.shop_id].splice(customerIndex,1);
        res.json({message: 'deleted'});
    }
    else if (queues_array[req.params.shop_id].length == 0){
        res.json({error: 'Empty Queue'});
    }
    else if (queues_array[req.params.shop_id].find(customer => customer.customerID === 'none')) {
        var customerIndex = queues_array[req.params.shop_id].findIndex(customer => customer.customerID === 'none');
        queues_array[req.params.shop_id].splice(customerIndex,1);
        res.json({message: 'shifted'});
    }

    sendNotification(req.params.shop_id);
});
  
// get shop's queue information
app.get('/queue/:id', (req, res) =>{

    if(queues_array[req.params.id] == null) return res.status(404).json({error : 'Empty queue', length : '0'});

    return res.json({message : queues_array[req.params.id], length : queues_array[req.params.id].length });
});

function sendNotification(shopID){
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