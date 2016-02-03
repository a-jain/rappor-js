// grab the mongoose module
var mongoose = require('mongoose');
var Schema = mongoose.Schema;

// define our schema
var recordSchema = new Schema({
  bool:  { type: Boolean },
  cohort:  Number,
  date:  { type: Date, default: Date.now },
  orig:  { type: String, trim: true, default: "mongoose error" },
  prr:  { type: String, trim: true, default: "mongoose error" },
  irr:  { type: String, trim: true, default: "mongoose error" },
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

recordSchema.index({cohort: 1});

// define our records model
// module.exports allows us to pass this to other files when it is called
module.exports = mongoose.model('Record', recordSchema);