const cds = require("@sap/cds");
const cors = require("cors")

cds.on("bootstrap", (app) => {
    app.use(cors());
    app.get("/alive", (_,res) =>{
        res.status(200).send("servidor corriendo");
    });
});

module.exports = cds.server;