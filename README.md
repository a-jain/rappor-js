# RapporJS

This is a provisional implementation of Google's [RAPPOR](https://github.com/google/rappor) algorithm in JavaScript that is designed to handle categorical data. It should be used in conjuction with [RapporJS](http://rapporjs.com) 

## Setup

Embed the following line of code into a website your respondents will visit

```JavaScript
<script src="http://cdn.rapporjs.com/rappor.min.js">
```

## Quick Start

After navigating to the [Users](http://rapporjs.com/users) page, you'll generate client-side code like this:

```JavaScript
r = new Rappor( {publicKey: "generated_from_/users"} );

r.send(some_string, {freq: "instant"});
```

which you can use to send data. These two operations - creating a `Rappor` object and calling `send()` on it - are the two main ways to call (and customize) the client-side code. Different options are given in the API section below

## API 

### Creating a `Rappor` object

Generally, all options below are in the format:

```JavaScript
r = new Rappor( {option1: value1, option2: value2, ...} );
```

Below, for each option I supply the name and the value to change it

**Parameters**

By default, Rappor uses these parameters (for reasons given in thesis.pdf):

```JavaScript
default_params = {k: 32, h:2, p:0.1, q:0.8, f:0.81, m:128, server:"http://rappor-js.herokuapp.com/api/v1/records"};
```

To change specific parameters, supply them in the same format. For example, to change `m` to 64 and `server` to "http://url_of_your_choice.com" (and keep everything else as in `default_params`), add the `params` option below to the instantion of a `Rappor` object:

```JavaScript
params = {m: 64, server="http://url_of_your_choice.com"}
r = new Rappor( {params: params} );
```

**publicKey**

If you're using your own server, then you can also specify your own publicKey (default is the empty string):

```JavaScript
params = {m: 64, server="http://url_of_your_choice.com"};
pK = "my_special_key";
r = new Rappor( {params: params, publicKey: pK} );
```

### Calling `send()`

`send()` provides further option choices, and will result in a JSON object being sent via a POST request to the server specified in the `Rappor()` instantiation:

```JSON
example = {
	cohort: <cohort>
	irr: "010010101" etc
	params: {k: 32, h:2, p:0.1, q:0.8, f:0.81, m:128, server:"http://rappor-js.herokuapp.com/api/v1/records"}
	group: <publicKey>
}

```

**Frequency**

To send a report whenever a client lands on a page, set `freq` to "instant". To send a report at most hourly, set `freq` to "hourly", and so on for "daily", "weekly", and "monthly". For example, to send the string "dog" daily,

```JavaScript
r = new Rappor();
r.send("dog", {freq: "daily"} )
```

**Number of Reports**

To send a report multiple times, you can set a parameter `n` appropriately (don't call `send()` lots of times because it is asynchronous). For example, to send "dog" 10 times,

```JavaScript
r = new Rappor();
r.send("dog", {n: 10} )
```

Note: this should only be used for testing purposes - sending the same report multiple times from the same client can degrade the privacy guarantees

**Callback**

You can specify an optional callback function when `send()` has finished. For example, to alert the user after "dog" has been sent 10 times:

```JavaScript
var callback = function() { alert("done!"); };

r = new Rappor();
r.send("dog", {n:10, callback: callback} );
```

### Other Stuff

In some cases, it can be useful to be able to call `send()` without any arguments (e.g. when it's a callback to a different function). For these situations, you can use:

```JavaScript
r = new Rappor();
r.sendTrue();
r.sendFalse();
```

Which will send "true" and "false" respectively with the same options as `send()` has.
