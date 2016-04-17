// public/js/controllers/RecordCtrl.js
var recordModule = angular.module('RecordCtrl', []);

recordModule.controller('RecordController', function($scope) {

    $scope.k = 16;
    $scope.h = 2;
    $scope.m = 64;
    $scope.p = 0.5;
    $scope.q = 0.75;
    $scope.f = 0.5;

});

console.log("RecordCtrl.js touched");