sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'ust.com.prapp',
            componentId: 'ItemObjectPage',
            contextPath: '/PurchaseRequisition/_Items'
        },
        CustomPageDefinitions
    );
});