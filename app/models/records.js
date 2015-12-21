// grab the mongoose module
var mongoose = require('mongoose');
var Schema = mongoose.Schema;

// define our shema
var recordSchema = new Schema({
  cohort:  Number,
  bitString: String
});

// define our records model
// module.exports allows us to pass this to other files when it is called
module.exports = mongoose.model('Records', recordSchema);