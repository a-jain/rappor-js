# RapporJS

This is a provisional implementation of Rappor in JavaScript that is designed to handle categorical data

## Setup

0. Download the code
1. Install the npm modules `npm install`
2. Install the bower components `bower install`
3. Start the server `node server.js`
4. Go to `http://localhost:8080/`

## Client Usage

If you have some array of true/false values, e.g.

> bools = [true, true, false]

Then you can sent it to the server like so: 

> r = new Rappor()
> 
> r.sendToServer(r.encode(bools))