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
        })

        // Send records page that will use the SendReportController
        .when('/send/:privateKey', {
            templateUrl: 'partials/sendReport',
            controller: 'SendReportController'
        })

        // Send records page that will use the SendReportController
        .when('/about', {
            templateUrl: 'partials/about',
            controller: 'AboutController'
        })

        // Send records page that will use the SendReportController
        .when('/users', {
            templateUrl: 'partials/examineBrowser',
            controller: 'ExamineBrowserController'
        })

        // Send records page that will use the SendReportController
        .when('/generate', {
            templateUrl: 'partials/generateCSV',
            controller: 'GenerateCSVController'
        })

        // Send records page that will use the SendReportController
        .when('/generate/:privateKey', {
            templateUrl: 'partials/generateCSV',
            controller: 'GenerateCSVController'
        })

        // Send records page that will use the SendReportController
        .when('/analyze', {
            templateUrl: 'partials/analyzeCSV',
            controller: 'AnalyzeCSVController'
        })

        // Send records page that will use the SendReportController
        .when('/analyze/:privateKey', {
            templateUrl: 'partials/analyzeCSV',
            controller: 'AnalyzeCSVController'
        });

    $locationProvider.html5Mode(true);

}]);

console.log("appRoutes.js touched");