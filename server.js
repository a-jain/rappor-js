// server.js

// modules =================================================
var newrelic       = require('newrelic');
var express        = require('express');
var app            = express();
var bodyParser     = require('body-parser');
var methodOverride = require('method-override');
var stylus		   = require('stylus');
var nib		       = require('nib');
var mongoose       = require('mongoose');
var cors           = require('cors');
var compression    = require('compression');

// configuration ===========================================
    
// config files
var db = require('./config/db');

// set our port
var port = process.env.PORT || 8080; 

// for stylus
function compile(str, pathx) {
  return stylus(str)
    .set('filename', pathx)
    .use(nib())
}
app.use(stylus.middleware({ 
	src: __dirname + '/public',
	compile: compile
}))

// allow CORS requests FOR NOW
app.options('*', cors())
// app.use(cors())

// add gzip compression
app.use(compression())

// connect to our mongoDB database 
// (uncomment after you enter in your own credentials in config/db.js)
mongoose.connect(db.url)

// bodyParser gets all data/stuff of the body (POST) parameters
// parse application/json 
// parse application/vnd.api+json as json
// parse application/x-www-form-urlencoded
app.use(bodyParser.json()); 
app.use(bodyParser.json({ limit: '100mb', type: 'application/vnd.api+json', parameterLimit: 10000}));
app.use(bodyParser.urlencoded({ limit: '100mb', extended: true, parameterLimit: 10000 })); 

// use Jade
app.set('view engine', 'jade');
app.set('view options', { layout: false, pretty: true });

app.enable('view cache');

app.set('views', __dirname + '/public/views')

// override with the X-HTTP-Method-Override header in the request. simulate DELETE/PUT
app.use(methodOverride('X-HTTP-Method-Override')); 

// set the static files location /public/img will be /img for users
app.use(express.static(__dirname + '/public')); 

// app.locals({ CDN: CDN() });
// app.locals.CDN = CDN();

// routes ==================================================
require('./app/routes')(app); // configure our routes

// start app ===============================================
// startup our app at http://localhost:8080
app.listen(port);               

// shoutout to the user                     
console.log('Magic happens on port ' + port);

// expose app           
exports = module.exports = app;  