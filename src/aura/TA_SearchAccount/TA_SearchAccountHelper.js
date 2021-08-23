({
    doClear:function(component,event){
        component.set("v.accountName", '');
        let appEvent = $A.get("e.c:TA_SearchResult");
        appEvent.setParams({"accounts" : []},{"mapMarkers" : null});
        appEvent.fire();
        let accClear = $A.get("e.c:TA_EventClear");
//        accClear.setParams({"account" : null});
        accClear.fire();
//        console.log('accClear ' + JSON.Stringify(accClear));
    },

    doSearchAccounts: function(component, event){
        let action = component.get("c.getAccounts");
        action.setParams({
            "accName" : component.get("v.accountName")
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS") {
                let returnedAccounts = response.getReturnValue();
                component.set("v.accounts", returnedAccounts);
                let appEvent = $A.get("e.c:TA_SearchResult");
                appEvent.setParams({"accounts" : component.get("v.accounts")});
                appEvent.fire();
//                console.log("v.accounts");
            }
            else {
                if (response.getError() && response.getError().length > 0) {
                    this.showToast('Error', response.getError()[0].message, 'error');
                }
            }
        });
        $A.enqueueAction(action);
    },

    showToast : function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type" : type
        });
        toastEvent.fire();
    },

    doStartEmpty: function(cmp, event){

    },

})