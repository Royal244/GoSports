({
    onInit: function(cmp, event, helper){
        helper.doInit(cmp, event);
    },

    onGetSearchMovies: function (cmp, event, helper){
        helper.doGetSearchMovies(cmp, event);
    },

    onGetFavOrBlackListed: function(cmp, event, helper){
        helper.doGetFavOrBlackListed(cmp, event);
    }
})