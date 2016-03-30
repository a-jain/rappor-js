// grab the mongoose module
var mongoose = require('mongoose');
var Schema = mongoose.Schema;

// define our schema
var authSchema = new Schema({
  date:  { type: Date, default: Date.now },
  publicKey:  { type: String, trim: true, default: "mongoose error" },
  privateKey:  { type: String, trim: true, default: "mongoose error" },
  type: { type: String, default: "auth" }
});

authSchema.index({date: 1});

// define our records model
// module.exports allows us to pass this to other files when it is called
module.exports = mongoose.model('Auth', authSchema);