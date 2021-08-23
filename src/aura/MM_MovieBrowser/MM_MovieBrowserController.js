({
    onSearchMovies: function(cmp, event, helper){
        helper.doSearchMovies(cmp, event);
    },

    onInit: function(cmp, event, helper){
        helper.doInit(cmp, event);
    },

    onClear: function(cmp, event, helper){
        helper.doClear(cmp, event);
    },

    onTakeFavorites: function(cmp, event, helper){
        helper.doTakeFavorites(cmp, event);
    },

    onTakeBlackList: function(cmp, event, helper){
        helper.doTakeBlackList(cmp, event);
    },

    onGoPrevious: function(cmp, event, helper){
        helper.doGoPrevious(cmp, event);
    },

    onGoNext:function(cmp, event, helper){
        helper.doGoNext(cmp, event);
    },
})