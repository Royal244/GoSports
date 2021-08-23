({
    openModel: function(component, event, helper) {
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

   onInit: function(cmp, event, helper){
       helper.doInit(cmp, event);
   },

   sendActorDetails: function(cmp, event, helper){
       let actorDetails = cmp.get("v.actorDetails");
       let appEvent = $A.get("e.c:MM_SendActorDetailsEvent");
       appEvent.setParams({
           "detailsActor" : actorDetails
           });
       appEvent.fire();
//       console.log('1wysłano' );
   }
})