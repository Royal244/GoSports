({
    doInit: function(cmp, event){
        let tmp = cmp.get('v.movieDetails');
        let action = cmp.get("c.getTrailer");
        action.setParams({
               "id": tmp.id
        });
        action.setCallback(this, function(response){
            let state = response.getState();
               if(state === "SUCCESS") {
                   cmp.set('v.movieUrl', response.getReturnValue());
               }
               else {
               }
           });
        $A.enqueueAction(action);
    },

    doGetMovieActorsFormMovie: function (cmp, event){
        let tmp = cmp.get('v.movieDetails');
        let action = cmp.get("c.getCast");
        action.setParams({
            "id": tmp.id
        });
        action.setCallback(this, function(response){
        let state = response.getState();
        if(state === "SUCCESS") {
            let castResponse = response.getReturnValue()
            cmp.set('v.castDetailsList', castResponse.cast_z);
//            console.log('3 ' + cmp.get('v.castDetailsList'));
        }
        else {
        }
        });
        $A.enqueueAction(action);
    },

    doAddToFavorites: function(cmp, event){
        let tmp =  cmp.get("v.movieDetails");
        let action = cmp.get("c.addMovieToListOfFavorites");
        action.setParams({
            "movieId": tmp.id
        });
        action.setCallback(this, function(response){
            let state = response.getState();
                console.log(response.getError());
            if(state === "SUCCESS") {
                tmp.favorite = true;
                tmp.blackListed = false;
                cmp.set('v.movieDetails', tmp);
//                cmp.set('v.isInFavorite', false);
            }

            else {
            }
        });
        $A.enqueueAction(action);
    },

    doAddToBlackList: function(cmp, event){
        let tmp =  cmp.get("v.movieDetails");
        let action = cmp.get("c.addMovieToBlackList");
        action.setParams({
            "movieId": tmp.id
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS") {
//                console.log('1');
                tmp.blackListed = true;
                tmp.favorite = false;
                cmp.set('v.movieDetails', tmp);
//                cmp.set('v.isInFavorite', false);
            }

            else {
            }
        });
        $A.enqueueAction(action);
    },
})