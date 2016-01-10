# RapporJS

This is a provisional implementation of Rappor in JavaScript that is designed to handle categorical data

## Setup

0. Download the code
1. Install the npm modules `npm install`
2. Install the bower components `bower install`
3. Start the server `node server.js`
4. Go to `http://localhost:8080/`

## Client Usage

> bools = [true, true, false]
> 
> r = new Rappor()
> r.sendToServer(r.encode(bools))