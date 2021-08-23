({
    doInit: function(cmp, event){
//        console.log(cmp);
        let action = cmp.get("c.getPopularMovies");
            action.setCallback(this, function(response){
                let state = response.getState();
                if(state === "SUCCESS" ){
//                    console.log('elo');
//                    let responseMovies = cmp.get("v.moviesList");
//                    console.log('elo2');
                    let responseMovies = response.getReturnValue();
//                    console.log('elo3' + JSON.stringify(responseMovies.results));
                    cmp.set('v.moviesList', responseMovies.results.slice(0,12));
//                    console.log('elo3' + cmp.get('v.moviesList'));

                }
                else {

                }
            });
            $A.enqueueAction(action);
        },

        doGetSearchMovies: function(cmp, event){
//            console.log('1');
//            console.log('1 ' + event.getParam('foundMovies'));
            cmp.set('v.searchMoviesList', event.getParam('foundMovies'));
            cmp.set('v.favList', null);
            cmp.set('v.blackList', null);
//            console.log('2 ' + JSON.stringify(cmp.get('v.searchMoviesList')));
        },

        doGetFavOrBlackListed: function(cmp, event){
//            console.log(event.getParam('MM_GetSingleMovieCalloutResponse'));
            cmp.set('v.favList', event.getParam('favList'));
            cmp.set('v.blackList', event.getParam('blackList'));
//            console.log(cmp.get('v.favOrBlackListMovies'));
            cmp.set('v.searchMoviesList', null);
            console.log('v.favList');
        }
})