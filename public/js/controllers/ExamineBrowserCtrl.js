// public/js/controllers/ExamineBrowserCtrl.js
var examineBrowserModule = angular.module('ExamineBrowserCtrl', []);

examineBrowserModule.controller('ExamineBrowserController', function($scope) {

	$scope.tagline = 'Test various browser configurations here';
	// $scope.template =  "<script src=\"rappor.js\">\n<script src=\"rappor-examine.js\">\n\nr = new window.Rappor()\;\n";
	
});

console.log("ExamineBrowserCtrl.js touched");