;(function(window) {
     
     window.jsbridge = {
        device: {
            getDeviceId:_getDeviceId
        },
        test: {
            test:_test,
            testFail:_testFail
        },
        _handleMessageFromObjC: _handleMessageFromObjC
     };
     
     var responseCallbacks = {};
     var __uniqueId = 1;
     
     function _getDeviceId(success, fail) {
         _doSend('device','getDeviceId', {}, success, fail);
     }
     
     function _test(success, fail) {
         _doSend('test','test', {}, success, fail);
     }
    
     function _testFail(success, fail) {
         _doSend('test','testFail', {}, success, fail);
     }
     
     function _doSend(module,action,data, success, fail) {
         var callbackId = 'cb_'+(__uniqueId++)+'_'+new Date().getTime();
         if (success && fail) {
             responseCallbacks[callbackId] = [success, fail];
         }
         var body = {
             'module':module,
             'action':action,
             'callId':callbackId,
             'data':data
         };
         window.webkit.messageHandlers.jsbridge.postMessage(body);
     }
     
     function _dispatchMessageFromObjC(messageJSON) {
         _doDispatchMessageFromObjC();
         function _doDispatchMessageFromObjC() {
             var message = messageJSON;
             var messageHandler;
             var responseCallback;
             
             if (message.callbackId) {
                 if (message.code == 0) {
                     responseCallback = responseCallbacks[message.callbackId][0];
                 }else {
                     responseCallback = responseCallbacks[message.callbackId][1];
                 }
                 if (!responseCallback) {
                     return;
                 }
                 responseCallback(message.data);
                 delete responseCallbacks[message.callbackId];
             }else {
                alert(JSON.stringify(message))
             }
         }
     }
     function _handleMessageFromObjC(messageJSON) {
         _dispatchMessageFromObjC(messageJSON);
     }
 })(window);

