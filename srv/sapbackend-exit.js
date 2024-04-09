const cds = require("@sap/cds");

 module.exports = cds.service.impl(async function (srv) {
   const { Supplier } = srv.entities;
   const sapbackend = await cds.connect.to("sapbackend");
   srv.on("READ", Supplier, async (req) => {
     return await sapbackend.tx(req).send({
       query: req.query,
       headers: {
        authority: "refapp-espm-ui-cf.cfapps.eu10.hana.ondemand.com",
        Accept : "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8"
       },
     });
   });
});