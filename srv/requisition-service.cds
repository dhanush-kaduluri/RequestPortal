using requisition from '../db/schema';

service RequisitionService @(path : 'RequisitionService') {
    @odata.draft.enabled
    entity PurchaseRequisition as projection on requisition.PurchaseRequisition{
        *,
        case status
            when 'I' then 'InApproval'
            when 'O' then 'Ordered'
            when 'R' then 'Rejected'
            when 'S' then 'Saved'
            end as OverallStatus : String(10),
        case status
            when 'I' then 2
            when 'O' then 3
            when 'R' then 1
            when 'S' then 2
            end as ColorCode : Integer

    }
    actions{
        @Common.SideEffects : {
            TargetProperties : [
                'in/status',
            ]
        }
        action updateStatus(ID:UUID, status:String) returns {};
        action sendForApproval() returns {};
    };
    entity Products as projection on requisition.Products;
    entity Plant as projection on requisition.Plant;
    entity Item as projection on requisition.Items;
    entity Attachments as projection on requisition.Attachments;
    entity InternalNotes as projection on requisition.InternalNotes;
    
};

