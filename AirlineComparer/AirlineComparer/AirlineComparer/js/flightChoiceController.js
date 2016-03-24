// flightChoiceController.js

(function () {
    "use strict";
    
    var myModule = angular.module("flights"); 

    //Controller should be used for modifying data only
    myModule.controller("flightChoiceController", ["$scope",
                                                   "flightData",
                                                   "$routeParams", // id passed in url is inside of $routeParams
                                                   "$window",
        function ($scope, flightData, $routeParams,$window) {
            
            $.each(flightData.data.trips, function (t, trip) {
                if (trip.id == $routeParams.id)
                {
                    $scope.ourTrip = trip; // Originates in data.js as a return object of flightData factory
                }
            });

            // $scope.ourData = flightData;  Originates in data.js as a return object of flightData factory

            $scope.pickFlight = function (flight) {
                $.each($scope.ourTrip.flights, function (i, item) { //this is jQuery call
                    item.picked = false;
                });

                flight.picked = true;
                flightData.save();
                $window.location = "#/";
            };
        }
    ]);
})();