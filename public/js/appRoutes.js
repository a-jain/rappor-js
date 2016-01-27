// public/js/appRoutes.js
var appRoutesModule = angular.module('appRoutes', []);

appRoutesModule.config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {

    $routeProvider

        // home page
        .when('/', {
            templateUrl: 'partials/home',
            controller: 'MainController'
        })

        // records page that will use the RecordController
        .when('/records', {
            templateUrl: 'partials/record',
            controller: 'RecordController'
        })

        // Send records page that will use the SendReportController
        .when('/send', {
            templateUrl: 'partials/sendReport',
            controller: 'SendReportController'
        });

    $locationProvider.html5Mode(true);

}]);

console.log("appRoutes.js touched");