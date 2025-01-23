using RequisitionService as service from '../../srv/requisition-service';
annotate service.PurchaseRequisition with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        
        Data : [
             {
            $Type : 'UI.DataFieldForAction',
            Action : 'RequisitionService.sendForApproval',
            Label: 'Send for PR Approval',
            Criticality : 2,
            Inline:true,
            },
            {
                $Type : 'UI.DataField',
                Value : ID,
                Label : 'ID',
            },
            {
                $Type : 'UI.DataField',
                Label : 'description',
                Value : description,
            },
            {
                $Type : 'UI.DataField',
                Label : 'totalPrice',
                Value : totalPrice,
            },
            {
            $Type : 'UI.DataField',
            Label : 'currency',
            Value : currency_code,
        },
           {
            $Type : 'UI.DataField',
            Label : 'status',
            Value : OverallStatus,
            Criticality : ColorCode
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
            Label : 'description',
            Value : description,
        },
        {
            $Type : 'UI.DataField',
            Label : 'totalPrice',
            Value : totalPrice,
        },
        {
            $Type : 'UI.DataField',
            Label : 'currency',
            Value : currency_code,
        },
        {
            $Type : 'UI.DataField',
            Label : 'status',
            Value : OverallStatus,
            Criticality : ColorCode
        },
        {
            $Type : 'UI.DataField',
            Value : ID,
            Label : 'ID',
        },
    ],
);

annotate service.Item with @(
    UI.LineItem #OrderItems : [
        {
            $Type : 'UI.DataField',
            Value : ID,
            Label : 'ID',
        },
        {
            $Type : 'UI.DataField',
            Value : material_ID,
            Label : 'material',
        },
        {
            $Type : 'UI.DataField',
            Value : quantity,
            Label : 'quantity',
        },
        {
            $Type : 'UI.DataField',
            Value : unitPrice,
            Label : 'unitPrice',
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
                Label : 'material',
            },
            {
                $Type : 'UI.DataField',
                Value : plant_ID,
                Label : 'Plant',
            },
            {
                $Type : 'UI.DataField',
                Value : requisition_ID,
                Label : 'requisition_ID',
            },
            {
                $Type : 'UI.DataField',
                Value : unitPrice,
                Label : 'unitPrice',
            },
            {
                $Type : 'UI.DataField',
                Value : quantity,
                Label : 'quantity',
            },
            {
                $Type : 'UI.DataField',
                Value : itemDesc,
                Label : 'itemDesc',
            },
            {
                $Type : 'UI.DataField',
                Value : itemNo,
                Label : 'itemNo',
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

// Annotate the Products entity to define its UI behavior in value help
@cds.odata.valuelist
annotate service.Products with @(
    UI.Identification: [
        {
            $Type: 'UI.DataField',
            Value: ID
        },
        {
            $Type: 'UI.DataField',
            Value: ProductType
        }
    ]
);

@cds.odata.valuelist
annotate service.Plant with @(
    UI.Identification: [
        {
            $Type: 'UI.DataField',
            Value: ID
        }
    ]
);






