(function () {
    "use strict";

    // Step 1. Create moduler (myModule)
    // Step 2. Based on module create Controller (myModule.Controller)
   
    var data = {
        flights:
        [{
            startTime: "8:20am",
            cost: 483.25,
            airtline: "United",
            date: "2013/5/12",
            description: "SEA-ATL-NYC",
            legs: [{
                departureTime: "8:30am",
                arrivalTime: "12:20pm",
                departureCity: "SEA",
                arrivalCity: "ATL"
            }, {
                departureTime: "1:30pm",
                arrivalTime: "4:20pm",
                departureCity: "ATL",
                arrivalCity: "NYC"
            }]
        },
        {
            startTime: "6:10am",
            cost: 285.25,
            airtline: "United",
            date: "2013/5/12",
            description: "SEA-NYC",
            legs: [{
                departureTime: "6:30am",
                arrivalTime: "1:20pm",
                departureCity: "SEA",
                arrivalCity: "NYC"
            }]
        }]
    };

    var myModule = angular.module("flights", ["ngRoute"]); // ngRoute is used for NG Routing to get to Views, etc  

    myModule.config(
        function ($locationProvider, $routeProvider) {
            $routeProvider.when("/", {
                controller: "flightListController",
                templateUrl: "/templates/flightList.html"
            });
            $routeProvider.when("/flight/:id", {
                controller: "flightChoiceController",
                templateUrl: "/templates/flightChoice.html"
            });
            //TODO Fix this later
            //$routeProvider.otherwise({ redirect: "#/"  });
        }
    );

    //Controller should be used for modifying data only
    myModule.controller("flightChoiceController", ["$scope",
        function ($scope) {
            $scope.ourData = data;

            $scope.pickFlight = function (flight) {
                $.each(data.flights, function (i, item) { //this is jQuery call
                    item.picked = false;
                });

                flight.picked = true;
            };
        }
    ]);
    
    // Use factory to store data so it can be shared by other Controllers
    // Below factory is called once and then cached

    myModule.factory("flightData", function () {
        
        var FILE_NAME = "FlightDataKey";
        var _data = null;

        if (amplify.storage(FILE_NAME)) // Amplify is local js storage data placeholder
        {
            _data = amplify.storage(FILE_NAME);
        }
        else
        {
            _data = {
                trips: [{ // Object
                    id: 1,
                    description: "Some Conference",
                    targetStart: "April 1",
                    targetEnd: "May 1",
                    flights: //Object within trips object
                    [{
                        startTime: "8:20am",
                        cost: 483.25,
                        airtline: "United",
                        date: "2013/5/12",
                        legs: [{
                            departureTime: "8:30am",
                            arrivalTime: "12:20pm",
                            departureCity: "SEA",
                            arrivalCity: "ATL"
                        }, {
                            departureTime: "1:30pm",
                            arrivalTime: "4:20pm",
                            departureCity: "ATL",
                            arrivalCity: "NYC"
                        }]
                    },
                    {
                        startTime: "6:10am",
                        cost: 285.25,
                        airtline: "United",
                        date: "2013/5/12",
                        legs: [{
                            departureTime: "6:30am",
                            arrivalTime: "1:20pm",
                            departureCity: "SEA",
                            arrivalCity: "NYC"
                        }]
                    }]
                }]
            };

            _save();
        }

        var _save = function () { amplify.storage(FILE_NAME, _data); };

        return
        {
            data: _data,
            save: _save
        };
    });

})();