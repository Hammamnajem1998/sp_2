var admin = require('firebase-admin');
var serviceAccount = require("../keys/firebase_key.json");
const { app } = require('../../app/app-config/app-config');

const bodyparser = require('body-parser');

app.use(bodyparser.json());

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

module.exports.admin = admin;