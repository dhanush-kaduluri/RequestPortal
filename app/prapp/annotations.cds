using RequisitionService as service from '../../srv/requisition-service';
annotate service.PurchaseRequisition with @(
    UI.HeaderInfo:{
        TypeName: 'Purchase Requisition Data',
        TypeNamePlural: 'Purchase Requisitions Data',
        Title: { 
            Label : 'Object Page for Requisition No: #ID',
            Value: `Object Page: \${ID}`
        }
    },
    UI.SelectionFields: [
        ID,
        status,
    ],
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataFieldForAction',
                Action : 'RequisitionService.sendForApproval',
                Label: 'Send for Approval',
                Criticality : 2,
                Inline:true,
            },
            {
                $Type : 'UI.DataField',
                Value : ID,
                Label : 'Requisition ID'
            
            },
            {
                $Type : 'UI.DataField',
                Label : 'Description',
                Value : description,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Total Prcie',
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
                Criticality : ColorCode
            },
            {
                $Type : 'UI.DataField',
                Value : createdAt,
                Label : 'Created At'
            },
            {
                $Type : 'UI.DataField',
                Value : createdBy,
                Label : 'Created By'
            },
            {
                $Type : 'UI.DataField',
                Value : modifiedAt,
                Label : 'Changed At'
            },
            {
                $Type : 'UI.DataField',
                Value : modifiedBy,
                Label : 'Changed By'
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
            Label : 'Requisition Items',
            ID : 'OrderItems',
            Target : 'Items/@UI.LineItem#OrderItems',
        },
    ],
    UI.LineItem: [
        {
            $Type : 'UI.DataField',
            Value : ID,
            Label : 'Requisition ID',
            ![@UI.Importance]:#High,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '27vw'
            },
        },
        {
            $Type : 'UI.DataField',
            Label : 'Description',
            Value : description,
            ![@UI.Importance]:#Medium,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '17vw'
            },
        },
        {
            $Type : 'UI.DataField',
            Label : 'Total Price',
            Value : totalPrice,
            ![@UI.Importance]:#High,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '13vw'
            },
        },
        {
            $Type : 'UI.DataField',
            Label : 'Currency',
            Value : currency_code,
            ![@UI.Importance]:#High,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '13vw'
            },
        },
        {
            $Type : 'UI.DataField',
            Label : 'Status',
            Value : OverallStatus,
            Criticality : ColorCode,
            ![@UI.Importance]:#Low,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '12vw'
            },
        },
    ],
);

annotate service.Item with @(
    UI.HeaderInfo:{
        TypeName: 'Item Data',
        TypeNamePlural: 'Item Data',
        Title: { 
            Label : 'Item Details',
            Value: `Item Details: Item No. \${ID}` 
        }
    },
    UI.LineItem #OrderItems : [
        {
            $Type : 'UI.DataField',
            Value : ID,
            Label : 'Item ID',
            ![@UI.Importance]:#High,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '27vw'
            },
        },
        {
            $Type: 'UI.DataField',
            Value : itemDesc,
            Label : 'Description',
            ![@UI.Importance]:#Medium,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '13vw'
            },

        },
        {
            $Type : 'UI.DataField',
            Value : material_ID,
            Label : 'Material  ID',
            ![@UI.Importance]:#High,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10vw'
            },
        },
        {
            $Type : 'UI.DataField',
            Value : quantity,
            Label : 'Quantity',
            ![@UI.Importance]:#High,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10vw'
            },
        },
        {
            $Type: 'UI.DataField',
            Value : UOM,
            Label : 'Unit of Measure',
            ![@UI.Importance]:#Low,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '12vw'
            },

        },
        {
            $Type : 'UI.DataField',
            Value : unitPrice,
            Label : 'Unit Price',
            ![@UI.Importance]:#Low,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '12vw'
            },
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
                Label : 'Item ID',
            },
            {
                $Type : 'UI.DataField',
                Value : requisition_ID,
                Label : 'Requisition ID',
            },
            {
                $Type : 'UI.DataField',
                Value : itemNo,
                Label : 'Item No.',
            },
            {
                $Type : 'UI.DataField',
                Value : itemDesc,
                Label : 'Item Description',
            },
            {
                $Type : 'UI.DataField',
                Value : material_ID,
                Label : 'Material ID',
            },
            {
                $Type : 'UI.DataField',
                Value : plant_ID,
                Label : 'Select Plant',
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
                Value : UOM,
                Label : 'Unit of Measure'
            },
        ],
    },
);


// !---> THIS PIECE OF CODE IS NOT REQUIRED IN SPECIFIC AS ENTITY IN SCHEMA.CDS CAN BE DIRECTLY
// ANNOTATED TO PROVIDE VALUE HELPS <----!

// annotate service.Item with {
    // material @(
    //     Common.Text: material.ID, // Display field for value help
    //     ValueList.entity: RequisitionService.Products, // Source entity for value help
    //     ValueList.Label: 'Select Material' // Title for value help dialog
    // );

    // plant @(
    //     Common.Text: plant.ID, // Display field for value help
    //     ValueList.entity: RequisitionService.Plant, // Source entity for value help
    //     ValueList.Label: 'Select Plant' // Title for value help dialog
    // );
// };

// Annotate the Products entity to define its UI behavior in value help
// @cds.odata.valuelist
// annotate service.Products with @(
//     UI.Identification: [
//         {
//             $Type: 'UI.DataField',
//             Value: ID
//         },
//         {
//             $Type: 'UI.DataField',
//             Value: ProductType
//         }
//     ]
// );

// @cds.odata.valuelist
// annotate service.Plant with @(
//     UI.Identification: [
//         {
//             $Type: 'UI.DataField',
//             Value: ID
//         }
//     ]
// );