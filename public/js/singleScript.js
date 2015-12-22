// create the module and name it rappor-js
var rapporjs = angular.module('rappor-js', ['ngRoute']);

// configure our routes
rapporjs.config(function($routeProvider) {
    $routeProvider

        // route for the home page
        .when('/', {
            templateUrl : 'views/home.html',
            controller  : 'MainController'
        })

        // route for the about page
        .when('/record', {
            templateUrl : 'views/record.html',
            controller  : 'RecordController'
        })
});

// create the controller and inject Angular's $scope
rapporjs.controller('MainController', function($scope) {
    // create a message to display in our view
    $scope.message = 'Everyone come and see how good I look!';
});

rapporjs.controller('RecordController', function($scope) {
    $scope.message = 'Look! I am an about page.';
});