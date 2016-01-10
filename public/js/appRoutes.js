// public/js/appRoutes.js
var appRoutesModule = angular.module('appRoutes', []);

appRoutesModule.config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {

    $routeProvider

        // home page
        .when('/', {
            templateUrl: 'partials/home',
            controller: 'MainController'
        })

        // records page that will use the NerdController
        .when('/records', {
            templateUrl: 'partials/record',
            controller: 'RecordController'
        });

    $locationProvider.html5Mode(true);

}]);

console.log("appRoutes.js touched");