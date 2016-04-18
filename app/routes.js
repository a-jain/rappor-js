// grab the record model we just created
var Record = require('./models/records');
var Auth   = require('./models/auths');

var md5    = require('md5');
var spawn  = require('child_process').spawn;
var AdmZip = require('adm-zip')
var rf     = require('rimraf')

module.exports = function(router) {

    // server routes ===========================================================
    // handle things like api calls
    // authentication routes

    // middleware to use for all requests
    router.use(function(req, res, next) {
        // do logging
        console.log('Something is happening.');
        // accept any headers
        res.header("Access-Control-Allow-Origin", "*");
        res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
        next(); // make sure we go to the next routes and don't stop here
    });

    // basic test to start:
    router.get('/api/v1/', function(req, res) {
        res.json({
            message: 'First test'
        })
    })

    // API routes ==============================================================

    // route to handle records
    // insert a record
    router.route('/api/v1/records')

        .post(function(req, res) {

            // console.log(req.body);
            var data = req.body;
            var allDocs = [];

            for (var key in data) {
                if (data.hasOwnProperty(key)) {
                    // console.log(data[key]);

                    var record = new Record();

                    record.bool   = data[key].bool;
                    record.cohort = data[key].cohort;
                    record.orig   = data[key].orig;
                    record.prr    = data[key].prr;
                    record.irr    = data[key].irr;
                    record.group  = data[key].group;
                    
                    record.params = data[key].params;

                    allDocs.push(record);
                }
            }

            // console.log(allDocs);

            Record.create(allDocs, function(err, records) {
                if (err)
                    res.send(err);

                res.json({
                    message: "" + records.length + ' records added successfully!'
                });
            })

            // save the record
            // record.save(function(err) {
            //     if (err)
            //         res.send(err);

            //     // Record.sort({ cohort: 'asc' });

            //     res.json({
            //         message: 'Record added successfully'
            //     });
            // });
        })

        // get all records
        .get(function(req, res) {
            Record.find({
                
            }, function(err, records) {
                if (err)
                    res.send(err)

                res.json(records);
            })

            .sort({ date: 'desc' })
        })

        // delete all records
        .delete(function(req, res) {
            Record.remove({
                
            }, function(err, record) {
                if (err)
                    res.send(err);

                res.send({ message: 'Successfully deleted everything'});
            });
        });

    router.route('/api/v1/records/:record_id')

        // get a specific record
        .get(function(req, res) {
            Record.findById(req.params.record_id, function(err, record) {
                if (err)
                    res.send(err);

                res.json(record);
            });
        })

        // update a specific record
        .put(function(req, res) {
            Record.findById(req.params.record_id, function(err, record) {
                if (err)
                    res.send(err);

                record.cohort = req.body.cohort;
                record.bitString = req.body.bitString;

                record.save(function(err) {
                    if (err)
                        res.send(err);

                    res.json({ message: 'Record updated' });
                });
                
            });
        })

        // delete a specific record
        .delete(function(req, res) {
            Record.remove({
                _id: req.params.record_id
            }, function(err, record) {
                if (err)
                    res.send(err);

                res.send({ message: 'Successfully deleted'});
            });
        });

    // routes to handle credentials go here
    router.route('/api/v1/records/credentials/:key')

        // get all records using a given *private* key
        .get(function(req, res) {

            var pubKey = "x";
            console.log(req.params.key);

            var d1 = null;
            var d2 = null;

            if (req.query.from != null && req.query.to != null) {
                d1 = new Date(req.query.from);
                d2 = new Date(req.query.to);
            } else {
                d1 = new Date("2016-01-01");
                d2 = new Date();
            }

            // make sure d2 represents end of day, not beginning which is native
            d2.setDate(d2.getDate() + 1);

            // add time zone offsets of local area
            d1.setMinutes(d1.getMinutes() + d1.getTimezoneOffset());
            d2.setMinutes(d2.getMinutes() + d2.getTimezoneOffset());

            // console.log(d1.toISOString());
            // console.log(d2.toISOString());

            // first retrieve appropriate public key
            Auth.find({
                privateKey: req.params.key
            }, function(err, auth) {
                if (err) {
                    res.send(err);
                    return;
                }

                if (typeof auth === undefined || auth.length == 0) {
                    res.send("Private key not found. Make sure you\'re not using the public key!");
                    return;
                }

                // console.log(auth)
                pubKey = auth[0].publicKey;
                // console.log(pubKey)

                // now get all records corresponding to public key
                Record.find({
                    group: pubKey,
                    date: { $gte: d1, $lte: d2 }
                }, function(err, records) {
                    if (err) {
                        res.send(err);
                        return;
                    }

                    res.json(records);
                });
            });
        });

    // route to create new credentials goes here:
    router.route('/api/v1/credentials')

        // get all auths
        .get(function(req, res) {
            Auth.find({
               
            }, function(err, records) {
                if (err)
                    res.send(err)

                res.json(records);
            })

            .sort({ date: 'desc' })
        })

        // create a specific auth
        .post(function(req, res) {

            var auth = new Auth();
            
            auth.publicKey    = md5(Math.random().toString()).substring(0,12);
            auth.privateKey   = md5(Math.random().toString()).substring(0,12);

            auth.save(function(err) {
                if (err)
                    res.send(err);

                res.json({
                    message: 'Keys saved successfully',
                    privateKey: auth.privateKey,
                    publicKey: auth.publicKey
                });
            });
        })

        // delete all auths
        .delete(function(req, res) {
            Auth.remove({
                
            }, function(err, record) {
                if (err)
                    res.send(err);

                res.send({ message: 'Successfully deleted everything'});
            });
        });

    router.route('/api/v1/getCSV/:privateKey')

        .post(function(req, res) {

            // first get app root directory
            var dirname = __dirname;
            dirname = dirname.split("/");
            dirname.pop();
            dirname = dirname.join("/") + "/server/";

            // create args array
            var args = [];
            args.push("mySumBits.py");
            args.push(req.params.privateKey);

            // console.log(req.query);

            if (req.query.from != null && req.query.to != null) {
                args.push(req.query.from);
                args.push(req.query.to);
            }

            console.log(args);

            // create child process for counts file
            var child = spawn("python", args, { cwd: dirname });

            // handle outputs
            child.stdout.on("data", function(data) {
                console.log(`stdout: ${data}`);
            });

            child.stderr.on("data", function(data) {
                console.log(`stderr: ${data}`);
            });

            child.on("close", function(data) {
                console.log(`Python child is done, and returned: ${data}`);

                if (data || data == 1) {
                    return res.status(400).send("Key not found");
                }

                var args2 = [];
                args2.push("map_file.py")
                args2.push(req.params.privateKey)
                args2.push(JSON.stringify(req.body))

                secondChild = spawn("python", args2, { cwd: dirname });

                // handle outputs
                secondChild.stdout.on("data", function(data) {
                    console.log(`stdout: ${data}`);
                });

                secondChild.stderr.on("data", function(data) {
                    console.log(`stderr: ${data}`);
                });

                secondChild.on("close", function(err) {
                    if (err) {
                        return res.status(400).send("Map file failed");
                    }
                    return res.sendStatus(200);
                });
            });
        });

    // NB: filename not appended with csv!
    router.route('/api/v1/getCSV/:privateKey/:filename')

        // NB: POST needs to be called first
        .get(function(req, res) {
            var dirname = __dirname;
            dirname = dirname.split("/");
            dirname.pop();
            dirname.push("server");
            dirname.push("outputs");
            dirname.push(req.params.privateKey);
            dirname.push(req.params.filename + ".csv");
            dirname = dirname.join("/");

            console.log("about to send " + req.params.privateKey + ".csv");

            res.download(dirname, req.params.filename + ".csv", function(err) {
                if (err) {
                    console.log(err);
                    return res.status(404).send("CSV file not found");
                }
            });
        });

    // frontend routes =========================================================
    // route to handle all angular requests
    // note order is important
    router.get('/partials/*', function(req, res, next) {
        res.render('.' + req.path);
    });


    router.get('*', function(req, res) {
        res.render('index', {
            title: 'RapporJS'
        })
    });

};