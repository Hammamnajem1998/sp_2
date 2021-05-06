// for express
const {app} = require('./config/app/app-config/app-config');

// for customer routs
require('./routs/customer/customer-routs');

// for shop routs
require('./routs/shop/shop-routs');

// for queue routs
require('./routs/queue/queue-routs');

// for cloud storage routs
require('./routs/cloudStorage/cloudStorage-routs');

app.get('/', (req, res) =>{
    res.json({message: "Hellow world !!"});
}); 