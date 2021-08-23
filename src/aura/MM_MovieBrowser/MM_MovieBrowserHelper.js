({
    doSearchMovies: function(cmp, event){
        let query = cmp.get("v.searchString");
        let action = cmp.get("c.getMovies");
            action.setParams({
                "searchString" : query.replace(/\s/g, '+')
            });
            action.setCallback(this, function(response){
                let state = response.getState();
                if(state === "SUCCESS" ){
                    let responseMovies = response.getReturnValue();
                    let appEvent = $A.get("e.c:MM_SearchMoviesToDisplayEvent");
                    appEvent.setParams({"foundMovies" : responseMovies.results});
                    appEvent.fire();
                    cmp.set('v.lastPage', responseMovies.total_pages);
                    cmp.set('v.displayPagination', true);
                    if(responseMovies.total_pages > 1){
                        cmp.set('v.nextButton', false);
                    }
                }
                else {
                }
            });
            $A.enqueueAction(action);
    },

    doGoPrevious: function(cmp, event){
        let query = cmp.get("v.searchString");
        let page = cmp.get('v.currentPage');
        let tmpPage = page - 1;
        let lastPage = cmp.get('v.lastPage');
        let action = cmp.get("c.getMoviesWithNumberOfPage");
        action.setParams({
            "searchString" : query.replace(/\s/g, '+'),
            "pageNumber" : tmpPage
        });
        console.log('1');
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS" ){
                let responseMovies = response.getReturnValue();
                let appEvent = $A.get("e.c:MM_SearchMoviesToDisplayEvent");
                appEvent.setParams({"foundMovies" : responseMovies.results});
                appEvent.fire();
                cmp.set('v.currentPage', tmpPage);
//                cmp.set('v.prevButton', false);
//                cmp.set('v.lastPage', responseMovies.total_pages);
//                cmp.set('v.displayPagination', true);
//                console.log(responseMovies.results);
                if(1 === tmpPage){
                    cmp.set('v.prevButton', true);
                }
                if(tmpPage < responseMovies.total_pages){
                    cmp.set('v.nextButton', false);
                }
            }
            else {
            }
        });
        $A.enqueueAction(action);
    },

    doGoNext: function(cmp, event){
        let query = cmp.get("v.searchString");
        let page = cmp.get('v.currentPage');
        let tmpPage = page + 1;
        let lastPage = cmp.get('v.lastPage');
        let action = cmp.get("c.getMoviesWithNumberOfPage");
        action.setParams({
            "searchString" : query.replace(/\s/g, '+'),
            "pageNumber" : tmpPage
        });
        console.log('1');
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS" ){
                let responseMovies = response.getReturnValue();
                let appEvent = $A.get("e.c:MM_SearchMoviesToDisplayEvent");
                appEvent.setParams({"foundMovies" : responseMovies.results});
                appEvent.fire();
                cmp.set('v.currentPage', tmpPage);
                cmp.set('v.prevButton', false);
//                cmp.set('v.lastPage', responseMovies.total_pages);
//                cmp.set('v.displayPagination', true);
                console.log(responseMovies.results);

                if(responseMovies.total_pages === tmpPage){
                    cmp.set('v.nextButton', true);
                }
            }
            else {
            }
        });
        $A.enqueueAction(action);
    },

    doClear: function(cmp, event){
        cmp.set('v.searchString', '');
        cmp.set('v.prevButton', true);
        cmp.set('v.nextButton', true);
        cmp.set('v.currentPage', 1);
        cmp.set('v.lastPage', 1);
        cmp.set('v.displayPagination', false);
        let appEvent = $A.get("e.c:MM_SearchMoviesToDisplayEvent");
        appEvent.setParams({"foundMovies" : null});
        appEvent.fire();
        let appEvent2 = $A.get("e.c:MM_SendFavOrBlackListEvent");
        appEvent2.setParams({
            "favList" : null,
            "blackList" : null
            });
        appEvent2.fire();
    },

    doTakeFavorites: function(cmp, event){
        console.log('1');
        cmp.set('v.displayPagination', false);
        console.log('2');
        let action = cmp.get("c.getFavOrBlackList");
        console.log('3');
            action.setParams({
                "nameList" : "Favorite"
            });
        console.log('4');
            action.setCallback(this, function(response){
        console.log('5');
                let state = response.getState();
                if(state === "SUCCESS" ){
        console.log('6');
                    let responseMovies = response.getReturnValue();
                    let appEvent = $A.get("e.c:MM_SendFavOrBlackListEvent");
                    appEvent.setParams({
                        "favList" : responseMovies,
                        "blackList" : null
                        });
                    console.log(responseMovies);
                    console.log('favList: ' + responseMovies);
                    appEvent.fire();
                }
                else {
                    console.log('fail: ' + JSON.stringify(response.getError()));
                }
            });
            $A.enqueueAction(action);
    },

    doTakeBlackList: function(cmp, event){
        cmp.set('v.displayPagination', false);
        let action = cmp.get("c.getFavOrBlackList");
        action.setParams({
            "nameList" : "Black list"
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS" ){
                let responseMovies = response.getReturnValue();
                let appEvent = $A.get("e.c:MM_SendFavOrBlackListEvent");
                 appEvent.setParams({
                    "blackList" : responseMovies,
                    "favList" : null
                    });
                appEvent.fire();
            }
            else {
            }
        });
        $A.enqueueAction(action);
    },


})