// public/js/controllers/RecordCtrl.js
var recordModule = angular.module('RecordCtrl', []);

recordModule.controller('RecordController', function($scope) {

    $scope.tagline = 'Enter the record here';

});

console.log("RecordCtrl.js touched");