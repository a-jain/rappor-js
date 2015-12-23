// grab the nerd model we just created
var Record = require('./models/records');

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
            var record = new Record();

            record.cohort = req.body.cohort;
            record.bitString = req.body.bitString;
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
            Record.find(function(err, records) {
                if (err)
                    res.send(err)

                res.json(records);
            })

            .sort({ cohort: 'asc' })
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

    // routes to handle cohorts go here
    router.route('/api/v1/cohort/:cohort_no')

        // get all records in a given cohort
        .get(function(req, res) {
            Record.find({
                cohort: req.params.cohort_no
            }, function(err, record) {
                if (err)
                    res.send(err);

                res.json(record);
            });
        })

        // delete all records in a given cohort
        .delete(function(req, res) {
            Record.remove({
                cohort: req.params.cohort_no
            }, function(err, record) {
                if (err)
                    res.send(err);

                res.send({ message: 'Successfully deleted cohort'});
            });
        });

    // route to handle delete goes here (router.delete)

    // frontend routes =========================================================
    // route to handle all angular requests
    router.get('*', function(req, res) {
        res.render('index', {
            title: 'Akash Jain'
        })
    });

};