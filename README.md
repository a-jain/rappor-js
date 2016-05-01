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

To change specific parameters, supply them in the same format. For example, to change `m` to 64 and `server` to "http://url_of_your_choice.com", add the `params` option below to the instantion of a `Rappor` object:

```JavaScript
params = {m: 64, server="http://url_of_your_choice.com"}
```

### Calling `send()`