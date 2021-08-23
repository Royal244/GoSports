({
    doGetMoviesWhereActorPlay: function (cmp, event){
        let tmp = cmp.get('v.actorDetails');
        let action = cmp.get("c.getMoviesWhereIsThisActor");
        action.setParams({
            "id": tmp.id
        });
        action.setCallback(this, function(response){
        let state = response.getState();
        if(state === "SUCCESS") {
            let castResponse = response.getReturnValue();
            cmp.set('v.movieListOnActorModal', castResponse.cast_z);
        }
        else {
        }
        });
        $A.enqueueAction(action);
    },

    doGetActorDetails: function(cmp, event){
        let tmp = cmp.get('v.actorDetails');
        let action = cmp.get("c.getActorDetails");
        console.log('id: ' + tmp.id);
        action.setParams({
            "id": tmp.id
        });
        action.setCallback(this, function(response){
        let state = response.getState();
        if(state === "SUCCESS") {
            let castResponse = response.getReturnValue();
            cmp.set('v.actorOverview', castResponse);
            console.log('overview: ' + response.getReturnValue());
        }
        else {
        }
        });
        $A.enqueueAction(action);
    },
})