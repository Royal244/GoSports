({
    doPassAccountToMap: function(cmp,event) {
        let appEvent = $A.get("e.c:TA_EventPassAccountToMap");
        let acc = cmp.get('v.account');
        if((acc.BillingStreet != undefined) || (acc.BillingCity != undefined) || (acc.BillingPostalCode != undefined)){
        appEvent.setParams({"account" : cmp.get("v.account")});
        appEvent.fire();
        }else{
            this.showToast('No location found', 'This account do not have location.', 'info');
        }
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

    doPassSelectedRow: function(cmp,event){
        let rowSelected = cmp.getEvent('TA_EventSelectedRow');
        let acc = cmp.get('v.account');
        rowSelected.setParams({'RecordId': acc.Id});
        rowSelected.fire();
    }
})