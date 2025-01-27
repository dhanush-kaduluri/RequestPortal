sap.ui.define([
    "sap/m/MessageToast"
], function (MessageToast) {
    'use strict';

    return {
        onPost: function (oEvent) {
            var data = {
                text: oEvent.getParameter("value")
            };

            var that = this;
            var oDataModel = this.getBindingContext().getModel();
            var sPath = oDataModel.sServiceUrl + this.getBindingContext().sPath.slice(1) + "/InternalNotes"; // Updated to _InternalNotes
            var csrfToken = oDataModel.getHttpHeaders()["X-CSRF-Token"];

            $.ajax({
                url: sPath,
                async: false,
                headers: {
                    'X-CSRF-Token': csrfToken
                },
                type: "POST",
                data: JSON.stringify(data),
                dataType: "json",
                contentType: "application/json",
                success: function () {
                    that.refresh();
                    MessageToast.show("Internal note added successfully!");
                },
                error: function (error) {
                    MessageToast.error("Failed to add internal note: " + error);
                }
            });
        },

        refresh: function () {
            // Placeholder for custom refresh logic
            MessageToast.show("Refreshing the view...");
        }
    };
});
