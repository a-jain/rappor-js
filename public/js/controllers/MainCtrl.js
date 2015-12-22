// public/js/controllers/MainCtrl.js
var mainModule = angular.module('MainCtrl', []);

mainModule.controller('MainController', function($scope) {

    $scope.tagline = 'To the moon and back!';   

});

console.log("MainCtrl.js touched");