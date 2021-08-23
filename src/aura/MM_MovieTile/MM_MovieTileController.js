({
//   openModel: function(component, event, helper) {
//      // Set isModalOpen attribute to true
//      component.set("v.isModalOpen", true);
//   },
//
//   closeModel: function(component, event, helper) {
//      // Set isModalOpen attribute to false
//      component.set("v.isModalOpen", false);
//   },
//
//   submitDetails: function(component, event, helper) {
//      // Set isModalOpen attribute to false
//      //Add your code to call apex method or do some processing
//      component.set("v.isModalOpen", false);
//   },

//   onInit: function(cmp, event, helper){
//       helper.doInit(cmp, event);
//       helper.doGetMovieActorsFormMovie(cmp, event);
//   },

//   ifTrueCloseModal: function(cmp, event, helper){
//        let toClose = event.getParam('infoToCloseMovieTile');
//            console.log('1');
//        if (toClose){
//            cmp.set("v.isModalOpen", false);
//        }
//   },
    sendDataToModal: function (cmp, event, helper){
        let movieDetails = cmp.get("v.movieDetails");
        let appEvent = $A.get("e.c:MM_SendMovieDetailsEvent");
        appEvent.setParams({
            "detailsMovie" : movieDetails
            });
        appEvent.fire();
//        console.log('1');
    },

}
)