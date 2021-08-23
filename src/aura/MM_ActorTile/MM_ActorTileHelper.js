({
    doInit: function(cmp, event){
        let url = $A.get('$Resource.noFotoFoundImg');
        cmp.set('v.backgroundImageURL', url);
//        console.log('init');
    },
})