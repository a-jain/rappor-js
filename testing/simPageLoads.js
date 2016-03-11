var page = require('webpage').create();
var system = require('system');
var t, address, n;

if (system.args.length === 1) {
  console.log('Specify URL and # of times to run');
  phantom.exit();
}

address = system.args[1];

page.onConsoleMessage = function(msg) {
  console.log(msg);
}

page.open(address, function(status) {
  if (status !== 'success') 
  {
    console.log('FAIL to load the address');
    phantom.exit(0);
  } 
  else {
  	
  }

  phantom.exit(0);
});