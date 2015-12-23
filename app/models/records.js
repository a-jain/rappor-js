// grab the mongoose module
var mongoose = require('mongoose');
var Schema = mongoose.Schema;

// define our shema
var recordSchema = new Schema({
  cohort:  Number,
  bitString: Number
  // params: {
  // 	k: Number,
  // 	h: Number,
  // 	m: Number,
  // 	f: Number,
  // 	p: Number,
  // 	q: Number
  // }
});

// define our records model
// module.exports allows us to pass this to other files when it is called
module.exports = mongoose.model('Record', recordSchema);