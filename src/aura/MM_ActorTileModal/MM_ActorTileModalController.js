({
   openModel: function(component, event, helper) {
      // Set isModalOpen attribute to true
      component.set("v.modalOpen", true);
   },

   closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false
      component.set("v.modalOpen", false);
   },

   submitDetails: function(component, event, helper) {
      // Set isModalOpen attribute to false
      //Add your code to call apex method or do some processing
      component.set("v.modalOpen", false);
   },

    openModal: function(cmp, event, helper){
        if(event.getParam('detailsActor') != null){
        //            console.log('odebrano');
            cmp.set('v.actorDetails', event.getParam('detailsActor'));
        //            helper.doInit(cmp, event);
            helper.doGetMoviesWhereActorPlay(cmp, event);
            helper.doGetActorDetails(cmp, event);
            cmp.set('v.modalOpen', true);
        }
    },

    close: function(cmp, event, helper){
        if(event.getParam('detailsMovie') != null){
            cmp.set('v.modalOpen', false);
        }
    },
})