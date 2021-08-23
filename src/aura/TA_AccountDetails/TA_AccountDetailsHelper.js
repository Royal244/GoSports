({
    doInit: function(cmp,event){
        let acc = event.getParam("account");
        let accToDisplay = cmp.set('v.accountToDisplay', acc);
//        console.log('acc to display: ' + JSON.stringify(accToDisplay));
    },
    doOpenViewTab: function(cmp,event){
//        console.log('acc: ' + cmp.get('v.accountToDisplay'));
        let acc = cmp.get('v.accountToDisplay');
        window.open("/" + acc.Id, '_blank');
    },
    doOpenEditTab: function(cmp,event){
        let acc = cmp.get('v.accountToDisplay');
        window.open("/lightning/r/Account/" + acc.Id + '/edit', '_blank');
    },

    doClearAccount: function(cmp, event){
        cmp.set('v.accountToDisplay', null);
    }


})