({
	onInit : function(component, event, helper) {
        var action = component.get("c.getMovieReviews");
        action.setParams({
            "id" : component.get("v.movie").id
        });
        console.log('1');



        action.setCallback(this, function(response) {
			var state = response.getState();

            if (state === "SUCCESS"){
                component.set("v.movieReviews", response.getReturnValue());

        console.log('elo: ' + component.get('v.movieReviews'));
            }
            else if (state === "ERROR"){
                console.log(response.getError());
            }
            else{
                console.log(response);
            }
        });

        $A.enqueueAction(action);
        console.log('123');
	}

})