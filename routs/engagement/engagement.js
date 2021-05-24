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

// add customer to the engagements array
app.post('/addToEngagement', (req, res) =>{

    if (req.body.isFromOwner === 'true'){
        if (engagement_array[req.body.shop_id] == null) engagement_array[req.body.shop_id] = new Array();  
        engagement_array[req.body.shop_id].push({
            customerID: 'none',
            shopID: req.body.shop_id,
            first_name: req.body.user_name, 
            last_name : ' ',
            email : `Requested a date at ${req.body.hour}:${req.body.minute}`, 
            photo : '',
            status : 'accepted'
        });
        notifyToUpdateEngagementArray(engagement_array[req.body.shop_id][engagement_array[req.body.shop_id].length-1], '2' );// accepted state
        return res.json( {message : engagement_array[req.body.shop_id], length : engagement_array[req.body.shop_id].length } );
    } else{
        if (engagement_array[req.body.shop_id] == null) engagement_array[req.body.shop_id] = new Array();

        const sql1 = `select * from users WHERE id = '${req.body.customer_id}'; `;
        con.query(sql1, (err, user) =>{
            if(err) return res.status(404).json({error : err});
            
            engagement_array[req.body.shop_id].push({   
                customerID: req.body.customer_id,
                shopID: req.body.shop_id, 
                first_name: user[0].first_name, 
                last_name : user[0].last_name, 
                email : `Requested a date at ${req.body.hour}:${req.body.minute}`, 
                photo : user[0].photo,
                status : 'processing' 
            });            
            notifyToUpdateEngagementArray(engagement_array[req.body.shop_id][engagement_array[req.body.shop_id].length-1], '1' );// processing state   
            return res.json( {message : engagement_array[req.body.shop_id], length : engagement_array[req.body.shop_id].length } );
        });
    }    
}); 

// accept request
app.get('/engagement/accept/:shop_id/:customer_id', (req, res) =>{

    if (engagement_array[req.params.shop_id] == null || engagement_array[req.params.shop_id].length == 0) return res.json({error: 'Empty Queue'});
    
    if(engagement_array[req.params.shop_id].find(customer => customer.customerID === req.params.customer_id)){
        var customerIndex = engagement_array[req.params.shop_id].findIndex(customer => customer.customerID === req.params.customer_id);
        engagement_array[req.params.shop_id][customerIndex].status = 'accepted' ;
        notifyAccept(engagement_array[req.params.shop_id][customerIndex]);// accepted state
        return res.json({message: engagement_array[req.params.shop_id][customerIndex]});
    }
    
    return res.json({error: 'somthing wrong happened'});
});

// reject request
app.get('/engagement/reject/:shop_id/:customer_id', (req, res) =>{

    if (engagement_array[req.params.shop_id] == null || engagement_array[req.params.shop_id].length == 0) return res.json({error: 'Empty Queue'});
    
    if(engagement_array[req.params.shop_id].find(customer => customer.customerID === req.params.customer_id)){
        var customerIndex = engagement_array[req.params.shop_id].findIndex(customer => customer.customerID === req.params.customer_id);
        engagement_array[req.params.shop_id][customerIndex].status = 'rejected' ;
        notifyreject(engagement_array[req.params.shop_id][customerIndex]); // rejected state
        return res.json({message: engagement_array[req.params.shop_id][customerIndex]});
    }
    
    return res.json({error: 'somthing wrong happened'});
});


// delete request from engagement array
app.delete('/engagement/:shop_id/:customer_id', (req, res) =>{

    if (engagement_array[req.params.shop_id] == null || engagement_array[req.params.shop_id].length == 0) 
        return res.json({error: 'Empty Queue'});
    
    if(engagement_array[req.params.shop_id].find(customer => customer.customerID === req.params.customer_id)){
        foundedEngagement = engagement_array[req.params.shop_id].find(customer => customer.customerID === req.params.customer_id)
        notifyToUpdateEngagementArray(foundedEngagement, '0');// 0 idel state
        var customerIndex = engagement_array[req.params.shop_id].findIndex(customer => customer.customerID === req.params.customer_id);
        engagement_array[req.params.shop_id].splice(customerIndex,1);
        return res.json({message: 'deleted'});
    }
    
    return res.json({error: 'somthing wrong happened'});
});
  
// delete engagement array
app.delete('/engagement/:shop_id', (req, res) =>{
    if (engagement_array[req.params.shop_id] == null) return res.json({error:'no such an array'});
    if (engagement_array[req.params.shop_id].length ==  0 ) return res.json({error:'already empty'});
    engagement_array[req.params.shop_id] = null;
    return res.json({message: 'Engagement Queue Deleted'});
});

// get date request's array 
app.get('/engagement/:id', (req, res) =>{
    if(engagement_array[req.params.id] == null) return res.status(404).json({error : 'Empty array', length : '0'});
    return res.json({message : engagement_array[req.params.id], length : engagement_array[req.params.id].length });
});


function notifyAccept(engagement){
    
    var message = {
        data : { shop_id :engagement.shopID, customer_id: engagement.customerID, state: '2' }, // accepted state
        notification : { title: 'Accepted', body : 'your engaged date was accepted'},
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

function notifyreject(engagement){
    var message = {
        data : { shop_id :engagement.shopID, customer_id: engagement.customerID, state: '3' }, // rejected state
        notification : { title: 'rejected', body : 'your engaged date was rejected'},
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

function notifyToUpdateEngagementArray(engagement, state){
    
    var message = {
        data : { shop_id :engagement.shopID.toString(), customer_id: engagement.customerID.toString(), state: state }, // rejected state
        notification : { title: 'New date request', body : 'Take a look !!'},
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
