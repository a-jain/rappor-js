// public/js/controllers/RecordCtrl.js
var recordModule = angular.module('RecordCtrl', []);

recordModule.controller('RecordController', function($scope) {

    $scope.tagline = 'Nothing beats a pocket protector!';

});

console.log("RecordCtrl.js touched");