// public/js/services/RecordService.js
var recordService = angular.module('RecordService', []);

recordService.factory('Record', ['$http', function($http) {

    return {
        // call to get all Records
        get : function() {
            return $http.get('/api/records');
        },

        // these will work when more API routes are defined on the Node side of things
        // call to POST and create a new Record
        create : function(RecordData) {
            return $http.post('/api/records', RecordData);
        },

        // call to DELETE a Record
        delete : function(id) {
            return $http.delete('/api/records/' + id);
        }
    }       

}]);