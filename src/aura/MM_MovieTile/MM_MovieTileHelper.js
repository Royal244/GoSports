({
//    doInit: function(cmp, event){
//        let tmp = cmp.get('v.movieDetails');
//        let action = cmp.get("c.getTrailer");
//        action.setParams({
//               "id": tmp.id
//        });
//        action.setCallback(this, function(response){
//            let state = response.getState();
//               if(state === "SUCCESS") {
//                   cmp.set('v.movieUrl', response.getReturnValue());
//               }
//               else {
//               }
//           });
//        $A.enqueueAction(action);
//    },
//
//    doGetMovieActorsFormMovie: function (cmp, event){
//        let tmp = cmp.get('v.movieDetails');
//        let action = cmp.get("c.getCast");
////        console.log('11');
//        action.setParams({
//            "id": tmp.id
//        });
////        console.log('112');
//        action.setCallback(this, function(response){
//        let state = response.getState();
//        if(state === "SUCCESS") {
////            console.log('1');
//            let castResponse = response.getReturnValue()
////            console.log('2 ' + JSON.stringify(castResponse.cast_z[0]));
//            cmp.set('v.castDetailsList', castResponse.cast_z);
////            console.log('3 ' + JSON.stringify(cmp.get('v.castDetails')));
//        }
//        else {
//        }
//        });
//        $A.enqueueAction(action);
//    },



})