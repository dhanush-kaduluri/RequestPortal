sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'ust/com/prapp/test/integration/FirstJourney',
		'ust/com/prapp/test/integration/pages/PurchaseRequisitionList',
		'ust/com/prapp/test/integration/pages/PurchaseRequisitionObjectPage',
		'ust/com/prapp/test/integration/pages/ItemObjectPage'
    ],
    function(JourneyRunner, opaJourney, PurchaseRequisitionList, PurchaseRequisitionObjectPage, ItemObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('ust/com/prapp') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onThePurchaseRequisitionList: PurchaseRequisitionList,
					onThePurchaseRequisitionObjectPage: PurchaseRequisitionObjectPage,
					onTheItemObjectPage: ItemObjectPage
                }
            },
            opaJourney.run
        );
    }
);