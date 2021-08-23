({
    doHandleEvent:function(component, event){
        let accTable = event.getParam("accounts");
        component.set("v.accounts", accTable);
        component.set("v.columns", [
            {label: "Account Name", fieldName: "Name", type: "text"}
        ]);
    },
})