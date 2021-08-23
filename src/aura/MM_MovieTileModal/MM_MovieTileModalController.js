({
       openModel: function(component, event, helper) {
          // Set isModalOpen attribute to true
          component.set("v.isModalOpen", true);
       },

       closeModel: function(component, event, helper) {
          // Set isModalOpen attribute to false
          component.set('v.movieUrl', null);
          component.set("v.isModalOpen", false);
       },

       submitDetails: function(component, event, helper) {
          // Set isModalOpen attribute to false
          //Add your code to call apex method or do some processing
          component.set('v.movieUrl', null);
          component.set("v.isModalOpen", false);
       },

    openModal: function(cmp, event, helper){
        if(event.getParam('detailsMovie') != null){
            cmp.set('v.movieDetails', event.getParam('detailsMovie'));
            helper.doInit(cmp, event);
            helper.doGetMovieActorsFormMovie(cmp, event);
            cmp.set('v.isModalOpen', true);
        }
    },

    close: function(cmp, event, helper){
        if(event.getParam('detailsActor') != null){
            cmp.set('v.movieUrl', null);
            cmp.set('v.isModalOpen', false);
        }
    },

    onAddToFavorites: function(cmp, event, helper){
        helper.doAddToFavorites(cmp, event);
    },

    onAddToBlackList: function(cmp, event, helper){
        helper.doAddToBlackList(cmp, event);
    },
})