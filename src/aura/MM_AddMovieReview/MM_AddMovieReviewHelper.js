({
	onInit : function(component, event, helper) {
        var service = component.find("service");
        service.getNewRecord(
            "Movie_review__c",
            null,
            false,
            $A.getCallback(function() {
                var boatReview = component.get("v.movieReview");
                var error = component.get("v.recordError");

                if(error || !boatReview) {
                    console.log("Error: " + error);
                    return;
                }

                boatReview.MovieId__c = component.get("v.movie").Id;
                component.set("v.movieReview", boatReview);
            })
        );
	},

    notifyUser : function(params){
        var showToastEvent = $A.get("e.force:showToast");
        if (showToastEvent) {
            showToastEvent.setParams({
                "title" : params.Title,
                "message" : params.Message,
                "type" : params.Type
            });
            showToastEvent.fire();
        }
        else {
            alert(params.Message);
        }
    }

})