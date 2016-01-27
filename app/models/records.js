// grab the mongoose module
var mongoose = require('mongoose');
var Schema = mongoose.Schema;

// define our schema
var recordSchema = new Schema({
  bool:  Number,
  cohort:  Number,
  orig: String,
  prr: String,
  irr: String,
  params: {
  	bigEndian: Boolean,
    k: Number,
  	h: Number,
  	m: Number,
  	p: Number,
  	q: Number,
    f: Number,
    secret: String,
    server: String
  }
});

// define our records model
// module.exports allows us to pass this to other files when it is called
module.exports = mongoose.model('Record', recordSchema);