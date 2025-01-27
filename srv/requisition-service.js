const cds = require('@sap/cds');
const xml2js = require("xml2js");

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
    
    this.after('UPDATE', Item.drafts, async (req) => {

      let lv_unitPrice,lv_quantity;

      if('unitPrice' in req){
        lv_unitPrice = req.unitPrice;
        let result = await SELECT.from(Item.drafts)
          .columns('quantity')
          .where({ ID: req.ID });
        lv_quantity=result[0]?.quantity || 0;
      }else if('quantity' in req){
        lv_quantity = req.quantity;
        let result = await SELECT.from(Item.drafts)
          .columns('unitPrice')
          .where({ ID: req.ID });
        lv_unitPrice = result[0]?.unitPrice || 0;
      }   
      
      if(lv_quantity && lv_unitPrice){

        const req_ID = await SELECT.from(Item.drafts)
          .columns('requisition_ID')
          .where({ ID: req.ID });

          
        const items = await SELECT.from(Item.drafts)
        .columns('unitPrice', 'quantity')
        .where({ requisition_ID: req_ID[0].requisition_ID });

        let totalPrice = items.reduce((sum, item) => {
          const itemTotal = (item.unitPrice || 0) * (item.quantity || 0); 
          return sum + itemTotal;
        }, 0);
        
        await UPDATE(PurchaseRequisition.drafts, req_ID[0].requisition_ID).with({ totalPrice: totalPrice });
   
      }
  
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


  this.before('CREATE', Item.draft, async (req) => {
    
    const existingRecords = await cds.run(
      SELECT.from(Item).columns('itemNo').where({ requisition_ID: req.data.requisition_ID })
    );

    let maxNumber = 0;
    if (existingRecords.length > 0) {
      maxNumber = Math.max(...existingRecords.map(record => record.itemNo));
    }

    req.data.itemNo = maxNumber + 10;
  });

  this.after('CREATE', PurchaseRequisition, async (req) => {
    
    await UPDATE(PurchaseRequisition).set({ status: 'S' }).where({ ID: req.ID });
    
  });

  this.after('UPDATE', PurchaseRequisition, async (req) => {
    // console.log(req);

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


  this.on('sendForApproval',async (req)=>{
    const reqObj = await SELECT.one.from(PurchaseRequisition).where({ ID: req.params[0].ID })
    if(reqObj.status === 'O'){
      req.info("Request is Already Ordered :",req.params[0].ID);
      return {};
    }
    const requestItems = await SELECT`itemNo as ItemNo, itemDesc as ItemDesc, quantity as Quantity, unitPrice as ItemPrice, material_ID as Material, plant_ID as Plant`.from(Item).where({ requisition_ID: req.params[0].ID })
    var query0 = UPDATE(PurchaseRequisition).set({ status: 'I' }).where({ ID: req.params[0].ID });
    const updateStatus = await cds.tx(req).run(query0);
    //*Change Status to inApproval

    for (let item of requestItems) {
      item.ItemPrice = Number(item.ItemPrice);
      item.Quantity = Number(item.Quantity);
    }

    req.data = {
      "definitionId": "us10.buyerportalpoc-aeew31u1.projectfordirectrequisition.approval_Process",
      "context": {
      "request": {
          "Requests": {
            "requestno": reqObj.requestNo,
            "requestdesc": reqObj.description,
            "requestby": reqObj?.createdBy || "",
            "requestid": reqObj.ID,
            "totalprice": Number(reqObj.totalPrice),
            "requestitem": requestItems
          }
        }
      }
    };
    

    const WF_API = await cds.connect.to('direct_req_wf_api');
    const result = await WF_API.send('POST', '/public/workflow/rest/v1/workflow-instances', req.data);

    if (result.status) {
      req.info(`Workflow triggered successfully for Request ID: ${reqObj.ID};\n ` +
                `Flow Status: ${result.status};\n ` +
                `Total Price: ${reqObj.totalPrice}`);
    } else {
        req.error(500, "Failed to trigger the workflow");
    }
    
    return {};
    
  });

  this.on('ApproveRequest',async (req)=>{
    const ID = req.params[0].ID;
    const reqObj = await SELECT.one.from(PurchaseRequisition).where({ ID: ID })
    const requestItems = await SELECT`itemNo as itemno, itemDesc as itemdescr, quantity, unitPrice as unitprice, material_ID as material, plant_ID as plant`.from(Item).where({ requisition_ID: ID })

    for (const item of requestItems) {
      item.uom = "EA"; 
      item.PurchasingGroup = "001"; 
      item.netprice = String(Math.ceil(item.quantity * item.unitprice)); 
      item.quantity = Number(item.quantity);
      item.unitprice=String(Math.ceil(item.unitprice));
    };

    const payload = {
      "reqdesc": reqObj.description,
      "reqtype": "NB",
      "items":requestItems
    }

    const CPI_API = await cds.connect.to('direct_req_cpi');
    const result = await CPI_API.send('POST', '/direct/requisition', payload);

    //parsing the response from xml to json
    const parser = new xml2js.Parser();
    let parsedData;

    parser.parseString(result, (err, result) => {
      if (err) {
        console.error("Error parsing XML:", err);
        return;
      }

      parsedData = result;
    });
    
    setTimeout( async () => {
      const purchaseRequisition =parsedData.A_PurchaseRequisitionHeader.A_PurchaseRequisitionHeaderType[0].PurchaseRequisition[0];
      await UPDATE(PurchaseRequisition, ID).with({ PRNumber: purchaseRequisition });
    }, 100);

    await UPDATE(PurchaseRequisition, ID).with({ status: "O" });
   
    return {};
  });

  this.on('RejectRequest',async (req)=>{
    const ID = req.params[0].ID;
   
    await UPDATE(PurchaseRequisition, ID).with({ status: "R" });
   
    return {};
  });

});





