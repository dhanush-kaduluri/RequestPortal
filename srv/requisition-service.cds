using requisition from '../db/schema';
using { Attachments } from '@cap-js/sdm';




service RequisitionService @(path : 'RequisitionService') {

    extend requisition.PurchaseRequisition with { Attachments: Composition of many Attachments }
    @odata.draft.enabled
    @(
        Common.SideEffects #triggerActionProperty : {
			SourceProperties : [Items.quantity,Items.unitPrice],
			TargetProperties   : ['totalPrice'],
		}
    )
    entity PurchaseRequisition @(restrict: [
    {
    grant: '*',
    to   : 'Admin'
    },
    {
    grant: '*',
    to   : 'User',
    where: 'createdBy = $user'
    },
    {
    grant: 'READ',
    to   : 'Approver'
    }
]) as projection on requisition.PurchaseRequisition{
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
        action ApproveRequest(ID:UUID) returns {};

        action RejectRequest(ID:UUID) returns {};
        
        action sendForApproval() returns {};
    };
    entity Products as projection on requisition.Products;
    entity Plant as projection on requisition.Plant;
    entity Item as projection on requisition.Items;
    entity InternalNotes as projection on requisition.InternalNotes;
    
};

