({
    createPin: function (cmp, event, helper) {
       let accList = event.getParam("accounts");
       let listToDisplay = [];
       accList.forEach(function(element){
               if((element.BillingStreet != undefined) || (element.BillingCity != undefined) || (element.BillingPostalCode != undefined)){
//               console.log('element: ' + JSON.stringify(element));
           let acc = {
               location
           };
            acc.location = {
                  Street : element.BillingStreet,
                  City : element.BillingCity,
                  BillingPostalCode : element.BillingPostalCode
               }
           listToDisplay.push(acc);
           }
       })
       cmp.set('v.mapMarkers', listToDisplay);

//       console.log('lista ' + JSON.stringify(listToDisplay));
       cmp.set('v.zoomLevel', 1);
    },

    moveToPin: function(cmp, event, helper){
        let acc = event.getParam("account");
        cmp.set('v.mapMarkers', [
            {
                location: {
                    Street: acc.BillingStreet,
                    City: acc.BillingCity,
                    State: acc.BillingPostalCode
                }
            }
        ]);
        cmp.set('v.zoomLevel', 8);
    },
});
