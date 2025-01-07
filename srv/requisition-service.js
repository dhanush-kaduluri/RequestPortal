const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {
    const externalService = await cds.connect.to('OP_API_PRODUCT_SRV_0001');
    const {Products,Plant,Item,PurchaseRequisition,Attachments} = this.entities;

    this.on("READ",Products,(req)=>{
      req.query.where("Product <> ''");
      req.query.SELECT.count = false;
      return externalService.run(req.query);
    });

    this.on("READ",Plant,(req)=>{
      req.query.SELECT.count = false;
      return externalService.run(req.query);
    }); 
    
    this.after(['CREATE','UPDATE'], PurchaseRequisition, async (req) => {
  
      const ID = req.ID;

      const items = await SELECT.from(Item)
        .columns('unitPrice', 'quantity')
        .where({ requisition_ID: ID });
      

      const totalPrice = items.reduce((sum, item) => {
        const itemTotal = (item.unitPrice || 0) * (item.quantity || 0);
        return sum + itemTotal;
      }, 0);

      // req.totalPrice=totalPrice;
      
      
      await UPDATE(PurchaseRequisition, ID).with({ totalPrice: totalPrice });
  
    });

    this.before('CREATE', PurchaseRequisition, async (req) => {
      const existingRecords = await cds.run(
          SELECT.from(PurchaseRequisition).columns('requestNo')
      );
  
      // Find the highest existing requestNo
      let maxNumber = 0;
      if (existingRecords.length > 0) {
          maxNumber = Math.max(
              ...existingRecords.map(record => parseInt(record.requestNo.substring(2), 10))
          );
      }
  
      // Generate the next requestNo
      const nextrequestNo = `PR${(maxNumber + 10).toString().padStart(4, '0')}`;
      req.data.requestNo = nextrequestNo;
  });

  this.after('DELETE', PurchaseRequisition, async (req) => {
      const remainingRecords = await cds.run(
          SELECT.from(PurchaseRequisition).columns('ID').orderBy('requestNo')
      );
  
      // Reassign requestNos to ensure sequential order
      for (let i = 0; i < remainingRecords.length; i++) {
          const newrequestNo = `PR${((i + 1) * 10).toString().padStart(4, '0')}`;
          await cds.run(
              UPDATE(PurchaseRequisition)
                  .set({ requestNo: newrequestNo })
                  .where({ ID: remainingRecords[i].ID })
          );
      }
  });

  this.before('CREATE', Attachments.drafts, req => {
      req.data.url = `PurchaseRequisition(ID=${req.data.requisition_ID},IsActiveEntity=true)/Attachments(ID=${req.data.ID},IsActiveEntity=true)/content`
  })

  this.before('CREATE', Item.draft, async (req) => {
    console.log(req.data);
    
    const existingRecords = await cds.run(
      SELECT.from(Item).columns('itemNo').where({ requisition_ID: req.data.requisition_ID })
    );

    let maxNumber = 0;
    if (existingRecords.length > 0) {
      maxNumber = Math.max(...existingRecords.map(record => record.itemNo));
    }

    req.data.itemNo = maxNumber + 10;
  });

  this.after('UPDATE', PurchaseRequisition, async (req) => {
    console.log(req);

    const remainingRecords = await cds.run(
      SELECT.from(Item)
          .columns('ID')
          .where({ requisition_ID: req.ID })
          .orderBy('itemNo')
    );

    for (let i = 0; i < remainingRecords.length; i++) {
      const newItemNo = (i + 1) * 10;
      await cds.run(
        UPDATE(Item)
          .set({ itemNo: newItemNo })
          .where({ ID: remainingRecords[i].ID })
      );
    }
  });


  this.on('sendForApproval',(req)=>{
    console.log("sent for approval");
    console.log(req.params[0].ID);
    return {};
  });

  this.on('updateStatus',async (req)=>{
    console.log("sent for approval");
    const ID = req.params[0].ID;
    const status = req.params[0].status;
    if(status == "O" || status == "A" || status == "Approved"){
      await UPDATE(PurchaseRequisition, ID).with({ status: "O" });
    }else{
      await UPDATE(PurchaseRequisition, ID).with({ status: "R" });
    }
    return {};
  });
});





