({
    onHandleEvent:function(component, event, helper){
//        console.log('received');
        helper.doHandleEvent(component, event);
    },
    showPin: function(cmp, event, helper){
//        console.log("1");
    },

    onHandleRowSelection: function(cmp,event, helper){
        let eve = event.getParam('RecordId');
        cmp.set('v.selectedId', eve);

    }
})