namespace requisition;

using { managed, Currency } from '@sap/cds/common';
using { OP_API_PRODUCT_SRV_0001 as external } from '../srv/external/OP_API_PRODUCT_SRV_0001';

entity PurchaseRequisition : managed  {
    key ID: UUID;
    requestNo:String;
    PRNumber: String;
    description: String;
    @readonly
    totalPrice: Decimal(10,2);
    currency: Currency;
    status: String;
    Items: Composition of  many Items on Items.requisition = $self;
    Attachments : Composition of many Attachments;
    InternalNotes : Composition of many InternalNotes on InternalNotes.requisition = $self;
}

entity Items {
    key ID: UUID;
    itemNo: Int32;
    requisition: Association to PurchaseRequisition;
    itemDesc: String;
    material: Association to Products;
    plant: Association to Plant;
    quantity: Decimal(10,2);
    UOM:String;
    unitPrice: Decimal(10,2);
}

entity Attachments : managed {
    key ID: UUID;
    requisition: Association to PurchaseRequisition;
    fileName: String;
    @Core.ContentDisposition.Type: 'inline'
    @Core.MediaType: fileType
    content       : LargeBinary; // The binary content of the file
    @Core.IsMediaType: true
    fileType: String;
    url:String;
}

entity InternalNotes: managed{
    key ID : UUID;
    requisition: Association to PurchaseRequisition;
    text: String;
}


entity Products  as projection on external.A_Product{
    ProductType as ProductType,
    key Product as ID 
}

entity Plant  as projection on external.A_ProductPlant{
        Product as Product,
    key Plant as ProductPlant
}


