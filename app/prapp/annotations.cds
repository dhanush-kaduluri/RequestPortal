using RequisitionService as service from '../../srv/requisition-service';

annotate service.PurchaseRequisition with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataFieldForAction',
                Action : 'RequisitionService.sendForApproval',
                Label: 'Send For PR Approval',
                Criticality : 2,
                Inline: true,
            },
            {
                $Type : 'UI.DataField',
                Value : ID,
                Label : 'ID',
            },
            {
                $Type : 'UI.DataField',
                Label : 'Description',
                Value : description,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Total Price',
                Value : totalPrice,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Currency',
                Value : currency_code,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Status',
                Value : OverallStatus,
                Criticality : ColorCode,
            },
            {
                $Type : 'UI.DataField',
                Value : createdAt,
            },
            {
                $Type : 'UI.DataField',
                Value : createdBy,
            },
            {
                $Type : 'UI.DataField',
                Value : modifiedBy,
            },
            {
                $Type : 'UI.DataField',
                Value : modifiedAt,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Order Items',
            ID : 'OrderItems',
            Target : 'Items/@UI.LineItem#OrderItems',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : requestNo,
            Label : 'Request No',
        },
        {
            $Type : 'UI.DataField',
            Value : PRNumber,
            Label : 'PR Number',
        },
        {
            $Type : 'UI.DataField',
            Label : 'Description',
            Value : description,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Total Price',
            Value : totalPrice,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Currency',
            Value : currency_code,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Status',
            Value : OverallStatus,
            Criticality : ColorCode,
        },
        {
            $Type : 'UI.DataField',
            Value : createdBy,
        },
    ],
    UI.FieldGroup #InternalNotes : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : InternalNotes.createdBy,
            },
            {
                $Type : 'UI.DataField',
                Value : InternalNotes.text,
                Label : 'Text',
            },
            {
                $Type : 'UI.DataField',
                Value : InternalNotes.ID,
                Label : 'ID',
            },
        ],
    },
);

annotate service.Item with @(
    UI.LineItem #OrderItems : [
        {
            $Type : 'UI.DataField',
            Value : itemNo,
            Label : 'Item No',
        },
        {
            $Type : 'UI.DataField',
            Value : material_ID,
            Label : 'Material',
        },
        {
            $Type : 'UI.DataField',
            Value : plant_ID,
            Label : 'Plant',
        },
        {
            $Type : 'UI.DataField',
            Value : unitPrice,
            Label : 'Unit Price',
        },
        {
            $Type : 'UI.DataField',
            Value : quantity,
            Label : 'Quantity',
        },
        {
            $Type : 'UI.DataField',
            Value : itemDesc,
            Label : 'Item Description',
        },
    ],
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'General Information',
            ID : 'GeneralInformation',
            Target : '@UI.FieldGroup#GeneralInformation',
        },
    ],
    UI.FieldGroup #GeneralInformation : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : ID,
                Label : 'ID',
            },
            {
                $Type : 'UI.DataField',
                Value : material_ID,
                Label : 'Material',
            },
            {
                $Type : 'UI.DataField',
                Value : plant_ID,
                Label : 'Plant',
            },
            {
                $Type : 'UI.DataField',
                Value : requisition_ID,
                Label : 'Requisition ID',
            },
            {
                $Type : 'UI.DataField',
                Value : unitPrice,
                Label : 'Unit Price',
            },
            {
                $Type : 'UI.DataField',
                Value : quantity,
                Label : 'Quantity',
            },
            {
                $Type : 'UI.DataField',
                Value : itemDesc,
                Label : 'Item Description',
            },
            {
                $Type : 'UI.DataField',
                Value : itemNo,
                Label : 'Item No',
            },
            {
                $Type : 'UI.DataField',
                Value : UOM,
                Label : 'UOM',
            },
        ],
    },
);

annotate service.Item with {
    material @(
        Common.Text: material.ID, // Display field for value help
        ValueList.entity: RequisitionService.Products, // Source entity for value help
        ValueList.Label: 'Select Material' // Title for value help dialog
    );

    plant @(
        Common.Text: plant.ID, // Display field for value help
        ValueList.entity: RequisitionService.Plant, // Source entity for value help
        ValueList.Label: 'Select Plant' // Title for value help dialog
    );
};

@cds.odata.valuelist
annotate service.Products with @(
    UI.Identification: [
        {
            $Type: 'UI.DataField',
            Value: ID,
        },
        {
            $Type: 'UI.DataField',
            Value: ProductType,
        },
    ]
);

@cds.odata.valuelist
annotate service.Plant with @(
    UI.Identification: [
        {
            $Type: 'UI.DataField',
            Value: ID,
        },
    ]
);

annotate service.InternalNotes with @(
    UI.LineItem #InternalNotes : [
        {
            $Type : 'UI.DataField',
            Value : createdBy,
        },
        {
            $Type : 'UI.DataField',
            Value : ID,
            Label : 'ID',
        },
        {
            $Type : 'UI.DataField',
            Value : text,
            Label : 'Text',
        },
    ]
);
