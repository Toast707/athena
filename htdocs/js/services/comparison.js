// comparison.js: Comparison service
//
// This service is used to interact with the server regarding 
// scenario comparisons, and to provide the data to pages.
'use strict';

angular.module('arachne')
.factory('Comparison', 
['$q', 'Arachne', 'Entities',
function($q, Arachne, Entities) {
    //---------------------------------------------------------
    // Service Data

    var service = {};

    //-------------------------------------------------
    // Look-up Tables

    var catNames = {
        political:      "Political",
        military:       "Military",
        economic:       "Economic",
        social:         "Social",
        information:    "Information",
        infrastructure: "Infrastructure"
    };

    //----------------------------------------------------------
    // Object Store

    var comps = Entities.retriever('/comparison/index.json');
    var byCat = {};

    //----------------------------------------------------------
    // Delegated Methods

    service.refresh = comps.refresh;
    service.get     = comps.get;
    service.all     = comps.all;

    //----------------------------------------------------------
    // Requests

    // request(tag, caseId1, caseId2)
    //
    // Request a comparison from the server.  The tag is an
    // Arachne request tag.

    service.request = function(tag,caseId1, caseId2) {
        var deferred = $q.defer();

        Arachne.request(tag, '/comparison/request.json', {
            case1: caseId1,
            case2: caseId2
        }).then(function (stat) {
            if (stat.ok) {
                comps.add(stat.result[0]);
                PopulateIndices();
            }
            deferred.resolve(stat);
        });      

        return deferred.promise;
    } 

    service.compId = function(caseId1, caseId2) {
        if (caseId2) {
            return caseId1 + '/' + caseId2;
        } else {
            return caseId1;
        }
    }

    //----------------------------------------------------------
    // Queries

    // categories() -- Return the list of output categories
    service.categories = function() {
        return Object.keys(catNames);
    }

    // catName(cat) -- Return the category name
    service.catName = function(cat) {
        return catNames[cat] || 'Unknown';
    }

    // case1(compId) -- Return case1 metadata
    service.case1 = function(compId) {
        var comp = comps.get(compId);

        if (comp) {
            return Arachne.getCase(comp.case1);
        }
    }

    // case2(compId) -- Return case2 metadata
    service.case2 = function(compId) {
        var comp = comps.get(compId);

        if (comp) {
            return Arachne.getCase(comp.case2);
        }
    }

    // size() -- Number of outputs
    service.size = function(compId) {
        return service.outputs(compId).length;
    }

    // catSize(cat) -- Number of outputs in the category
    service.catSize = function(compId,cat) {
        if (byCat[compId]) {
            return byCat[compId][cat].length;
        } else {
            return 0;
        }
    }

    // byCat(compId, cat) -- Returns the outputs by category
    service.byCat = function(compId, cat) {
        var comp = comps.get(compId);

        if (!comp) {
            return [];
        }

        var result = [];

        for (var i = 0; i < byCat[compId][cat].length; i++) {
            var ndx = byCat[compId][cat][i];
            result.push(comp.outputs[ndx]);
        }

        return result;
    }

    // outputs(compId) -- Returns a possibly empty array of outputs.
    service.outputs = function(compId) {
        var comp = comps.get(compId);

        if (comp) {
            return comp.outputs;
        } else {
            return [];
        }
    }

    //----------------------------------------------------------
    // Comparison wrapper

    // wrapper(compId)
    //
    // compId   - A comparison ID, e.g., 'case00/case01'
    //
    // Returns a wrapper object for this comparison ID.
    // TBD: caseId1, caseId2 instead of compId?

    service.wrapper = function(compId) {
        // TBD: Do we use output()?
        return {
            categories: service.categories,
            catName:    service.catName,
            meta:    function()     { return service.get(compId);          },
            case1:   function()     { return service.case1(compId);        },
            case2:   function()     { return service.case2(compId);        },
            size:    function()     { return service.size(compId);         },
            outputs: function()     { return service.outputs(compId);      },
            catSize: function(cat)  { return service.catSize(compId, cat); },
            byCat:   function(cat)  { return service.byCat(compId, cat);   },
            output:  function(name) { return service.output(compId, name); }
        };
    }

    //----------------------------------------------------------
    // Helpers

    var PopulateIndices = function() {
        byCat = {};

        for (var i = 0; i < comps.all().length; i++) {
            var comp = comps.all()[i];

            byCat[comp.id] = {};

            for (var cat in catNames) {
                byCat[comp.id][cat] = [];
            }

            for (var j = 0; j < comp.outputs.length; j++) {
                byCat[comp.id][comp.outputs[j].category].push(j);
            }
        }
    };


    //----------------------------------------------------------
    // Dynamic Initialization
    service.refresh().then(function() {
        PopulateIndices();
    });

    // Return the new service.
    return service;
}]);