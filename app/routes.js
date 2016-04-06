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
        // res.header("Access-Control-Allow-Origin", "*");
        // res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
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
            var record = new Record();

            record.bool   = req.body.bool;
            record.cohort = req.body.cohort;
            record.orig   = req.body.orig;
            record.prr    = req.body.prr;
            record.irr    = req.body.irr;
            record.group  = req.body.group;
            
            record.params = req.body.params;

            // save the record
            record.save(function(err) {
                if (err)
                    res.send(err);

                // Record.sort({ cohort: 'asc' });

                res.json({
                    message: 'Record added successfully'
                });
            });
        })

        // get all records
        .get(function(req, res) {
            Record.find({
                type: "record"
            }, function(err, records) {
                if (err)
                    res.send(err)

                res.json(records);
            })

            .sort({ cohort: 'asc' })
        })

        // delete all records
        .delete(function(req, res) {
            Record.remove({
                type: "record"
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
                _id: req.params.record_id,
                type: "record"
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

            // first retrieve appropriate public key
            Auth.find({
                privateKey: req.params.key,
                type: "auth"
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
                    type: "record"
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
                type: "auth"
            }, function(err, records) {
                if (err)
                    res.send(err)

                res.json(records);
            })

            .sort({ date: 'asc' })
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
                type: "auth"
            }, function(err, record) {
                if (err)
                    res.send(err);

                res.send({ message: 'Successfully deleted everything'});
            });
        });

    router.route('/api/v1/getCSV/:privateKey')

        // NB: POST needs to be called first
        .get(function(req, res) {
            var dirname = __dirname;
            dirname = dirname.split("/");
            dirname.pop();
            dirname = dirname.join("/") + "/server/outputs/";

            console.log("about to send download zip");
            console.log(dirname + req.params.privateKey + ".zip");

            rf(dirname + req.params.privateKey, function(err) {
                if (err) {
                    console.log(err);
                    return res.status(err.statusCode).send("Need to submit form first to create zip file");
                }
            })

            res.download(dirname + req.params.privateKey + ".zip", "csv_files_" + req.params.privateKey + ".zip", function(err) {
                if (err) {
                    console.log(err);
                    return res.status(404).send("Need to submit form first to create zip file");
                }
            });
        })

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

            // create the zipper
            var zip = new AdmZip();
            
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
                    return res.status(404).send("Key not found");
                }

                // console.log(`Start next Python file!`);

                var args2 = [];
                args2.push("map_file.py")
                args2.push(req.params.privateKey)
                args2.push(JSON.stringify(req.body))

                // console.log(args2)

                secondChild = spawn("python", args2, { cwd: dirname });
                zip.addLocalFile(dirname + "outputs/" + req.params.privateKey + "/params.csv")
                zip.addLocalFile(dirname + "outputs/" + req.params.privateKey + "/counts.csv")

                // handle outputs
                secondChild.stdout.on("data", function(data) {
                    console.log(`stdout: ${data}`);
                });

                secondChild.stderr.on("data", function(data) {
                    console.log(`stderr: ${data}`);
                });

                secondChild.on("close", function(data) {
                    if (data) {
                        return res.status(404).send("Map file failed");
                    }
                    // console.log(`Second Python child is done, and returned: ${data}`);
                    // console.log(`Now finalizing zip file`);

                    zip.addLocalFile(dirname + "outputs/" + req.params.privateKey + "/map.csv");
                    zip.writeZip(dirname + "outputs/" + req.params.privateKey + ".zip");

                    return res.sendStatus(200);

                    // console.log(`done!`);
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