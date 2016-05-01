# RapporJS

This is a provisional implementation of Google's [RAPPOR](https://github.com/google/rappor) algorithm in JavaScript that is designed to handle categorical data. It should be used in conjuction with [RapporJS](http://rapporjs.com) 

## Setup

Embed the following line of code into a website your respondents will visit

```javascript
<script src="http://cdn.rapporjs.com/rappor.min.js">
```

## Quick Start

After navigating to the [Users](http://rapporjs.com/users) page, you'll generate client-side code like this:

```javascript
r = new Rappor( {publicKey: "generated_from_/users"} );

r.send(some_string {freq: "instant"});
```

which you can use to send data. These two operations - creating a `Rappor` object and calling `send()` on it are the two main ways to customize the behaviour of the client-side code

## API 

### Creating `Rappor` object

Here are 

### Calling `send()`