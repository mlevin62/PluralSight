// flightListController.js

(function () {
    "use strict";

    var myModule = angular.module("flights"); // ngRoute is used for NG Routing to get to Views, etc

    //Controller should be used for modifying data only
    myModule.controller("flightListController", ["$scope", "flightData",

    function ($scope, flightData) {

        $scope.ourData = flightData; // Originates in data.js as a return object of flightData factory

        }
    ]);
})();