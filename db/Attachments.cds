using {Attachments} from '@cap-js/attachments';
using {requisition} from './schema';

extend requisition.PurchaseRequisition with {
    Attachments : Composition of many Attachments;
}